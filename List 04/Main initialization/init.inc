.text 0x00400000
init:
	la		$sp, 0x7fffeffc
	jal		main
	move	$a0, $v0
	li 		$v0, 17
	syscall
