
.include "stack.s"
.include "constantes.s"

.global _enable_interruption
_enable_interruption:
  push
  movi r8, 1
  wrctl	status, r8
  
  #rdctl r9, ienable
  # or r8, r8, r9

  movi r9, 0b111 # máscara para habilitar interrupção do timer e pushbutton
  wrctl ienable, r9

  movia r10, TIMER

  movia r8, 10000000 #5000 #200ms
  stwio	r8,	8(r10) #parte baixa do contador

  srli r11, r8, 16 #parte alta do contador
  stwio r11, 12(r10)

  movi r8, 0b111
  stbio r8, 4(r10)

  movia r23, PUSHBUTTON
  movi r16, 0b10 # máscara para habilitar o pushbutton KEY1
  stwio r16, 8(r23)

  pop
  ret

.global _start_temporizador
_start_temporizador:
  push
  movia r9, TIMER
  
  movia r8, 10000000 #5000 #200ms
  stwio	r8,	8(r9) #parte baixa do contador

  srli r10, r8, 16 #parte alta do contador
  stwio r10, 12(r9)

  movi r11, 0b111
  stwio r11, 4(r9)  #inicia temporizador
  
  pop
  ret


  

