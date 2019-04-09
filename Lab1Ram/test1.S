##阶段1：测试基本寄存器运算
.org 0x0
 	.global _start
_start:
	addi t0,zero,1
	slli t1,t0,1
	sll  t2,t1,t1
	srli t2,t2,1
	srl  t2,t2,t0
	addi t2,t2,5
	srai t2,t2,1
	sra  t2,t2,t0
	sltu a0,t1,t2
	sltu a0,t2,t1
	sltiu a0,t1,4
	sltiu a0,t1,1
	slt  a0,t2,t0
	slt  a0,t0,t2
	slti a0,t2,-1
	slti a0,t0,-5
	ori  t0,t0,27
	or   t1,t1,t2
	andi t1,t1,15
	and  t1,t1,t2
	xori t1,t1,9
	xor t0,t0,t1
	add t2,t0,t1
	sub a0,t1,t0
	lui a1,8
	auipc a2,4
	
	
	


