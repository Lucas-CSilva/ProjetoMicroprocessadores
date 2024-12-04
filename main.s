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
  andi r8, et, 2
  bne r8, r0, TRATAR_PUSHBUTTON

  CONTINUAR_INTERRUPCAO:
  andi r8, et, 1
  bne r8, r0, TRATAR_INTERRUPCAO
  
  END_HANDLER:
    # movia r10, TIMER
    # stb r0, 0(r10)
    pop
    eret

  .org 0x100

  OTHER_EXCEPTIONS:
    br END_HANDLER

  TRATAR_INTERRUPCAO:
    movia r9, animacao_enabled
    ldb r9, (r9)
    beq r9, r0, JMP_CALL_ANIMCAO
    call _iniciar_animacao
    JMP_CALL_ANIMCAO:

    movia r9, cronometro_enabled
    ldb r9, (r9)
    beq r9, r0, JMP_CALL_CRONOMETRO
    movia r11, count_temporizador #aumenta o contador referente ao cronometro. Sempre que uma interrupcao eh disparada quer dizer que se passaram 200ms 
    ldb r12, (r11) #carrega o valor do contador em memoria
    addi r12, r12, 1 #incrementa o valor
    stb r12, (r11)
    movi r13, 1 #move 5 para um registrador. Caso o contador seja 5 quer dizer que se passou 1s
    bne r12, r13, JMP_CALL_CRONOMETRO #caso 1s tenha se passado chama o cronometro
    stb r0, (r11) #zera o contador do cronometro
    call _cronometro_handler
    JMP_CALL_CRONOMETRO:
    
    movia r10, TIMER #zera o timer
    stb r0, 0(r10) #zera o timer
    br END_HANDLER

  TRATAR_PUSHBUTTON:
    movia r2, 0x10000040
    movia r3, 0x10000010
    movia r4, 0x10000050

    ldwio r14, 8(r4)         # carrega valor key2
    andi r14, r14, 0b010       # aplica mascara 
    beq r14, r0, CONTINUAR_INTERRUPCAO  # se = 0, KEY1 não foi pressionado

    movia r9, cronometro_enabled
    ldb r13, (r9)
    xori r13, r13, 1
    stb r13, (r9)

    stwio r0, 12(r4)
    br CONTINUAR_INTERRUPCAO
  

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

  .global cod_sete_segmentos
  cod_sete_segmentos:
    .byte 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f 

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

  .global cronometro_enabled
  cronometro_enabled:
    .byte 0
  
  .global _current_unid_time
  _current_unid_time:
    .byte 0

  .global _current_dez_time
  _current_dez_time:
    .byte 0

  .global _current_cent_time
  _current_cent_time:
    .byte 0

  .global _current_mil_time
  _current_mil_time:
    .byte 0
