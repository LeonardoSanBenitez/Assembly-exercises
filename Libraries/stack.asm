.eqv STACK_MAX_SIZE 80 # 20 integers

#===========================================
# Alloc macro
.macro ALLOC_STACK (%name)
.data
.align 2
%name:  .space 4 # size
        .space STACK_MAX_SIZE
.end_macro

.text
#===========================================
# void stackInit (*stack)
stackInit:
	sw	$zero, 0($a0)        # size = 0
	jr	$ra

#===========================================
# int stackSize (*stack)
stackSize:
	lw	$v0, 0($a0)        # return stack->size
	jr	$ra

#===========================================
# int stackPop (*stack)
#===========================================
# Brief: return top element. The function does NOT verify if the stack is empty
# Stack
  # ra    4 (sp)
  # a0    0 (sp)
stackPop:
	addi	$sp, $sp, -8   # Alocando uma pilha com 8 bytes (4 para a0, 4 para ra)
	sw 	$ra, 4($sp)    # Salvo o registrador ra na pilha

	# read size
	jal	stackSize
	addi	$t1, $v0, -1
   	sw	$t1, 0($a0)	# stack->size = size -1

	# take the top element
	sll	$t0, $v0, 2
   	add	$t0, $a0, $t0
   	addi	$t0, $t0, 4	# t0 = top addr
   	lw	$v0, 0($t0)

   	lw	$ra, 4($sp)      # Restauro o valor do RA
	addi	$sp, $sp, 8      # Desaloco a pilha
	jr	$ra

#===========================================
# void stackPush (*stack, int n)
#===========================================
# Brief: add an element to the top. The function does NOT verify if the stack is full
# Stack
  # ra    4 (sp)
  # a0    0 (sp)
stackPush:
	addi	$sp, $sp, -8   # Alocando uma pilha com 8 bytes (4 para a0, 4 para ra)
	sw 	$ra, 4($sp)    # Salvo o registrador ra na pilha

	# read size
	jal	stackSize
	addi	$t1, $v0, 1
   	sw	$t1, 0($a0)	# stack->size = ++size

	# take the top element
	sll	$t0, $t1, 2
   	add	$t0, $a0, $t0
   	addi	$t0, $t0, 4	# t0 = top addr
   	sw	$a1, 0($t0)	# stack->array[stackSize()+1] = n

   	lw	$ra, 4($sp)      # Restauro o valor do RA
	addi	$sp, $sp, 8      # Desaloco a pilha
	jr	$ra
