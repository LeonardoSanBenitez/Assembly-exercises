# if (( a > b ) && ( c == d ) )
#	a = b * a + c / d;
# else
#	a &= ( b | c ) ;
# Mapeamento de registradores
#	a -> $t0 , b -> $t1 , c -> $t2 , d -> $t3

	ble	$t0, $t1, else	# if (a<=b) goto else
	bne	$t2, $t3, else	# if (c!=d) goto else
	mul	$t0, $t0, $t1	# a = a*b
	div	$t2, $t3
	mflo	$t2		# c = c/d
	add	$t0, $t0, $t2	# a = a*b + c/d
	j end
else:
	or	$t1, $t1, $t2
	and	$t0, $t0, $t1
end: