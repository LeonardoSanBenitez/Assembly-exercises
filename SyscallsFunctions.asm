.text 0x00500000
# void printInt(int n);
printInt:
  li $v0, 1
  syscall
  jr $ra

# void prinFloat (float n)
printFloat:
	lwc1	$f12, 0 ($a0)
	li	$v0, 2		# Service print float
	syscall
  jr $ra

# void printDouble (double n)
# n must be in $f12           TODO: PUXAR DE A0
printDouble:
  li	$v0, 3
  syscall
  jr $ra

# void printString(char* str);
printString:
  li $v0, 4
  syscall
  jr $ra

# int getInt();
getInt:
  li $v0, 5
  syscall
  jr $ra

# void getFloat ()
#result in $f0
getFloat:
  li	$v0, 6
  syscall
  #mfc0  $v0, $f0
  jr $ra

# void getDouble ()
#result in $f0        TODO: mandar para v0
getDouble:
  li	$v0, 7
  syscall
  jr $ra

# int getString(char * buf, int max_size);
getString:
  li $v0, 8
  syscall
  jr $ra

# void exit ()
exit:
  li	$v0, 17
  syscall
