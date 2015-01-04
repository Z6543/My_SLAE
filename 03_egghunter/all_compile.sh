#!/bin/bash
echo 'Usage ./all_compile.sh source_file pattern E.g. ./all_compile.sh eggh shellcode patt where eggh.nasm is the source file'

patt=`echo -n $3| xxd -p|sed -r s/\([0-9a-f]{2}\)\([0-9a-f]{2}\)\([0-9a-f]{2}\)\([0-9a-f]{2}\)/\\\4\\\3\\\2\\\1/`
echo pattern in reverse hex: $patt

cp $1.nasm $1.nasm_orig
sed s/0x68474765/0x$patt/g < $1.nasm > $1.nasm_
cp $1.nasm_ $1.nasm


echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $1.o $1.nasm

echo '[+] Linking ...'
ld -melf_i386 -o $1 $1.o

echo '[+] Dumping shellcode ...'

echo '' > shellcode.asm
for i in `objdump -d $1 | tr '\t' ' ' | tr ' ' '\n' | egrep '^[0-9a-f]{2}$' ` ; do echo -n "\x$i" >> shellcode1.asm; done


cp $2.nasm $2.nasm_orig
sed s/eGGh/$patt/g < $2.nasm > $2.nasm_

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $2.o $2.nasm

echo '[+] Linking ...'
ld -melf_i386 -o $2 $2.o

echo '[+] Dumping shellcode ...'

echo '' > shellcode.asm
for i in `objdump -d $2 | tr '\t' ' ' | tr ' ' '\n' | egrep '^[0-9a-f]{2}$' ` ; do echo -n "\x$i" >> shellcode2.asm; done


echo '[+] Creating new shellcode.c ...'

cat > shellcode.c <<EOF
#include<stdio.h>
#include<string.h>

unsigned char egg_hunter[] ="\\
EOF
#echo -n "\\" >> shellcode.c
cat shellcode1.asm >> shellcode.c

cat >> shellcode.c <<EOF
";

unsigned char code[] ="\\
EOF
#echo -n "\\" >> shellcode.c
cat shellcode2.asm >> shellcode.c

cat >> shellcode.c <<EOF
";

main()
{
	printf("Length of egg_hunter is %d\n",strlen(egg_hunter));
	printf("Length of shellcode is %d\n",strlen(code));
	(*(void  (*)()) egg_hunter)();
	return 0;
}
EOF

echo '[+] Compiling shellcode.c ...'
gcc -fno-stack-protector -z execstack -m32 -o shellcode shellcode.c

echo '[+] Done! Run ./shellcode to execute!'
