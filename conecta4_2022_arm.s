	AREA codigo, CODE
	;IMPORT NUM_COLUMNAS
	;IMPORT NUM_FILAS
	EXPORT conecta4_buscar_alineamiento_arm
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
	STMDB sp!,{r4,r5,lr}
	
	;Comportamiento equivalente del if:
	;	!C4_fila_valida(fila) ==
	;	!((fila >= 1) && (fila <= NUM_FILAS)) ==
	;	(fila < 1) || (fila > NUM_FILAS)
	
	cmp r1,#1			; if (fila < 1) return 0;
	blo return0
	cmp r1,#NUM_FILAS	; if (fila > NUM_FILAS) return 0;
	bhi return0
	
	; !C4_columna_valida(columna) == !((columna >= 1) && (columna <= NUM_COLUMNAS)) == (columna < 1) || (columna > NUM_COLUMNAS)
	cmp r2,#1			; if (columna < 1) return 0;
	blo return0
	cmp r2,#NUM_FILAS	; if (columna > NUM_COLUMNAS) return 0;
	bhi return0
	
	add r4,r0,r2			; r4 = r0 + r2
	ldrb r4,[r4,r1,LSL#3]	; r4 = mem[r0+r2+r1*8] = cuadricula[columna+fila*8]
	tst r4, #0x4			; celda_vacia(cuadricula[fila][columna]) == 0
	beq return0
	
	and r5, r4, #0x3	; r5 = celda_color(cuadricula[fila][columna])
	cmp r5,r3			; if (r5 != color) return 0;
	bne return0
	
	ldr r4,[sp,#12]		; r4 <- delta_fila
	ldr r5,[sp,#16]		; r5 <- delta_col
	
	add r1, r1, r4		; r1 <- nueva_fila = fila + delta_fila
	add r2, r2, r5		; r2 <- nueva_columna = columna + delta_columna
	
	;str r5,[sp,#-4]
	;str r4,[sp,#-4]
	STMDB sp!,{r4,r5}	; PUSH{delta_fila,delta_col} (cargar parametros)
	bl conecta4_buscar_alineamiento_arm
	add sp, sp, #8		; liberar parametros
	
	add r0, r0, #1		; r0 = 1 + conecta4_buscar_alineamiento_arm(..)
	LDMIA sp!,{r4,r5,lr}
	bx lr
	
return0
	mov r0,#0			
	LDMIA sp!,{r4,r5,lr}
	bx lr
	
	END