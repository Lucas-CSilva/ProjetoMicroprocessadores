############PILHA######################

.macro push
	addi sp,sp,-40
	stw ra,36(sp)
	stw fp,32(sp)
	stw r8,28(sp)
	stw r9,24(sp)
	stw r10,20(sp)
	stw r11,16(sp)
	stw r12,12(sp)
	stw r13,8(sp)
	stw r14,4(sp)
	stw r15,0(sp)
.endm

.macro pop
	ldw ra,36(sp)
	ldw fp,32(sp)
	ldw r8,28(sp)
	ldw r9,24(sp)
	ldw r10,20(sp)
	ldw r11,16(sp)
	ldw r12,12(sp)
	ldw r13,8(sp)
	ldw r14,4(sp)
	ldw r15,0(sp)
	addi sp,sp,40
.endm

.macro pushR reg
	addi sp,sp,-4
	stw \reg,0(sp)
.endm

.macro popR reg
	ldw \reg,0(sp)
	addi sp,sp,4
.endm
