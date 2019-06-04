.include "init.asm"
.include "ringbuffer.asm"

alloc_ringbuffer(rb0)

.text 0x00410000
#-------------------------------
# empty    20(sp)
# ra       16(sp)
# s1       12(sp)
# s0        8(sp)
# a1        4(sp)
# a0        0(sp)
#-------------------------------
main:
	addi $sp, $sp, -24
	sw   $s0, 8($sp)
	sw   $s1, 12($sp)
	sw   $ra, 16($sp)

	print_str("Hello Ringbuffer!\n")
	
	la  $a0, rb0
	jal rb_init
		
	print_str("Inserting data on Ringbuffer!\n")
	
	li $s0, 0	
main_for01:
	bge $s0, 8, main_for01_end

	la  $a0, rb0
	addi $a1, $s0, 65
	jal rb_write
	
	bne $v0, $zero, main_for01_if0_true
	print_str("Error - Ringbuffer full!\n")
main_for01_if0_true:
	
	addi $s0, $s0, 1
	b    main_for01
main_for01_end:

	print_str("Reading data from Ringbuffer!\n")

	li $s0, 0	
main_for02:
	bge $s0, 8, main_for02_end

	la  $a0, rb0
	jal rb_empty
	bne $v0, $zero, main_for02_if0_empty

	la  $a0, rb0
	jal rb_read
	move $s1, $v0
	
	print_str("Ringbuffer read = ")
	print_char($s1)
	print_str("\n")
	
	b    main_for02_if0_end
	
main_for02_if0_empty:
	print_str("Error - ringbuffer empty!\n")

main_for02_if0_end:	
	addi $s0, $s0, 1
	b    main_for02
main_for02_end:

	lw   $ra, 16($sp)
	lw   $s1, 12($sp)
	lw   $s0,  8($sp)
	addi $sp, $sp, 24
	jr $ra
#---------------------------------------
