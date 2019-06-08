# --------------------------------------- #
#  Libraries
# --------------------------------------- #
.text 0x00500000
.include "../SyscallsFunctions.asm"
.include "../macros.asm"
.include "../init.asm"		# begin in 0x0040. Requires "macros.asm"

# --------------------------------------- #
#  Global Variables
# --------------------------------------- #
.data

# --------------------------------------------------- #
# Main
# --------------------------------------------------- #
# Brief: push some elements, and then pop them
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




	lw	$ra, 8 ($sp)	# restore ra
	add	$sp, $sp, 8	# destroy stack (2 bytes)
	jr	$ra
