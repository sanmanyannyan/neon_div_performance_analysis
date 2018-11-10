CC=gcc
CFLAGS=-O2 -mfpu=neon -march=native

run:div
	./div
div:div.c
	$(CC) $(CFLAGS) $< -o $@
div.s:div.c
	$(CC) -S $(CFLAGS) $< -o $@

.PHONY:clean run
clean:
	rm -f div.s div
