.include "stack.s"
.include "constantes.s"

  .global _iniciar_animacao
_iniciar_animacao:
    push
    movia r8, RED_LED_ADDRESS      # Endereço dos LEDs
    movia r9, SWITCHES_ADDRESS     # Endereço dos switches

    ldwio r10, (r8)                # Carrega o estado atual dos LEDs em r10
    ldwio r11, (r9)                # Carrega o estado atual dos switches em r11

    movia r12, 1                   # Máscara para verificar o bit do switch de controle
    and r13, r12, r11             # r13 recebe o bit menos significativo do r11

    # Identifica qual LED está aceso
    movia r14, 1                   # Inicia com o bit menos significativo
    movi r15, 18                    # 18 LEDs
    loop_identificar_led:
    and r16, r10, r14          # Verifica se o LED correspondente está aceso
    beq r16, r0, proximo_led   # Se não estiver aceso, pula para o próximo
    br led_encontrado          # Se estiver aceso, sai do loop

    proximo_led:
    slli r14, r14, 1           # Move o bit da máscara para o próximo LED
    subi r15, r15, 1           # Decrementa o contador
    bne r15, r0, loop_identificar_led # Continua o loop enquanto não terminar

    led_encontrado:
    # Apaga o LED atual
    xor r10, r10, r14

    # Move para a esquerda ou para a direita
    beq r13, r12, mover_direita    # Se o switch indica direita, move para a direita
    br mover_esquerda              # Caso contrário, move para a esquerda

    mover_direita:
    # beq r14, r0, case_primeiro_led 
    
    srli r14, r14, 1           # Move a máscara para a direita
    br atualizar_led

    # case_primeiro_led:
    # movi r14, 0x10000           # Move a máscara para o led 17
    # br atualizar_led

    mover_esquerda:
    # movia r15, 17
    # beq r14, r15, case_ultimo_led
  
    slli r14, r14, 1 # Move a máscara para a esquerda
    br atualizar_led           
    
    # case_ultimo_led:
    # movi r14, 1           # Move a máscara para a esquerda


    atualizar_led:
    or r10, r10, r14           # Acende o LED correspondente
    stwio r10, (r8)            # Atualiza o valor nos LEDs
    br END_INICIAR_ANIMACAO

    END_INICIAR_ANIMACAO:
        pop
        ret
