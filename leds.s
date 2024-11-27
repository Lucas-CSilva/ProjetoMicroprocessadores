.include "stack.s"
.include "constantes.s"

.global _acender_led
_acender_led:
push

movia r8, RED_LED_ADDRESS # carrega o endereco do led vermelho
ldwio r12, (r8) # carrega o conteudo do led vermelho
movia r9, parametro #carrega o valor presente nos parametros
ldb r13, (r9) # carrega primeiro digito do parametro
subi r13, r13, 0x30 # transforma o valor dos parametros em decimal
ldb r14, 1(r9) # carrega segundo digito do parametro
subi r14, r14, 0x30 # transforma o valor dos parametros em decimal
mov r15, r13 # copia o valor de r13 para r15
slli r15, r15, 3  # multiplica r15 por 8 (shift left 3 bits)
slli r13, r13, 1  # multiplica r13 por 2 (shift left 1 bit)
add r15, r15, r13 # soma r15 (8 * r13) com r13 (2 * r13) = 10 * r13
add r15, r15, r14 # soma r14 ao resultado
movi r10, 1 # carrega 1 em r10
sll r10, r10, r15 # desloca o numero de posicoes passadas por parametro
or r11, r12, r10 #aplica a mascara para acender o led
stwio r11, (r8)

pop
ret

.global _apagar_led
_apagar_led:
push

movia r8, RED_LED_ADDRESS # carrega o endereco do led vermelho
ldwio r12, (r8) # carrega o conteudo do led vermelho
movia r9, parametro #carrega o valor presente nos parametros
ldb r13, (r9) # carrega primeiro digito do parametro
subi r13, r13, 0x30 # transforma o valor dos parametros em decimal
ldb r14, 1(r9) # carrega segundo digito do parametro
subi r14, r14, 0x30 # transforma o valor dos parametros em decimal
mov r15, r13 # copia o valor de r13 para r15
slli r15, r15, 3  # multiplica r15 por 8 (shift left 3 bits)
slli r13, r13, 1  # multiplica r13 por 2 (shift left 1 bit)
add r15, r15, r13 # soma r15 (8 * r13) com r13 (2 * r13) = 10 * r13
add r15, r15, r14 # soma r14 ao resultado
movi r10, 1 # carrega 1 em r10
sll r10, r10, r15 # desloca o numero de posicoes passadas por parametro
xor r11, r12, r10 # inverte valores
and r11, r11, r12 # aplica a mascara para apagar o led
stwio r11, (r8)

pop
ret

.global _iniciar_animacao_leds
_iniciar_animacao_leds:
push

movia r8, RED_LED_ADDRESS # carrega o endereco dos leds vermelhos
ldwio r12, (r8) # carrega o conteudo do led vermelho
stwio r0, (r8) # apaga todos os leds

pop 
ret
