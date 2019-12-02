addi 	a0,zero,12
sw	a0, 44(gp)
lw 	a3, 44(gp)

add a4, a3, a0

addi	a1,a0,18
addi	a2,a1,29
add 	a5, a1, a2

sw	a5, 48(gp)

add  	a2, a1, a0
sw	a2,44(zero)

