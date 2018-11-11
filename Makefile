CC=gcc
CFLAGS=-O3 -mfpu=neon-vfpv4 -march=armv7-a -mtune=cortex-a53

run:div div.s
	./div
div:div.c
	$(CC) $(CFLAGS) $< -o $@
div.s:div.c
	$(CC) -S $(CFLAGS) $< -o $@
div_hand_opt:div_hand_opt.s
	$(CC) $(CFLAGS) $< -o $@

.PHONY:clean run
clean:
	rm -f div.s div
