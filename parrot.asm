# exit if user input begins with "#"
.data
init:	.asciiz "Parrot (Pulp Fiction inspired, motherfucker!)\n\n"
julesq:	.asciiz	"\nSay something, motherfucker!\n"
julesr: .ascii "Asshole said: "
string: .space 10

.text
	# Init
	addi $v0, $zero, 4	# print string service
	la $a0, init		# service parameter
	syscall
	
loop:	#Parrot
	addi $v0, $zero, 4	# print string service
	la $a0, julesq		# service parameter
	syscall
	
	# User
	addi $v0, $zero, 8	# read string service
	la $a0, string		# service parameter
	addi $a1, $zero, 10	# service parameter
	syscall
	
	#exit test
	la $t0, string		# user input string address
	lb $t1, 0 ($t0)		# load first char 
	addi $t2, $zero, 35	# 35 = #, in ascii
	bne $t1, $t2, reply	# if input!='#', keep running. Else, exit
	addi $v0, $zero, 10	# exit service
	syscall
	
reply:	# Parrot reply
	addi $v0, $zero, 4	# print string service
	la $a0, julesr		# service parameter
	syscall
	
	j loop
