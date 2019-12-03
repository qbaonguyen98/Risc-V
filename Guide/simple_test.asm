addi 	a0,zero,12
addi 	a1,zero,12
addi 	a2,zero,9

beq	a0, a1, SAVE

bne 	a0, a1, LOOP

SAVE:
sw	a2, 44(zero)

LOOP:
addi	a1, a1, 1