#! /usr/bin/bash

nasm -g -f elf32 $1.asm -o $1.o
gcc -m32 $1.o -o $1

