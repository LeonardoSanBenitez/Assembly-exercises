# Author: Leonardo Benitez
# Date: 20/03/2019
# Brief
#	Read a text file with an "array of integers"
#	Just 1 digit integers, writen in sequence
#	Calculates the sum
# Variables map
#	s0: file descriptor
#	s1: sum
#	s2: counter
#	s3: maxCounter

.data
Dread:      .space 32
Dfilename:  .asciiz "data.txt"
.text
            li $v0, 13          # Open file service
            la $a0, Dfilename   # Service parameter: filename
            li $a1, 0           # Service parameter: read (0) or write (1)
            li $s2, 0           # Service parameter: mode?
            syscall
            move $s0, $v0	# save file descriptor

            li $v0, 14		# Read file service
            move $a0, $s0	# Service parameter: file descriotor
            la $a1, Dread	# Service parameter: buffer address
            li $a2, 32		# Service parameter: max lengh
            syscall
            move $s3, $v0	# save number of bytes read
            
            li   $v0, 16       # system call for close file
            move $a0, $s0      # file descriptor to close
            syscall            # close file
            
            addi $s3, $s3, -1
            la $t0, Dread	# t0 = base addr
while:      bge $s2, $s3, print	# while (count < maxCount)
	    lb $t1, 0($t0)	# t1 = A[i]
	    addi $t1, $t1, -48	# convert ascii to integer
	    add $s1, $s1, $t1	# sum += integer readed
	    addi $t0, $t0, 1	# ptr++
	    addi $s2, $s2, 1	# i++
	    j while

 
print: 
            li $v0, 1
            move $a0, $s1
            syscall
