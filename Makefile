CC=gcc
CFLAGS=-O3 -march=native -mtune=cortex-a72

run:div div.s
	./div
div:div.c
	$(CC) $(CFLAGS) $< -o $@
div.s:div.c
	$(CC) -S $(CFLAGS) $< -o $@

.PHONY:clean run
clean:
	rm -f *.s div
