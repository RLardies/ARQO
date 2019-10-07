#####################################################################
### Programa de prueba David Gonzalez-Arjona para Práctica 1 ARQO ###
###   __   __  __     _  _  __  __ __                             ### 
###  | _\ / _]/  \ __| || |/  \|  V  |                            ### 
###  | v | [/\ /\ |__| \/ | /\ | \_/ |                            ### 
###  |__/ \__/_||_|   \__/|_||_|_| |_|                            ### 
#####################################################################
### Programa en ensamblador para probar el funcionamiento de la práctica 1. 
### Incluye todas las instrucciones a verificar. Los saltos de los beq se 
### realizan de forma efectiva si las operaciones anteriores han devuelto resultados 
### correctos en los registros. Aún así el alumno tiene que verificar en modelsim que 
### el resultado correcto se genera en el momento correcto (mips de 5 etapas) así como 
### el valor del resto de las señales. Recordad verificar que se ejecuta 1 instrucción 
### por ciclo de reloj, ojo al segmentar, no haya una instrucción cada 2 ciclos (o cada 3,4,5,6...).
####################################################################################################

.data 0
num0: .word 1 # posic 0
num1: .word 2 # posic 4
num2: .word 4 # posic 8 
num3: .word 8 # posic 12 
num4: .word 16 # posic 16 
num5: .word 32 # posic 20
num6: .word 0 # posic 24
num7: .word 0 # posic 28
num8: .word 0 # posic 32
num9: .word 0 # posic 36
num10: .word 0 # posic 40
num11: .word 0 # posic 44
num12: .word 12 # posic 48
num13: .word 15 # posic 52
num14: .word 20 # posic 56
num15: .word 0 # posic 60
num16: .word 31 # posic 64
num17: .word 8 # posic 68
num18: .word 6 # posic 72
num19: .word 0 # posic 76
num20: .word 120651776 # posic 80
num21: .word 11111 # posic 84

.text 0
main: 
 lw $0, 52($zero) # En r0 NO se modifica el 0
 lw $1, 0($zero) # En r1 un 1
 lw $2, 4($zero) # En r2 un 2
 lw $3, 8($zero) # En r3 un 4
 lw $4, 12($zero) # En r4 un 8
 lw $11, 48($zero) # En r11 un 12
 lw $12, 52($zero) # En r12 un 15
 lw $13, 56($zero) # En r13 un 20
 sw $3, 60($zero) # En num15 de memoria un 4
 nop
 lw $21, 64($zero) # En r21 un 31
 lw $22, 68($zero) # En r22 un 8
 lw $23, 72($zero) # En r23 un 6
 lw $24, 80($zero) # En r24 un 120651776
 lw $25, 60($zero) # En r25 un 4 para chequear el sw
 nop
 nop
 nop
 and $14, $11, $13 # En r14 un 4
 or  $15, $12, $13 # En r15 un 31
 sub $16, $11, $3  # En r16 un 8
 xor $17, $2, $3  # En r17 un 6
 lui $18, 1841   # En r18 un 120651776 # x0731 hexa
 slti $19, $15, 31   # En r19 un 0
 slti $20, $15, 32   # En r20 un 1
 addi $26, $2, 10 # En r26 un 12 = 2 + 10  
 nop # SALTOS DE COMPROBACION      
 beq $14, $3, check_ok1 # salta
 # ----------------------------------
 nop
 nop
 nop
 j check_err
 # ----------------------------------
 nop
 nop
 nop
 check_ok1: beq $15, $21, check_ok2 # No salta
 # ----------------------------------
 nop
 nop
 nop
 j check_err
 # ----------------------------------
 nop
 nop
 nop
 check_ok2: beq $16, $22, check_ok3 # salta
  # ----------------------------------
 nop
 nop
 nop
 j check_err
 # ----------------------------------
 nop
 nop
 nop
 check_ok3: beq $17, $23, check_ok4 # salta
 # ----------------------------------
 nop
 nop
 nop
 j check_err
  # ----------------------------------
  nop
 nop
 nop
 check_ok4: beq $18, $24, check_ok5 # salta 
 # ----------------------------------
 nop
 nop
 nop
 j check_err
  # ----------------------------------
  nop
 nop
 nop
 check_ok5: beq $19, $0, check_ok6 # salta 
 # ----------------------------------
 nop
 nop
 nop
 j check_err
  # ----------------------------------
  nop
 nop
 nop
 check_ok6: beq $20, $1, check_ok7 # salta 
 # ----------------------------------
 nop
 nop
 nop 
 j check_err
  # ----------------------------------
  nop
 nop
 nop
 check_ok7: beq $25, $3, check_ok8 # salta si sw es correcto
 # ----------------------------------
 nop
 nop
 nop
 j check_err
 # ----------------------------------
 nop
 nop
 nop
 check_ok8: beq $26, $4, check_ok9 # salta si addi es correcta
 # ----------------------------------
 nop
 nop
 nop
 j check_err
 check_ok9: j check_ok
 # ----------------------------------
 nop
 nop
 nop                                                  
 check_err: nop                                    
 nop                                                            
 check_ok: nop       
                                                            
 # ---------------CONTINUARÁ EN P2-------------------
 # RIESGOS OPERACIONES CON REGISTROS
 # RIESGOS REGISTROS CONTINUOS   
 # RIESGOS REGISTROS DISCONTINUOS
 # RIESGOS LW/SW
 # RIESGOS JUMP BRANCH   
 # RIESGOS REGISTRO BRANCH   
 # RIESGOS MEMORIA BRANCH  
 