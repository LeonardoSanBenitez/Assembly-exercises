# --------------------------------------- #
#  Libraries
# --------------------------------------- #
.text 0x00500000
.include "../libraries/bitmap.asm"
.include "../libraries/SyscallsFunctions.asm"
.include "../libraries/macros.asm"
.include "../libraries/init.asm"		# begin in 0x0040. Requires "macros.asm"

.text 0x00410000
#-------------------------------
# ra       20(sp)
# s1       16(sp)
# s0       12(sp)
# a2        8(sp)
# a1        4(sp)
# a0        0(sp)
#-------------------------------
main:
	addi $sp, $sp, -24
	sw   $s0, 12($sp)
	sw   $s1, 16($sp)
	sw   $ra, 20($sp)

	print_str("Hello Bitmap!\n")

	add $s0, $zero, $zero
main_L0:bge $s0, 64, main_L0_exit
	add $s1, $zero, $zero
main_L1:bge $s1, FB_LINES, main_L1_exit
	move $a0, $s0
	move $a1, $s1
	add  $a2, $s1, $zero
	sll  $a2, $a2, 8
	add  $a2, $s1, $a2
	sll  $a2, $a2, 8
	add  $a2, $s1, $a2
	jal  setPixel
	addi $s1, $s1, 1
	j    main_L1
main_L1_exit:
	addi $s0, $s0, 1
	j    main_L0
main_L0_exit:

	li  $s0, 64
main_L2:bge $s0, 128, main_L2_exit
	add $s1, $zero, $zero
main_L3:bge $s1, FB_LINES, main_L3_exit
	move $a0, $s0
	move $a1, $s1
	add  $a2, $s1, $zero
	sll  $a2, $a2, 16
	jal  setPixel
	addi $s1, $s1, 1
	j    main_L3
main_L3_exit:
	addi $s0, $s0, 1
	j    main_L2
main_L2_exit:

	li  $s0, 128
main_L4:bge $s0, 192, main_L4_exit
	add $s1, $zero, $zero
main_L5:bge $s1, FB_LINES, main_L5_exit
	move $a0, $s0
	move $a1, $s1
	add  $a2, $s1, $zero
	sll  $a2, $a2, 8
	jal  setPixel
	addi $s1, $s1, 1
	j    main_L5
main_L5_exit:
	addi $s0, $s0, 1
	j    main_L4
main_L4_exit:

	li  $s0, 192
main_L6:bge $s0, 256, main_L6_exit
	add $s1, $zero, $zero
main_L7:bge $s1, FB_LINES, main_L7_exit
	move $a0, $s0
	move $a1, $s1
	add  $a2, $s1, $zero
	jal  setPixel
	addi $s1, $s1, 1
	j    main_L7
main_L7_exit:
	addi $s0, $s0, 1
	j    main_L6
main_L6_exit:

	lw   $ra, 20($sp)
	lw   $s1, 16($sp)
	lw   $s0, 12($sp)
	addi $sp, $sp, 24
	jr $ra
#---------------------------------------
