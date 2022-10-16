	AREA codigo, CODE
	EXPORT conecta4_hay_linea_arm_c
	IMPORT conecta4_buscar_alineamiento_c
	PRESERVE8 {TRUE}
NUM_COLUMNAS	EQU 7
NUM_FILAS		EQU 6
	ENTRY


;r0 <- cuadricula
;r1 <- fila
;r2 <- columna
;r3 <- color
conecta4_hay_linea_arm_c
	STMDB sp!, {r4-r11, lr} ; Guarda valor de los registros para utilizarlos
	LDR r4, =0x01FFFF00     ; r4 := {0, -1, -1, 1}
	LDR r5, =0xFFFF00FF     ; r5 := {-1, 0, -1, -1}
	STMDB sp!, {r4, r5}     ; Guarda los vectores en la pila
	mov r4, #0              ; i := 0
	mov r5, #0              ; linea := FALSE
  ; Backups de los parametros
	mov r9, r0              ; r9  = cuadricula_bak := cuadricula
	mov r10, r1             ; r10 = fila_bak := fila
	mov r11, r2             ; r11 = columna_bak := columna
 
for
	mov r6, r3              ; r6 = color_bak := color
  ; carga de parametros
	ldrsb r7, [sp, r4]      ; r7 := deltas_fila[i]
	add sp, sp, #4
	ldrsb r8, [sp, r4]      ; r8 := deltas_columna[i]
	sub sp, sp, #4
	STMDB sp!, {r7, r8}     ; delta_columnas := r8, delta_filas := r7
	bl conecta4_buscar_alineamiento_c
	add sp, sp, #8          ; libera parametros
	mov r3, r6              ; color := color_bak
	mov r6, r0              ; r6 := longLinea   // resultado de funcion
	mov r0, r9              ; r0 := cuadricula_bak

  ; return true si longLinea >= 4
	cmp r6, #4             
	movhs r0, #1
	bhs return              ; salta si: longLinea >= 4
 
	mov r5, r3              ; r5 = color_bak := color
  ; carga de parametros
	sub r1, r10, r7         ; fila := fila + deltas_fila[i]
	sub r2, r11, r8         ; columna := columna + deltas_columna[i]
	rsb r7, r7, #0          ; r7 := -deltas_fila[i]
	rsb r8, r8, #0          ; r8 := -deltas_columna[i]
	STMDB sp!, {r7, r8}     ; delta_columnas := r8, delta_filas := r7
	bl conecta4_buscar_alineamiento_c
	add sp, sp, #8          ; libera parametros
	mov r3, r5              ; color := color_bak
	add r6, r6, r0          ; longLinea := longLinea + resultado de funcion
	
	cmp r6, #4
	movhs r5, #1
	movlo r5, #0            ; linea := longLinea >= 4

  ; Recupera el valor de los parametros
	mov r0, r9              ; cuadricula := cuadricula_bak
	mov r1, r10             ; fila := fila_bak
	mov r2, r11             ; columna := columna_bak

  ; guarda del bucle
	add r4, r4, #1          ; i++
	cmp r4, #4
	cmpne r5, #1
	bne for                 ; repite si: i != 4 && !linea
	
  mov r0, r5              ; r0 := linea   // resultado de la funcion
return
	add sp, sp, #8          ; libera vectores de pila
	LDMIA sp!, {r4-r11, lr} ; Recupera el valor de los registros
	bx lr                   ; return linea
	
	END