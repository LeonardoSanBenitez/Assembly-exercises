.include "macros.asm"

.eqv STACK_ADDRESS 0x7FFFEFFC

.text 0x00400000
init:
     la $sp, STACK_ADDRESS
     jal main
     exit     	