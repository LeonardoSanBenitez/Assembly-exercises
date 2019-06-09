.eqv FB_ADDRESS 0x10040000
.eqv FB_LINES   256 
.eqv FB_COLS    256 

# void setPixel(int x0, int y0, int color)
setPixel:
	mul $t0, $a1, FB_COLS
	add $t0, $t0, $a0
	sll $t0, $t0, 2
	la  $t1, FB_ADDRESS
	add $t0, $t0, $t1
	sw  $a2, 0($t0)
	jr  $ra
###############################################



