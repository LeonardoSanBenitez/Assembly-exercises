# Author: Leonardo Benitez
# Date: 20/03/2019
# Brief: little calculator using floating point
# Variables map
#	$f12: acumulator
#	$f11: temporary result
#	$f0: result from syscall read float
# Coments
# 	The user input is generally a float, but in case "sum" it was done with int for pedagogical purposes

.data
Smenu: .asciiz "\n\n------------------\nChoose an option:\n1)Show acumulator\n2)Clean acumulator\n3)Sum\n4)Subtraction\n5)Division\n6)Multiplication\n7)Exit program\n"
SshowAC: .asciiz "\n\nThe acumulator value is: "
ScleanAC: .asciiz "\n\nThe acumulator was clear"
Ssum: .asciiz "\n\nEnter the number to sum with the acumulator: "
Ssubb: .asciiz "\n\nEnter the number to subtract with the acumulator: "
Sdivv: .asciiz "\n\nEnter the number to divide the acumulator by: "
Smultt: .asciiz "\n\nEnter the number to multiply with the acumulator: "
Sexit: .asciiz "\n\nI hope you enyoed the software, byebye."
Sdef: .asciiz "\n\nInvalid option, sorry."

Jtable: .word menu, showAC, cleanAC, sum, subb, divv, multt, exit

.text
menu:
	# Print header
	addi $v0, $zero, 4	# print string service
	la $a0, Smenu		# service parameter
	syscall
	
	# Read awnser
	addi $v0, $zero, 5	# read integer service (result in $v0)
	syscall 
	
	#check bounds
	ble $v0, $zero def	# if read>=0, default
	addi $t0, $zero, 7
	bgt $v0, $t0, def	# if read>7, default

	#translate case
	la $t0, Jtable
	mul $t1, $v0, 4
	add $t0, $t0, $t1
	lw $t2, 0 ($t0)
	jr $t2

## END OF MAIN LOOP ##	
	
showAC:
	# Print header
	addi $v0, $zero, 4	# print string service
	la $a0, SshowAC		# service parameter
	syscall
	
	addi $v0, $zero, 2	# print float service
	syscall
	
	j menu	
	
cleanAC:
	# Print header
	addi $v0, $zero, 4	# print string service
	la $a0, ScleanAC	# service parameter
	syscall
	
	mtc1 $zero, $f12
		
	j menu	
	
sum:
	# Print header
	addi $v0, $zero, 4	# print string service
	la $a0, Ssum		# service parameter
	syscall
	
	# Read awnser (integer)
	addi $v0, $zero, 5	# read integer service (result in $v0)
	syscall 
	
	# sum imput 
	mtc1 $v0, $f11
	cvt.s.w $f11, $f11
	add.s $f12, $f12, $f11
		
	j menu	

subb:
	# Print header
	addi $v0, $zero, 4	# print string service
	la $a0, Ssubb		# service parameter
	syscall
	
	# Read awnser
	addi $v0, $zero, 6	# read float service (result in $f0)
	syscall
	
	#operation
	sub.s $f12, $f12, $f0
	
	j menu
	
divv:
	# Print header
	addi $v0, $zero, 4	# print string service
	la $a0, Sdivv		# service parameter
	syscall

	# Read awnser
	addi $v0, $zero, 6	# read float service (result in $f0)
	syscall
	
	#operation
	div.s $f12, $f12, $f0
		
	j menu	
	
multt:
	# Print header
	addi $v0, $zero, 4	# print string service
	la $a0, Smultt		# service parameter
	syscall

	# Read awnser
	addi $v0, $zero, 6	# read float service (result in $f0)
	syscall
	
	#operation
	mul.s $f12, $f12, $f0
		
	j menu	
	
exit:
	# Print header
	addi $v0, $zero, 4	# print string service
	la $a0, Sexit		# service parameter
	syscall
	
	addi $v0, $zero, 10
	syscall
	
def: 
	# Print header
	addi $v0, $zero, 4	# print string service
	la $a0, Sdef		# service parameter
	syscall	
	
	j menu
