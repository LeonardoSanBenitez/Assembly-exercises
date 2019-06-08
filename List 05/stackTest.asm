# --------------------------------------- #
#  Libraries
# --------------------------------------- #
.text 0x00500000
.include "../SyscallsFunctions.asm"
.include "../macros.asm"
.include "../stack.asm"
.include "../init.asm"		# begin in 0x0040. Requires "macros.asm"

ALLOC_STACK (stack01)

# --------------------------------------- #
#  Global Variables
# --------------------------------------- #
.data

# --------------------------------------------------- #
# Main
# --------------------------------------------------- #
# Brief: push some elements, and then pop them
# Pseudocode
  # for (i=0; stackSize; i++) stackPush (i)
  # for (i=0; i<stackSize; i++) print (stackPush())	# NÂO GOSTEI DESSE TESte
# Stack organization
  # |===========|
  # | empty     | 12 ($sp)
  # |-----------|
  # | $ra       | 8 ($sp)
  # |-----------|
  # | $a1       | 4 ($sp)
  # |-----------|
  # | $a0       | 0 ($sp)
  # |-----------|
.text 0x00410000
main:
	add	$sp, $sp, -16	# create stack (4 bytes)
	sw	$ra, 8 ($sp)	# save ra

	la	$a0, stack01
	jal	stackInit
	
	# push 10 items
	li	$s1, STACK_MAX_SIZE
	srl	$s1, $s1, 2		# conver Size from bytes to words
whilePush:
	la	$a0, stack01
	jal	stackSize
	bge	$v0, $s1, whilePop	# while (stackSize() != STACK_SIZE)
	move	$a1, $v0
	la	$a0, stack01  
	jal	stackPush		# stackPush (&stack01, stackSize())
	j	whilePush
whilePop:
	la	$a0, stack01
	jal	stackSize
	ble	$v0, $zero, mainEnd	# while (stackSize != 0) print (stackPop(&stack01))
	la	$a0, stack01
	jal 	stackPop
	move	$a0, $v0
	jal	printInt
	print_str(" ")
	j	whilePop
mainEnd:
	lw	$ra, 8 ($sp)	# restore ra
	add	$sp, $sp, 8	# destroy stack (2 bytes)
	jr	$ra
