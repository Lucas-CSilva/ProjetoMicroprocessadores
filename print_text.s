/*
r8 - r15
r8 - uart-addrr
r9 - uart-data
r10 - uart-rvalid
r11 - uart-control
r12 - uart-wsapce
*/ 

.global _print_text
_print_text:
    ldw r9, (sp)           # Carrega o endereço da string que está na pilha

    movia r8, UART_ADDRESS   # Move o endereço da JTAG UART para r8
POLLING_ESCRITA:
    ldb r10, (r9)           # Carrega o próximo byte da string (em r10)
    beq r10, r0, END_PRINT_TEXT  # Se for nulo (fim da string), saia da função

    # Verifica se há espaço disponível na UART para escrever
    ldwio r11, 4(r8)        # Lê o registrador de controle da UART
    andi r12, r11, WSPACE_UART_MASK # Máscara para obter WSPACE (número de espaços disponíveis para escrita)
    beq r12, r0, POLLING_ESCRITA # Se não houver espaço, espera

    stwio r10, (r8)         # Escreve o byte no terminal
    addi r9, r9, 1          # Avança para o próximo byte da string
    br POLLING_ESCRITA      # Continua o loop para o próximo byte

END_PRINT_TEXT:
    ret                      # Retorna da subrotina



.equ UART_ADDRESS, 0x10001000
.equ WSPACE_UART_MASK, 0xFFFF
