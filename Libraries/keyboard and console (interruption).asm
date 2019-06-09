# Unfinished: I still dint implement the printString with interrupts

# --------------------------------------- #
#  Libraries
# --------------------------------------- #
.text 0x00500000
.include "ringbuffer.asm"
.include "macros.asm"
.include "exceptions.asm"

# --------------------------------------- #
#  Global variables
# --------------------------------------- #
# System flags (stored in memory)
  # 0(flags) = print
  # 4(flags) = ??  
.data
.align	2
flags:	.space 8
line:	.space 32	# must be bigger or equal than the ring buffer

alloc_ringbuffer(rb0)

# --------------------------------------- #
#  Main
# --------------------------------------- #
# stack:
  # a1        4(sp)
  # a0        0(sp)
# variables map
  # s0 = flags
.text 0x00400000
	addi 	$sp, $sp, -8
	
	# Interrupt enable
	li	$t0, 0xffff0000	# Mars keyboard and display base addr
	li	$t1, 0x00000002	# interrupt enable
	sw	$t1, 0($t0)	# keyboard
	sw	$t1, 8($t0)	# display
	
	# Init flags
	la	$s0, flags
	lw	$zero, 0($s0)
	lw	$zero, 4($s0)

	# Init ringbuffer	
	la  $a0, rb0
	jal rb_init

wait:	
	lw	$t0, 0($s0)
	bnez	$t0, print	# if (flagPrint == 1) print
	j	wait
	j 	wait	#BUG: se eu não botar o duplo jump e acontecer uma interrupção exatamente na instrução jump, o eret vem pra proxima e buga tudo 
	
	
print:	
	sw	$zero, 0($s0)	# flagPrint = 0
	
	# while (rb_empty == 0) *line=rb_read(rb0);line++;
	la	$s1, line	# s1 = array pointer
copy:	la	$a0, rb0
	jal	rb_empty
	bne	$v0, $zero, copyEnd
	
	la	$a0, rb0
	jal	rb_read
	move	$s2, $v0	# s2 = char
	
	sb	$s2, 0($s1)	# *line = char
	addi	$s1, $s1, 1	# line++	
	j	copy
copyEnd:	
	sb	$zero, 0($s1)	# *line = '\0'
	la	$a0, line
	jal	printString
	j	wait
	
	# Finish program
	li	$v0, 17			# Service terminate
	li	$a0, 0			# Service parameter (termination result)
	syscall	

	
# --------------------------------------- #
#  FUNCTION void printString (*string)
# --------------------------------------- #
# Brief: print in Mars Display an null terminated string
# Function prefix: PS
# Variables map
#   t0 = Mars keyboard and display base addr
printString:
	li	$t0, 0xffff0000	# Mars keyboard and display base addr

PSloop:		
	lw	$t1, 8 ($t0)	# load Control reg
	andi	$t1, 0x01
	beqz	$t1, PSloop	# banch if device not ready	 
	
	lb	$t1, 0 ($a0)
	beqz	$t1, PSend	# end if char='\0'
	
	sb	$t1, 12 ($t0)
	addi	$a0, $a0, 1
	j	PSloop
PSend:	
	jr	$ra
	

################################################################################################################
########################### Interrupt Service Routines #########################################################
# Optimization tip: here you dont need to restore saved register, because the SO already does that

# --------------------------------------------------- #
# FUNCTION ISR0
# --------------------------------------------------- #
# Brief: store keyboard readed char in the ring buffer. If receive '\n', set Print flag
# Function prefix: ISR0
# Caution: you cannot trust global registers
#variables map
  # s0 = Mars keyboard and display base addr
  # s1 = char (received by keyboad)
  # s2 = '\n'
# Stack organization
  # |===========|
  # | empty     | 12 ($sp)
  # |-----------|
  # | $ra       | 8 ($sp)
  # |-----------|
  # | $a1       | 4 ($sp) (available for the next function)
  # |-----------|
  # | $a0       | 0 ($sp) (available for the next function)
  # |-----------|
ISR0: 
	addi	$sp, $sp, -16	# create stack (4 bytes)
	sw	$ra, 8($sp)	# save ra
		
	li	$t0, 0xffff0000	# Mars keyboard and display base addr
	lw	$s1, 4 ($t0)	# s1 = char (received by keyboad)
	add	$s2, $zero, 10 	# s2 = '\n'
	
	# store char in buffer
	la  $a0, rb0	
	add $a1, $zero, $s1	
	jal rb_write	# rb_write (&rb0, char)
	
	# if (char == '\n') flagPrint = 1
	bne	$s1, $s2, ISR0end	
	la	$t1, flags
	li	$t0, 1
	sw	$t0, 0($t1)	# flagPrint = 1
ISR0end:
  	lw	$ra, 8($sp)	# restore ra
  	add	$sp, $sp, 16	# destroy stack (4 bytes)
	jr	$ra
	
# --------------------------------------------------- #
# FUNCTION ISR1
# --------------------------------------------------- #	
ISR1:

	jr	$ra
