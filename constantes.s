.equ UART_ADDRESS, 0x10001000
.equ RVALID_UART_MASK, 0x8000
.equ WSPACE_UART_MASK, 0xFFFF
.equ DATA_UART_MASK, 0x00FF
.equ ENTER_ASCII_VALUE, 0xA
.equ RED_LED_ADDRESS, 0x10000000
.equ TIMER, 0x10002000
.equ PUSHBUTTON, 0x10000050
.equ SWITCHES_ADDRESS, 0x10000040


# .org	0x500
#   INIT_TEXT:
#     .asciz "Entre com o comando:"
#   TESTE_TEXT:
#     .asciz "TESTE"
#   COMANDO_ACENDER_LED:
# 		.asciz "00"
# 	COMANDO_APAGAR_LED:
# 		.asciz "01"
# 	COMANDO_INICIAR_ANIMACAO:
# 		.asciz "10"
# 	COMANDO_PARAR_ANIMACAO:
# 		.asciz "11"
# 	COMANDO_INICIAR_CRONOMETRO:
# 		.asciz "20"
# 	COMANDO_CANCELAR_CRONOMETRO:
# 		.asciz "21"


#   vetor:
#     .skip 102
#   posicaoVetor:
#     .byte 0
#   comando:
#     .skip 3
#   parametro:
#     .skip 100
