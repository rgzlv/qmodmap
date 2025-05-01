#define _POSIX_C_SOURCE 200809L
// Workaround for Carbon related headers erroring on _POSIX_C_SOURCE
#define _DARWIN_C_SOURCE

#import <ctype.h>
#import <stdio.h>
#import <stdlib.h>
#import <stdint.h>
#import <string.h>
#import <limits.h>
#import <errno.h>
#import <unistd.h>
#import <err.h>

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "keys.h"

#define FLAG(v, fl) ((v & fl) == fl)

#define MOD_FROM_KEY(k1, k2, mod) ((k1 & mod) == (k2 & mod))

struct key {
	int kc;
	CGEventFlags mod;
};

struct map {
	struct key src;
	struct key dst;
};

struct key_pair {
	int kc;
	char *ksym;
};

#define X(ksym, kc) { kc, #ksym },
static struct key_pair key_pairs[] = {
	KEYS(X)
};
#undef X

int
ksym_to_kc(char *ksym)
{
	size_t sz;
	char *lksym;
	size_t i;

	sz = strlen(ksym);
	lksym = malloc(sz + 1);
	if (!lksym)
		err(1, NULL);
	for (i = 0; i < sz; i++)
		lksym[i] = tolower(ksym[i]);
	lksym[sz] = 0;
	for (i = 0; i < sizeof(key_pairs) / sizeof(key_pairs[0]); i++)
		if (!strcmp(key_pairs[i].ksym, lksym))
			return key_pairs[i].kc;
	return -1;
}

CGEventRef
evcb(CGEventTapProxy proxy, enum CGEventType type, CGEventRef ev, void *data)
{
	struct map **maps = (struct map **)data, **m;
	long kc;
	CGEventFlags mod;

	if (!FLAG(type, kCGEventKeyUp) && !FLAG(type, kCGEventKeyDown))
		return ev;
	kc = CGEventGetIntegerValueField(ev, kCGKeyboardEventKeycode);
	mod = CGEventGetFlags(ev);
	for (m = maps; *m; m++) {
		if (kc != (*m)->src.kc)
			continue;
		/* Skip if any of the modifiers don't match. */
		if (!MOD_FROM_KEY((*m)->src.mod, mod, kCGEventFlagMaskShift) ||
		    !MOD_FROM_KEY((*m)->src.mod, mod, kCGEventFlagMaskSecondaryFn) ||
		    !MOD_FROM_KEY((*m)->src.mod, mod, kCGEventFlagMaskControl) ||
		    !MOD_FROM_KEY((*m)->src.mod, mod, kCGEventFlagMaskAlternate) ||
		    !MOD_FROM_KEY((*m)->src.mod, mod, kCGEventFlagMaskCommand))
			continue;
		if ((*m)->dst.kc == KC_VOID)
			return NULL;
		CGEventSetIntegerValueField(ev, kCGKeyboardEventKeycode, (*m)->dst.kc);
		CGEventSetFlags(ev, (*m)->dst.mod);
	}
	return ev;
}

void
kmap_set_mod(struct key *key, int mod)
{
	switch (mod) {
	case kVK_Shift:
	case kVK_RightShift:
		key->mod |= kCGEventFlagMaskShift;
		break;
	case kVK_Function:
		key->mod |= kCGEventFlagMaskSecondaryFn;
		break;
	case kVK_Control:
	case kVK_RightControl:
		key->mod |= kCGEventFlagMaskControl;
		break;
	case kVK_Option:
	case kVK_RightOption:
		key->mod |= kCGEventFlagMaskAlternate;
		break;
	case kVK_Command:
	case kVK_RightCommand:
		key->mod |= kCGEventFlagMaskCommand;
		break;
	}
}

struct map *
kmap_read(char *line, size_t linenr)
{
	struct map *map;
	char *tok = line;

	tok = strtok(line, " \t");
	if (!tok || tok[0] == '!')
		return NULL;
	map = malloc(sizeof(*map));
	if (!map)
		err(1, NULL);
	map->src.kc = KC_UNDEF;
	map->src.mod = 0;
	for (;;) {
		int kc;

		kc = ksym_to_kc(tok);
		if (kc == -1)
			errx(1, "%zu: bad key \"%s\"", linenr, tok);
		if (KC_MOD(kc))
			kmap_set_mod(&map->src, kc);
		else if (map->src.kc == KC_UNDEF)
			map->src.kc = kc;
		else
			errx(1, "%zu: non-modifier key already set before \"%s\"", linenr, tok);
		tok = strtok(NULL, " \t");
		if (!tok)
			errx(1, "%zu: missing \"=\"", linenr);
		if (!strcmp(tok, "="))
			break;
	}
	tok = strtok(NULL, " \t");
	if (!tok)
		errx(1, "%zu: missing dst key", linenr);
	map->dst.kc = KC_UNDEF;
	map->dst.mod = 0;
	for (;;) {
		int kc;

		kc = ksym_to_kc(tok);
		if (kc == -1)
			errx(1, "%zu: bad key \"%s\"", linenr, tok);
		if (KC_MOD(kc))
			kmap_set_mod(&map->dst, kc);
		else if (map->dst.kc == KC_UNDEF)
			map->dst.kc = kc;
		else
			errx(1, "%zu: non-modifier key already set before \"%s\"", linenr, tok);
		tok = strtok(NULL, " \t");
		if (!tok)
			break;
	}
	return map;
}

struct map **
kmaps_read(char *path)
{
	FILE *f;
	struct map **maps;
	size_t mapsz = 0;
	char *line = NULL;
	size_t linenr;

	f = fopen(path, "rb");
	if (!f)
		err(1, "%s", path);
	maps = malloc(sizeof(*maps));
	if (!maps)
		err(1, NULL);
	*maps = NULL;
	for (linenr = 1;; linenr++) {
		size_t bufsz = 0;
		ssize_t sz;
		struct map *map;

		sz = getline(&line, &bufsz, f);
		if (sz == -1)
			break;
		line[sz - 1] = 0;
		map = kmap_read(line, linenr);
		if (!map)
			continue;
		maps = realloc(maps, sizeof(*maps) * (mapsz + 2));
		if (!maps)
			err(1, NULL);
		maps[mapsz] = map;
		mapsz++;
		maps[mapsz] = NULL;
	}
	free(line);
	return maps;
}

char *
kmaps_path(char *hint)
{
#define PATHSZ 4096
	char *path;

	path = malloc(PATHSZ);
	if (!path)
		err(1, NULL);
	if (hint) {
		char dir[4096];

		if (!getcwd(dir, sizeof(dir)))
			err(1, "getcwd");
		snprintf(path, PATHSZ, "%s/%s", dir, hint);
	} else {
		char *home;

		home = getenv("HOME");
		if (!home) {
			free(path);
			return NULL;
		}
		snprintf(path, PATHSZ, "%s/.qmodmaprc", home);
	}
	return path;
#undef PATHSZ
}

void
usage(void)
{
	puts("usage: qmodmap [FILE]");
	exit(1);
}

int
main(int argc, char **argv)
{
	char *path;
	struct map **maps;
	CFMachPortRef port;
	CFRunLoopSourceRef loopSrc;

	if (argv[1] && argv[1][0] == '-')
		usage();
	path = kmaps_path(argv[1]);
	if (!path)
		errx(1, "no filename argument and $HOME isn't set");
	maps = kmaps_read(path);
	free(path);
	port = CGEventTapCreate(kCGHIDEventTap,
	    kCGHeadInsertEventTap,
	    kCGEventTapOptionDefault,
	    CGEventMaskBit(kCGEventKeyDown) |
	    CGEventMaskBit(kCGEventKeyUp) |
	    CGEventMaskBit(kCGEventFlagsChanged),
	    evcb,
	    maps);
	if (!port)
		err(1, "CGEventTapCreate");
	loopSrc = CFMachPortCreateRunLoopSource(NULL, port, 0);
	if (!loopSrc)
		err(1, "CFMachPortCreateRunLoopSource");
	CFRunLoopAddSource(CFRunLoopGetCurrent(), loopSrc, kCFRunLoopCommonModes);
	CGEventTapEnable(port, 1);
	CFRunLoopRun();
	return 0;
}
