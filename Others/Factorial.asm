main:
	addi $a0, $zero, 4
	jal fatorial

	move $a0, $v0
	li  $v0, 17
	syscall



# int fatorial(unsigned int n){
#    if(n == 0) return 1;
#    return n * fatorial(n-1);
# }
#
# | $a0       | 8 ($sp) (quadro anterior)
# |===========|
# | $ra       | 4 ($sp)
# |-----------|
# | $a0       | 0 ($sp)
# |-----------|
fatorial:
     addiu $sp, $sp, -8
     sw    $a0, 8($sp)
     sw    $ra, 4($sp)

     li    $v0, 1
     beq   $a0, $zero, fatorial_end

     addiu $a0, $a0, -1
     jal fatorial

     lw  $a0, 8($sp)
     mul $v0, $a0, $v0

fatorial_end:
     lw $ra, 4($sp)
     addiu $sp, $sp, 8
     jr $ra
