# Title:	Exercice 07
# Author:	Leonardo Benitez
# Brief:	Buble sort in an integer array, in crescent order (the order can be easily changed in code)
# Varibles map
#	s0 (i) = outer counter
#	s1 (j) = inner counter
#	s2 (n) = array size
#	s3 = array addr
# Pseudo code C
#	for (i=4; i <= n-4 ; i+=4)
#	    for(j=0; j <= n - i - 4; j+=4)
#	        if(a[j] < a[j+4]){
#	            temp=a[j+4];
#	            a[j+4]=a[j];
#	            a[j]=temp;
#	        }


	## debug init
	addi $t0, $zero, 8
	addi $t1, $zero, 5
	addi $t2, $zero, 1
	addi $t3, $zero, 3
	addi $t4, $zero, 2
	addi $t5, $zero, 20
	addi $t6, $zero, 7
	addi $t7, $zero, 666
	
	sw $t0, 0 ($gp)
	sw $t1, 4 ($gp)
	sw $t2, 8 ($gp)
	sw $t3, 12 ($gp)
	sw $t4, 16 ($gp)
	sw $t5, 20 ($gp)
	sw $t6, 24 ($gp)
	sw $t7, 28 ($gp)
	## debug end
	
	addi $t0, $zero, 28	# array size (in bits)
	add $s3, $zero, $gp	# array addr: 0x00

	addi $s2, $t0, -4	# s2 = max comparation position
	addi $s0, $zero, 4	# i = 4
for1b:	bgt $s0, $s2, for1e 	# for (i=4; i <= n-4 ; i+=4)
	addi $s1, $zero, 0
for2b:	sub $t0, $s2, $s0
	bgt $s1, $t0, for2e	# for(j=0; j <= n - i - 4; j+=4)
	
	add $t0, $s1, $s3	# t0 = [j] addr
	lw $t1, 0($t0)		# t1 = a[j]
	lw $t2, 4($t0)		# t2 = a[j+4]	
	
	bge $t1, $t2, if1e	# if(a[j] < a[j+4])	## CHANGE ORDER HERE
	sw $t1, 4 ($t0)		# a[j+4]=a[j];
	sw $t2, 0 ($t0)		# a[j]= a[j+4] before change ;

if1e:	addi $s1, $s1, 4	# j+=4
	j for2b			# end of inner loop
	
for2e:
	addi $s0, $s0, 4	# i+=4
	j for1b			# end of outer loop
for1e: 