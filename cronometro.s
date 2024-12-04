.include "stack.s"
.include "constantes.s"

.global _cronometro_handler
_cronometro_handler:
 push
 movia r8, _current_unid_time
 ldb r9, (r8)
 movia r10, 10
 addi r9, r9, 1
 stb r9, (r8)
 bge r9, r10, DEZENA_HANDLER
 br SHOW_DISPLAY

DEZENA_HANDLER:
 stb r0, (r8)
 movia r8, _current_dez_time
 ldb r9, (r8)
 addi r9, r9, 1
 stb r9, (r8)
 bge r9, r10, CENTENA_HANDLER
 br SHOW_DISPLAY

CENTENA_HANDLER:
 stb r0, (r8)
 movia r8, _current_cent_time
 ldb r9, (r8)
 addi r9, r9, 1
 stb r9, (r8)
 bge r9, r10, MILHAR_HANDLER
 br SHOW_DISPLAY

 MILHAR_HANDLER:
 stb r0, (r8)
 movia r8, _current_mil_time
 ldb r9, (r8)
 addi r9, r9, 1
 stb r9, (r8)
 blt r9, r10, SHOW_DISPLAY
 stb r0, (r8)

 SHOW_DISPLAY:
    movia r11, cod_sete_segmentos
    movia r13, 0x10000020

    #display 1 unidade
    movia r12, _current_unid_time
    ldb r12, (r12)
    add r11, r11, r12
    ldb r11, (r11)
    stbio r11, (r13)
    
    #display 2 dezena
    movia r11, cod_sete_segmentos
    movia r12, _current_dez_time
    ldb r12, (r12)
    add r11, r11, r12
    ldb r11, (r11)
    stbio r11, 1(r13)   
    
    #display 3 centena
    movia r11, cod_sete_segmentos
    movia r12, _current_cent_time
    ldb r12, (r12)
    add r11, r11, r12
    ldb r11, (r11)
    stbio r11, 2(r13)

    #display 4 milhar
    movia r11, cod_sete_segmentos
    movia r12, _current_mil_time
    ldb r12, (r12)
    add r11, r11, r12
    ldb r11, (r11)
    stbio r11, 3(r13)

 pop
 ret

