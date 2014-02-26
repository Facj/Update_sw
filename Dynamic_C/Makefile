# Makefile for Dynamic_c library

PACKAGE	:= xdr-tests
VERSION	:= 1.0

CC	:= gcc
CFLAGS	:= -g -Wall -Wno-unused -Werror
LFLAGS	:= -static -L/usr/lib/debug/usr/lib64

all: structures.c structures.h  updatable up_2

#test1: test1.o test.o
#	$(CC) $(CFLAGS) $(LFLAGS) $^ -o $@

#test2: test2.o test.o
#	$(CC) $(CFLAGS) $(LFLAGS) $^ -o $@

structures.c: structures.x
	rm -f $@
	rpcgen -c -o $@ $<

structures.h: structures.x
	rm -f $@
	rpcgen -h -o $@ $<

updatable: updatable.c
	$(CC) $(CFLAGS) $(LFLAGS) $^ -o $@

up_2: up_2.c
	$(CC) $(CFLAGS) $(LFLAGS) $^ -o $@

clean:
	rm -f structures.c structures.h updatable

