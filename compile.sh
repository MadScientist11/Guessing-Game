#! /usr/bin/bash

nasm -g -f elf32 guessing_game.asm -o guessing_game.o
nasm -g -f elf32 std_extensions.asm -o std_extensions.o
gcc -m32 guessing_game.o std_extensions.o -o guessing_game

