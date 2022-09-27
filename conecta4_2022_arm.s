	AREA codigo, CODE
	;IMPORT NUM_COLUMNAS
	;IMPORT NUM_FILAS
	EXPORT conecta4_buscar_alineamiento_arm
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

;r0 <- cuadricula
;r1 <- fila
;r2 <- columna
;r3 <- color
conecta4_hay_linea_arm_c
	; r4 delta_fila
	; r5 delta_columna
	STMDB sp!,{r4-r11,lr}
	LDR r4, =0x01FFFF00;  {0, -1, -1, 1}
	LDR r5, =0xFFFF00FF;  {-1, 0, -1, -1}
	STMDB sp!,{r4,r5}

	mov r4, #0; i = 0
	mov r5, #0; linea = 0

	mov r9, r0  	; cuadricula save
	mov r10, r1		; fila save
	mov r11, r2		; columna save

for
	mov r6, r3

	ldrsb r7, [sp,r4]
	add sp, sp ,#4
	ldrsb r8, [sp,r4]
	sub sp, sp ,#4
	STMDB sp!,{r7,r8}
	bl conecta4_buscar_alineamiento_c
	add sp, sp, #8

	mov r3, r6

	mov r6,r0			; long_linea = conecta4_buscar_alineamiento_c(...)
	
	;recover
	mov r0,r9

	; if (linea) return TRUE //comportamiento equivalente
	cmp r6, #4
	movhs r0, #1
	bhs returnTrue

	mov r5, r3

	sub r1, r10, r7
	sub r2, r11, r8
	rsb r7, r7, #0
	rsb r8, r8, #0
	STMDB sp!,{r7,r8}
	bl conecta4_buscar_alineamiento_c
	add sp, sp, #8

	mov r3, r5

	add r6, r6, r0
	cmp r6, #4
	movhs r5, #1
	movlo r5, #0;????

	;recover
	mov r0,r9
	mov r1, r10
	mov r2, r11

	add r4, r4, #1
	;	(i < 4) && (linea == FALSE) -> (i != 4) && (linea != TRUE)
	cmp r4, #4
	cmpne r5, #1
	bne for

	mov r0, r5
returnTrue
	add sp, sp, #8
	LDMIA sp!,{r4-r11,lr}
	bx lr

	END