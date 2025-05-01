LDFLAGS = -framework Foundation -framework CoreGraphics $(XLDFLAGS)

qmodmap: qmodmap.o

qmodmap.o: qmodmap.m keys.h

clean:
	rm -f qmodmap qmodmap.o
