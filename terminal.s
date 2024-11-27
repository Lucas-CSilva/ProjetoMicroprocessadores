/*
r8 - r15
r8 - uart-addrr
r9 - uart-data
r10 - uart-rvalid
r11 - uart-control
r12 - uart-wsapce
*/ 

.include "stack.s"
.include "constantes.s"

.global _terminal
_terminal:
  push
  movia	r8, UART_ADDRESS # move o endereço da JTAG UART para memoria
  movia r15, posicaoVetor #move o index do vetor para r15
  POLLING_LEITURA:
  movia r14, vetor #move o endereço do inicio do vetor para r14
  ldb r13, (r15) # carrega r13 com o index do vetor (r15)
  ldwio	r9, (r8) # move o conteudo de entrada para r9
  andi	r10, r9,	RVALID_UART_MASK #aplica a mascara para obter o RVALID
  beq		r10, r0, POLLING_LEITURA # se RVALID for 0, entao recomeça o loop
  POLLING_ESCRITA:
  andi r9, r9, DATA_UART_MASK # aplica mascara para obter DATA
  ldwio r11, 4(r8) #obtem os registradores de controle
  andhi	r12, r11,	WSPACE_UART_MASK #mascara para obter o WSPACE(numero de espacoes disponiveis para escrita)
  beq r12, r0, POLLING_ESCRITA # se WSPACE for 0, entao nao ha espaço disponivel para escrita 
  stbio r9, (r8) #escreve de volta no terminal
  add r14, r14, r13 # atualiza a posicao de escrita
  stb r9, (r14) # salva no vetor o caracter lido no terminal
  addi r13, r13, 1 # incrementa uma posicao no index
  stb r13, (r15) # salva a posicao na memória
  movia r12, ENTER_ASCII_VALUE # move o valor ASCII da tecla Enter para r12
  bne	r9,	r12, POLLING_LEITURA # enquanto o caracter lido nao for Enter, continua a leitura
  call _read_input #caso o caracter digitado for Enter, entao chama read_input
  pop	
ret

/*
  r8 - vetor
  r9 - comando / parametro
  r10 - auxiliar para carregar e amazenar o comando
  r11 - enter
*/
_read_input:
  push
  movia r8, vetor # move o endereço do inicio do vetor para r8        
  movia r9, comando # move o endereço de comando para r9        
  ldb r10, (r8) # carregando a primeira parte do comando para r10
  stb r10, (r9) # armazenando a primeira parte do comando em r9
  ldb r10, 1(r8) # carregando a segunda parte do comando para r10
  stb r10, 1(r9) # armazenando a segunda parte do comando em r9
  movia r9, parametro # move o endereco do parametro (segunda parte do comando) para r9
  addi r8, r8, 3 # a terceira posicao do comando é um espaço em branco, entao deve ser pulado (3)
  movi r11, ENTER_ASCII_VALUE # r11 recebe o valor ASCII da tecla Enter
  Loop_read_input:
  ldb r10, (r8) # coloca em r10 o valor
  beq r10, r0, fimLoop_read_input # caso nao exista nenhum parametro, sai do loop
  beq r10, r11, fimLoop_read_input # caso o caracter lido for um Enter, entao sai do loop
  stb r10, (r9) # salva o valor lido no endereco de parametro 
  addi r8, r8, 1 # avança para a proxima posicao de entrada
  addi r9, r9, 1 # avança para a proxima posicao de parametro
  br Loop_read_input
  fimLoop_read_input:
  
  call _read_comand
  pop
ret

_read_comand:
  push

  movia r8, comando # carrega o comando para o r8

  movia r9, COMANDO_ACENDER_LED
  pushR r8
  pushR r9
  call _check_comand
  popR r9
  popR r8
  bne r4, r0, comando_acender_led

  movia r9, COMANDO_APAGAR_LED
  pushR r8
  pushR r9
  call _check_comand
  popR r9
  popR r8
  bne r4, r0, comando_apagar_led
  bne r4, r0, comando_acender_led

  movia r9, COMANDO_INICIAR_ANIMACAO
  pushR r8
  pushR r9
  call _check_comand
  popR r9
  popR r8
  bne r4, r0, comando_iniciar_animacao

  br fim_read_comand

  comando_acender_led:
  call _acender_led
  br fim_read_comand

  comando_apagar_led:
  call _apagar_led
  br fim_read_comand

  comando_iniciar_animacao:
  movia r11, animacao_enabled
  movi r12, 1
  stb r12, (r11)

  br fim_read_comand
  
  fim_read_comand:
  call _flush
  pop
  ret

# TESTE:
#   push

#   movia r4, TESTE_TEXT #move o texto inicial para r4
#   pushR r4
#   call _print_text
#   popR r4

#   pop
#   ret

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
  