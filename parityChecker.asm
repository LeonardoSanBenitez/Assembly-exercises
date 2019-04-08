# Title:    Parity error detecting
# Author:   Leonardo Benitez
# Brief
#   Check if a word (32bits) it's even or odd
#   Parity even: even number of 1's in the word
#   Parity odd: odd number
# Variables Map
#   s0 = word to be verified
#   s1 = parity result (even=0, odd=1)
#   s2 = sum
#   t0 = loop count
# Pseudocode
#   for (i=0; i<32; i++){
#       temp = 0x00000001 | (s0>>i)
#       sum += temp
#   } if (sum%2!=0) s1=1

# debug
li $s0, 0x00000007F
# end debug

        li $t1, 32            		# $t1 = 32
LOOP:   bge $t0, $t1, END		# while (i < 32)
        srlv $t2, $s0, $t0
        andi $t2, $t2, 0x00000001	# take the last bit
        add $s2, $s2, $t2		# acumulate
        addi $t0, $t0, 1
        j LOOP
END:	
	li $t3, 2
	div $s2, $t3
	mfhi $s1
	
	