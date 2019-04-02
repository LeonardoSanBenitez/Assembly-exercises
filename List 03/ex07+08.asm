
## Original assembly
LOOP:
        addi $t1, $0 , $0
        lw $s1, 0( $s0 )
        add $s2, $s2 , $s1
        addi $s0, $s0 , 4
        addi $t1, $t1 , 1
        slti $t2, $t1 , 100
        bne $t2, $s0 , LOOP

## Reduced assembly
LOOP:
        lw $s1, 0($s0)          # s1 = loadFrom s0
        add $s2, $s2 , $s1      # s2 += s1
        addi $s0, $s0 , 4       # s0+=4
        li $t2, 1
        bne $t2, $s0 , LOOP     # if (s0!=1) goto loop


## C equivalent
do {
    $s2 += *$s0;
    $s0++;
} while ($s0 != 1)
