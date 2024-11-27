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


.org 0x20
  push
  rdctl	et, ipending
  beq et, r0, OTHER_EXCEPTIONS
  subi ea, ea, 4
  andi r8, et, 1
  bne r8, r0, TRATAR_TIMER
  call TRATAR_PUSH_BUTTON

  END_HANDLER:
    pop
    eret

  .org 0x100

  OTHER_EXCEPTIONS:
    br END_HANDLER

  TRATAR_PUSH_BUTTON:
    ret

  TRATAR_TIMER:
    movia r9, animacao_enabled
    beq r9, r0, END_HANDLER
    call _iniciar_animacao
    movia r10, TIMER
    stb r0, 0(r10)
    br END_HANDLER
  



.global _start
_start:
  movia sp, STACK #move o inicio da STACK para sp
  
  call _enable_interruption
  # call _start_temporizador


  READ_TERMINAL:
    movia r4, INIT_TEXT #move o texto inicial para r4
    pushR r4
    call _print_text
    popR r4
    call	_terminal
    br READ_TERMINAL


.org	0x500
  .global INIT_TEXT
  INIT_TEXT:
    .asciz "Entre com o comando:"
  
  .global TESTE_TEXT
  TESTE_TEXT:
    .asciz "TESTE"

  .global COMANDO_ACENDER_LED
  COMANDO_ACENDER_LED:
		.asciz "00"

	.global COMANDO_APAGAR_LED
  COMANDO_APAGAR_LED:
		.asciz "01"

	.global COMANDO_INICIAR_ANIMACAO
  COMANDO_INICIAR_ANIMACAO:
		.asciz "10"

	.global COMANDO_PARAR_ANIMACAO
  COMANDO_PARAR_ANIMACAO:
		.asciz "11"

	.global COMANDO_INICIAR_CRONOMETRO
  COMANDO_INICIAR_CRONOMETRO:
		.asciz "20"

	.global COMANDO_CANCELAR_CRONOMETRO
  COMANDO_CANCELAR_CRONOMETRO:
		.asciz "21"



  .global vetor
  vetor:
    .skip 102

  .global posicaoVetor
  posicaoVetor:
    .byte 0

  .global comando
  comando:
    .skip 3

  .global parametro
  parametro:
    .skip 100

  .global animacao_enabled
  animacao_enabled:
    .byte 0

  .global count_temporizador
  count_temporizador:
    .byte 0