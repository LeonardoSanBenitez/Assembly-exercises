.data
vec:	.asciiz	"Mars is shit \n\n"
line:	.space 32
.text
	#la	$a0, vec
	#jal	printString
	
	#jal	getChar
	#add	$a0, $v0, $zero
	#jal	printChar
	
	la	$a0, line
	li	$a1, 32
	jal	getLine
	
	la	$a0, line
	jal	printString
	
	# Finish program
	li	$v0, 17			# Service terminate
	li	$a0, 0			# Service parameter (termination result)
	syscall	

# --------------------------------------- #
#  FUNCTION void printChar (char)
# --------------------------------------- #
# Brief: print in Mars Display an single char (in ascii)
# Function prefix: PC
# Variables map
#   t0 = Mars keyboard and display base addr
printChar:
	li	$t0, 0xffff0000	# Mars keyboard and display base addr
PCloop:		
	lw	$t1, 8 ($t0)	# load Control reg
	andi	$t1, 0x01
	beqz	$t1, PCloop	# banch if device not ready	 
	
	sb	$a0, 12 ($t0)
	nop			# nops for debug
	nop
	nop
	nop
	nop
	jr	$ra
	
	
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
	nop			# nops for debug
	nop
	nop
	nop
	nop
	j	PSloop
PSend:	
	jr	$ra
	
# --------------------------------------- #
#  FUNCTION char getChar ()
# --------------------------------------- #
# Brief: read char from Mars Keyboard
# Function prefix: GC
# Variables map
#   t0 = Mars keyboard and display base addr
getChar:
	li	$t0, 0xffff0000	# Mars keyboard and display base addr
	
GCloop:		
	lw	$t1, 0 ($t0)	# load Control reg
	andi	$t1, 0x01
	beqz	$t1, GCloop	# banch if device not ready
	
	lw	$v0, 4 ($t0)	
	nop			# nops for debug
	nop
	nop
	nop
	nop
	
	jr	$ra
	
	
# --------------------------------------------------- #
#  FUNCTION void getLine (char* buffer, int max)
# --------------------------------------------------- #
# Brief: read an intire line (until \n) from Mars Keyboard
# Function prefix: GL
# Variables map
#   t0 = Mars keyboard and display base addr
#   t1 = control
#   t3 = '\n' (constant)
#   t4 = 1 (constant)
	
getLine:
	li	$t0, 0xffff0000	# Mars keyboard and display base addr
	add	$t3, $zero, 10 	# t3 = '\n'
	addi	$t4, $zero, 1
	
GLloop:	
	ble	$a1, $t4, GLend	# out if i<=1 (guarda espaço pro '\0')
	
	lw	$t1, 0 ($t0)	# load Control reg
	andi	$t1, 0x01
	beqz	$t1, GLloop	# banch if device not ready
	
	lw	$t2, 4 ($t0)	
	beq	$t2, $t3, GLend
	sb	$t2, 0 ($a0)
	addi	$a0, $a0, 1	# a0++
	addi	$a1, $a1, -1	# max--
	j	GLloop
GLend:
	sb	$zero, 0 ($a0)	# null terminate string
	jr	$ra
	
	
	
	
	
	
	
	
	
	
	
