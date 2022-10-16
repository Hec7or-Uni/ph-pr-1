	AREA codigo, CODE
	EXPORT conecta4_buscar_alineamiento_arm
	PRESERVE8 {TRUE}
NUM_COLUMNAS	EQU 7
NUM_FILAS		EQU 6
	ENTRY
	
;r0 <- cuadricula
;r1 <- fila
;r2 <- columna
;r3 <- color
;mem[sp] <- delta_fila
;mem[sp+4] <- delta_col
conecta4_buscar_alineamiento_arm
	STMDB sp!, {r4, r5, lr} ; Guarda valor de los registros para utilizarlos
	
	; return si fila no valida
	cmp r1, #1
	blo return0             ; salta si: fila < 1
	cmp r1, #NUM_FILAS
	bhi return0             ; salta si: fila > NUM_FILAS
	
	; return si columna no valida
	cmp r2, #1
	blo return0             ; salta si: columna < 1
	cmp r2, #NUM_COLUMNAS
	bhi return0             ; salta si: columna > NUM_COLUMNAS
	
	; r4 := celda
	add r4, r0, r2          ; r4 = r0+r2 = &cuadricula[0][columna]
	ldrb r4, [r4, r1, LSL#3]; r4 = mem[r4+r1*8] = cuadricula[fila][columna]
	; return si celda vacia
	tst r4, #0x4
	beq return0             ; salta si: celda vacia
	
	; return si celda != color
	and r5, r4, #0x3
	cmp r5, r3
	bne return0             ; salta si: celda != color

	; avanzar indices
	ldr r4, [sp, #12]       ; r4 = delta_fila
	ldr r5, [sp, #16]       ; r4 = delta_columna
	add r1, r1, r4          ; fila    = fila    + delta_fila
	add r2, r2, r5          ; columna = columna + delta_columna
	
	; carga de parametros
	STMDB sp!, {r4, r5}     ; delta_columnas := r5, delta_filas := r4
	bl conecta4_buscar_alineamiento_arm
	add sp, sp, #8          ; libera parametros
	add r0, r0, #1          ; r0 = resultado de funcion + 1
	
	LDMIA sp!, {r4, r5, lr} ; Recupera el valor de los registros
	bx lr                   ; return r0
	
return0
	mov r0, #0              ; r0 = 0
	LDMIA sp!, {r4, r5, lr} ; Recupera el valor de los registros
	bx lr                   ; return 0
	END
