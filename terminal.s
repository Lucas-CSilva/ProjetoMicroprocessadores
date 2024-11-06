/*
r8 - r15
r8 - uart-addrr
r9 - uart-data
r10 - uart-rvalid
r11 - uart-control
r12 - uart-wsapce
*/ 

.global _terminal
_terminal:
  movia	r8, UART_ADDRESS # move o endereço da JTAG UART para memoria
  POLLING_LEITURA:
  ldwio	r9, (r8) # move o conteudo de entrada para r9
  andi	r10, r9,	RVALID_UART_MASK #aplica a mascara para obter o RVALID
  beq		r10, r0, POLLING_LEITURA #enquanto o 
  POLLING_ESCRITA:
  andi r9, r9, DATA_UART_MASK
  ldwio r11, 4(r8) #obtem os registradores de controle
  andhi	r12, r11,	WSPACE_UART_MASK #mascara para obter o WSPACE(numero de espacoes disponiveis para escrita)
  beq r12, r0, POLLING_ESCRITA 
  stwio r9, (r8) #escreve de volta no terminal
  movia r13, ENTER_ASCII_VALUE 
  bne	r9,	r13, POLLING_LEITURA	
  ret

.equ UART_ADDRESS, 0x10001000
.equ RVALID_UART_MASK, 0x8000
.equ WSPACE_UART_MASK, 0xFFFF
.equ DATA_UART_MASK, 0x00FF
.equ ENTER_ASCII_VALUE, 0xA
