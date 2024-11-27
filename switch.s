.include "stack.s"
.include "constantes.s"

.global _read_comand
_read_comand:
  push
  movia r8, comando # carrega o comando para o r8
  movia r9, COMANDO_ACENDER_LED
  pushR r8
  pushR r9
  call _check_comand
  popR r8
  popR r9
  bne r4, r0, comando_acender_led

  br fim_read_comand

  comando_acender_led:
  call TESTE
  br fim_read_comand

  fim_read_comand:
  
  call _flush
  pop
  ret

_check_comand:
  push
  ldw r8, 40(sp)
  ldw r9, 44(sp)
  movi r4, 1
  loop_compare:
  ldb r10, (r8) # move constante do comando para r10
  ldb r11, (r9) # move comando de entrada para r11
  bne r10, r11, comando_diferente
  addi r8, r8, 1
  addi r9, r9, 1
  beq r11, r0, fim_compare
  br loop_compare

  comando_diferente:
  mov r4, r0

  fim_compare:
  pop
  ret

_flush:
  push
  movia r8, vetor #move o vetor para r8
  movi r9, 102 #numero de itens no vetor
  movi r10, 0 #inicia o contador com 0
  loop_flush_vetor:
    stb r0, (r8)
    addi r8, r8, 1
    addi r10, r10, 1
    blt	 r10,	r9, loop_flush_vetor

  movia r8, posicaoVetor
  stb r0, (r8)

  movia r8, comando
  stb r0, (r8)
  stb r0, 1(r8)
  stb r0, 2(r8)

  movia r8, parametro
  movi r9, 100
  movi r10, 0

  loop_flush_parametro:
    stb r0, (r8)
    addi r8, r8, 1
    addi r10, r10, 1
    blt	 r10,	r9, loop_flush_parametro

  pop
ret

TESTE:
  push

  movia r4, TESTE_TEXT #move o texto inicial para r4
  pushR r4
  call _print_text
  popR r4

  pop
ret
    