# Title:    Parity error detecting
# Author:   Leonardo Benitez
# Brief
#   Check if a word (32bits) it's even or odd
#   Parity even: even number of 1's in the word
#   Parity odd: odd number
# Variables Map
#   s0 = word to be verified
#   $s1 = parity result (even=0, odd=1)
# Pseudocode
#   for (i=0; i<32; i++){
#       temp = 0x00000001 | (s0>>i)
#       sum += temp
#   } if (sum%2!=0) s1=1 
