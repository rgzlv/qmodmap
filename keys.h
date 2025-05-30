#ifndef QMODMAP_KEYS_H
#define QMODMAP_KEYS_H

#import <Carbon/Carbon.h> /* HIToolbox's Events.h is the one that has the keycodes */

/* For parsing, not ignored but undefined temporarily */
#define KC_UNDEF (-10)

/* Ignored */
#define KC_VOID (-20)

#define KC_MOD(kc) ( \
	kc == kVK_Shift || \
	kc == kVK_RightShift || \
	kc == kVK_Function || \
	kc == kVK_Control || \
	kc == kVK_RightControl || \
	kc == kVK_Option || \
	kc == kVK_RightOption || \
	kc == kVK_Command || \
	kc == kVK_RightCommand \
)

/* Keysym (xmodmap syntax), keycode (MacOS) */
#define KEYS(X) \
	X(voidsymbol, KC_VOID) \
	X(a, kVK_ANSI_A) \
	X(s, kVK_ANSI_S) \
	X(d, kVK_ANSI_D) \
	X(f, kVK_ANSI_F) \
	X(h, kVK_ANSI_H) \
	X(g, kVK_ANSI_G) \
	X(z, kVK_ANSI_Z) \
	X(x, kVK_ANSI_X) \
	X(c, kVK_ANSI_C) \
	X(v, kVK_ANSI_V) \
	X(b, kVK_ANSI_B) \
	X(q, kVK_ANSI_Q) \
	X(w, kVK_ANSI_W) \
	X(e, kVK_ANSI_E) \
	X(r, kVK_ANSI_R) \
	X(y, kVK_ANSI_Y) \
	X(t, kVK_ANSI_T) \
	X(1, kVK_ANSI_1) \
	X(2, kVK_ANSI_2) \
	X(3, kVK_ANSI_3) \
	X(4, kVK_ANSI_4) \
	X(6, kVK_ANSI_6) \
	X(5, kVK_ANSI_5) \
	X(equal, kVK_ANSI_Equal) \
	X(9, kVK_ANSI_9) \
	X(7, kVK_ANSI_7) \
	X(minus, kVK_ANSI_Minus) \
	X(8, kVK_ANSI_8) \
	X(0, kVK_ANSI_0) \
	X(bracketright, kVK_ANSI_RightBracket) \
	X(o, kVK_ANSI_O) \
	X(u, kVK_ANSI_U) \
	X(bracketleft, kVK_ANSI_LeftBracket) \
	X(i, kVK_ANSI_I) \
	X(p, kVK_ANSI_P) \
	X(l, kVK_ANSI_L) \
	X(j, kVK_ANSI_J) \
	X(quotedbl, kVK_ANSI_Quote) \
	X(k, kVK_ANSI_K) \
	X(semicolon, kVK_ANSI_Semicolon) \
	X(backslash, kVK_ANSI_Backslash) \
	X(comma, kVK_ANSI_Comma) \
	X(slash, kVK_ANSI_Slash) \
	X(n, kVK_ANSI_N) \
	X(m, kVK_ANSI_M) \
	X(period, kVK_ANSI_Period) \
	X(grave, kVK_ANSI_Grave) \
	X(kp_decimal, kVK_ANSI_KeypadDecimal) \
	X(kp_multiply, kVK_ANSI_KeypadMultiply) \
	X(kp_add, kVK_ANSI_KeypadPlus) \
	X(clear, kVK_ANSI_KeypadClear) \
	X(kp_divide, kVK_ANSI_KeypadDivide) \
	X(kp_enter, kVK_ANSI_KeypadEnter) \
	X(kp_subtract, kVK_ANSI_KeypadMinus) \
	X(kp_equal, kVK_ANSI_KeypadEquals) \
	X(kp_0, kVK_ANSI_Keypad0) \
	X(kp_1, kVK_ANSI_Keypad1) \
	X(kp_2, kVK_ANSI_Keypad2) \
	X(kp_3, kVK_ANSI_Keypad3) \
	X(kp_4, kVK_ANSI_Keypad4) \
	X(kp_5, kVK_ANSI_Keypad5) \
	X(kp_6, kVK_ANSI_Keypad6) \
	X(kp_7, kVK_ANSI_Keypad7) \
	X(kp_8, kVK_ANSI_Keypad8) \
	X(kp_9, kVK_ANSI_Keypad9) \
	X(return, kVK_Return) \
	X(tab, kVK_Tab) \
	X(space, kVK_Space) \
	X(delete, kVK_Delete) \
	X(escape, kVK_Escape) \
	X(super_l, kVK_Command) \
	X(shift_l, kVK_Shift) \
	X(caps_lock, kVK_CapsLock) \
	X(alt_l, kVK_Option) \
	X(control_l, kVK_Control) \
	X(super_r, kVK_RightCommand) \
	X(shift_r, kVK_RightShift) \
	X(alt_r, kVK_RightOption) \
	X(control_r, kVK_RightControl) \
	X(function, kVK_Function) \
	X(f17, kVK_F17) \
	X(86xk_audioraisevolume, kVK_VolumeUp) \
	X(86xk_audiolowervolume, kVK_VolumeDown) \
	X(86xk_audiomute, kVK_Mute) \
	X(f18, kVK_F18) \
	X(f19, kVK_F19) \
	X(f20, kVK_F20) \
	X(f5, kVK_F5) \
	X(f6, kVK_F6) \
	X(f7, kVK_F7) \
	X(f3, kVK_F3) \
	X(f8, kVK_F8) \
	X(f9, kVK_F9) \
	X(f11, kVK_F11) \
	X(f13, kVK_F13) \
	X(f16, kVK_F16) \
	X(f14, kVK_F14) \
	X(f10, kVK_F10) \
	X(86xk_contextmenu, kVK_ContextualMenu) \
	X(f12, kVK_F12) \
	X(f15, kVK_F15) \
	X(help, kVK_Help) \
	X(home, kVK_Home) \
	X(page_up, kVK_PageUp) \
	X(kp_delete, kVK_ForwardDelete) \
	X(f4, kVK_F4) \
	X(end, kVK_End) \
	X(f2, kVK_F2) \
	X(page_down, kVK_PageDown) \
	X(f1, kVK_F1) \
	X(leftarrow, kVK_LeftArrow) \
	X(rightarrow, kVK_RightArrow) \
	X(downarrow, kVK_DownArrow) \
	X(uparrow, kVK_UpArrow) \
	X(section, kVK_ISO_Section)

#endif
