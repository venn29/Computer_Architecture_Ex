##阶段1：测试基本寄存器运算 x5 是5号寄存器,x6是6号，x7是7号,
####1963=0x07ab
.org 0x0
 	.global _start
_start:
	addi x5,zero,0
	nop
	nop
	nop
	nop
	nop
	addi x6,zero,1963
	nop
	nop
	nop
	nop
	nop
	sb x6,0(x5)
	nop
	nop
	nop
	nop
	nop
	sb x6,1(x5)
	nop
	nop
	nop
	nop
	nop
	sb x6,2(x5)	
	nop
	nop
	nop
	nop
	nop
	sb x6,3(x5)
	nop
	nop
	nop
	nop
	nop

	addi x1,zero,1
	nop
	nop
	nop
	nop
	nop
	addi x2,zero,1
	nop
	nop
	nop
	nop
	nop
	beq x1,x2,eq
	nop
	nop
	nop
	nop
	nop
	addi x7,zero,1
	nop
	nop
	nop
	nop
	nop
eq:
	addi x5,x5,4
	nop
	nop
	nop
	nop
	nop
	sh x6,0(x5)
	nop
	nop
	nop
	nop
	nop
	addi x5,x5,4
	nop
	nop
	nop
	nop
	nop
	sh x6,1(x5)
	nop
	nop
	nop
	nop
	nop
	addi x5,x5,4
	nop
	nop
	nop
	nop
	nop
	sh x6,2(x5)
	nop
	nop
	nop
	nop
	nop

	
	addi x1,x1,-2
	nop
	nop
	nop
	nop
	nop
	bne x1,x2,ne
	nop
	nop
	nop
	nop
	nop
	addi x7,x7,1
	nop
	nop
	nop
	nop
	nop

ne:
	 addi x5,x5,4
	nop
	nop
	nop
	nop
	nop
	sw x6,0(x5)
	nop
	nop
	nop
	nop
	nop
	
	blt x1,x2,lt
	nop
	nop
	nop
	nop
	nop
	addi x7,x7,1
	nop
	nop
	nop
	nop
	nop

lt:
	andi x5,x5,0
	nop
	nop
	nop
	nop
	nop
	addi x5,x5,8
	nop
	nop
	nop
	nop
	nop
	lb x20,1(x5)
	nop
	nop
	nop
	nop
	nop
	lbu x21,1(x5)
	nop
	nop
	nop
	nop
	nop
	
	bge x2,x1,ge
	nop
	nop
	nop
	nop
	nop
	addi x7,x7,1
	nop
	nop
	nop
	nop
	nop

ge:
	lh x22,0(x5)
	nop
	nop
	nop
	nop
	nop
	lhu x23,0(x5)
	nop
	nop
	nop
	nop
	nop
	bltu x2,x1,ltu
	nop
	nop
	nop
	nop
	nop
	addi x7,x7,1
	nop
	nop
	nop
	nop
	nop

ltu:
	lw x25,0(x5)
	nop
	nop
	nop
	nop
	nop
	bgeu x1,x2,geu
	nop
	nop
	nop
	nop
	nop
	addi x7,x7,1
	nop
	nop
	nop
	nop
	nop

geu:
	jal x30,finish
	nop
	nop
	nop
	nop
	nop
	addi x7,x7,1
	nop
	nop
	nop
	nop
	nop
finish:
	addi x30,zero,1024
	nop
	nop
	nop
	nop
	nop
	jalr x31,x30,1024
	
	
	
	


	
	


