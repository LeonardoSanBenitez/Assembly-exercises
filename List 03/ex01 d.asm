q = 10;
    while ( q ) {
    a += a * q ;
    q - -;
}
// # Mapeamento de registradores
// # a -> $t0 e q -> $t1


        li $t1, 10
while:  ble $t1, DONE
        mul $t2, $t0, $t1
        add $t0, $t0, $t2
        addi $t1, $t1, -1
        j while
DONE:
