.include "init.inc"


.data
ask_number: .asciiz "Digite um número: "
response:   .asciiz "O fatorial é: "

.text
# int main();
# |-----------|
# | empty     | 12 ($sp)
# |-----------|
# | $ra       | 8 ($sp)
# |-----------|
# | $s0       | 4 ($sp)
# |-----------|
# | $a0       | 0 ($sp)
# |-----------|
main:
    addiu $sp, $sp, -16
    sw    $s0, 4($sp)
    sw    $ra, 8($sp)

    la $a0, ask_number
    jal printString

    jal get_int

    move $a0, $v0
    jal fatorial
    move $s0, $v0

    la $a0, response
    jal printString

    move $a0, $s0
    jal print_int

    move $v0, $zero
    lw $ra, 8($sp)
    lw $s0, 4($sp)
    addiu $sp, $sp, 16
    jr  $ra
#--------------------------------------------

# int get_int();
get_int:
    li $v0, 5
    syscall
    jr $ra

# void print_int(int v);
print_int:
    li $v0, 1
    syscall
    jr $ra

# int getString(char * buf, int max_size);
getString:
    li $v0, 8
    syscall
    jr $ra

# void printString(char * str);
printString:
    li $v0, 4
    syscall
    jr $ra

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
