/*
r16 - r23
r16 - add texto de entrada
r17 - 
r18 - 
r19 - 
r20 - 
*/

.include "stack.s"
.include "constantes.s"

.equ		STACK,		0x10000

.global _start
_start:
  movia sp, STACK #move o inicio da STACK para sp

  READ_TERMINAL:
    movia r4, INIT_TEXT #move o texto inicial para r4
    pushR r4
    call _print_text
    popR r4
    call	_terminal
    br READ_TERMINAL





