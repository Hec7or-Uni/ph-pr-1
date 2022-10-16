	AREA codigo, CODE
	EXPORT conecta4_hay_linea_arm_arm
	PRESERVE8 {TRUE}
NUM_COLUMNAS	EQU 7
NUM_FILAS		EQU 6
	ENTRY
	
;r0 <- cuadricula
;r1 <- fila
;r2 <- columna
;r3 <- color
conecta4_hay_linea_arm_arm
	STMDB sp!, {r4-r11, lr} ; Guarda valor de los registros para utilizarlos
	LDR r4, =0x01FFFF00     ; r4 = {0 , -1 , -1 , 1}
	LDR r5, =0xFFFF00FF     ; r5 = { -1 , 0 , -1 , -1}
	STMDB sp!, {r4, r5}     ; Guarda los vectores en la pila
	mov r6, #0              ; i := 0
	mov r10, r1             ; r10 := fila
	mov r11, r2             ; r11 := columna
	
	; return si fila no valida
	cmp r1, #1
	blo returnFalse         ; salta si : fila < 1
	cmp r1, #NUM_FILAS
	bhi returnFalse         ; salta si : fila > NUM_FILAS
	
	; return si columna no valida
	cmp r2, #1
	blo returnFalse         ; salta si : columna < 1
	cmp r2, #NUM_COLUMNAS
	bhi returnFalse         ; salta si : columna > NUM_COLUMNAS
	
	; r4 := celda
	add r4, r0, r2          ; r4 = r0 + r2 = & cuadricula [0][columna]
	ldrb r4, [r4, r1, LSL#3]; r4 = mem[r4+r1*8] = cuadricula [fila][columna]
	; return si celda vacia
	tst r4, #0x4
	beq returnFalse         ; salta si : celda vacia
	
	; return si celda != color
	and r5, r4, #0x3
	cmp r5, r3
	bne returnFalse         ; salta si : celda != color

  ; Mientras i < 4
for
	mov r7, #1              ; longLinea := 1
	ldrsb r8, [sp, r6]      ; r8 := deltas_fila[i]
	add sp, sp, #4          
	ldrsb r9, [sp, r6]      ; r9 := deltas_columna[i]
	sub sp, sp, #4
	add r1, r1, r8	        ; r1 = fila := fila + deltas_fila[i]
	add r2, r2, r9          ; r2 = columna := columna + deltas_columna[i]

  ; Mientras FilaValida & ColumnaValida & CeldaLLena & MismoColor
while
  ; break si fila no valida
	cmp r1, #1
	blo outWhile            ; salta si : fila < 1
	cmp r1, #NUM_FILAS
	bhi outWhile            ; salta si : fila > NUM_FILAS
	
	; return si columna no valida
	cmp r2, #1
	blo outWhile            ; salta si : columna < 1
	cmp r2, #NUM_COLUMNAS
	bhi outWhile            ; salta si : columna > NUM_COLUMNAS
	
	; r4 := celda
	add r4, r0, r2          ; r4 = r0 + r2 = & cuadricula[0][columna]
	ldrb r4, [r4, r1, LSL#3]; r4 = mem[r4+r1*8] = cuadricula[fila][columna]
	; return si celda vacia
	tst r4, #0x4
	beq outWhile            ; salta si : celda vacia
	
	
	; return si celda != color
	and r5, r4, #0x3
	cmp r5, r3
	bne outWhile            ; salta si : celda != color
	
	add r1, r1, r8          ; fila = fila + delta_fila[i]
	add r2, r2, r9          ; columna = columna + delta_columna[i]
	add r7, r7, #1          ; longLinea++
	; return si longLinea == 4
	cmp r7, #4
	beq returnTrue          ; salta si : longLinea == 4
	b while

  ; Si !(FilaValida & ColumnaValida & CeldaLLena & MismoColor)
outWhile
	sub r1, r10, r8         ; fila := fila_bak  - delta_fila[i]
	sub r2, r11, r9         ; columna := columna_bak - delta_columna[i]

  ; Mientras FilaValida & ColumnaValida & CeldaLLena & MismoColor
while2
  ; return si fila no valida
	cmp r1, #1
	blo outWhile2           ; salta si : fila < 1
	cmp r1, #NUM_FILAS
	bhi outWhile2           ; salta si : fila > NUM_FILAS
	
	; return si columna no valida
	cmp r2, #1
	blo outWhile2           ; salta si : columna < 1
	cmp r2, #NUM_COLUMNAS
	bhi outWhile2           ; salta si : columna > NUM_COLUMNAS
	
	; r4 := celda
	add r4, r0, r2          ; r4 = r0 + r2 = & cuadricula[0][columna]
	ldrb r4, [r4, r1, LSL#3]; r4 = mem[r4+r1*8] = cuadricula[fila][columna]
	; return si celda vacia
	tst r4, #0x4
	beq outWhile2           ; salta si : celda vacia
	
	; return si celda != color
	and r5, r4, #0x3
	cmp r5, r3
	bne outWhile2           ; salta si : celda != color
	
	sub r1, r1, r8          ; fila = fila - delta_fila[i]
	sub r2, r2, r9          ; columna = columna - delta_columna[i]
	add r7, r7, #1          ; longLinea++
	; return si longLinea == 4
	cmp r7, #4
	beq returnTrue          ; salta si : longLinea == 4
	b while2
	
  ; Si !(FilaValida & ColumnaValida & CeldaLLena & MismoColor)
outWhile2
	mov r1, r10             ; fila := fila_bak
	mov r2, r11             ; columna := columna_bak
	add r6, r6, #1          ; i++
	; for i < 4
	cmp r6, #4
	bne for

  ; Si i == 4 || !(FilaValida & ColumnaValida & CeldaLLena & MismoColor)
returnFalse
	mov r0, #0              ; r0 := FALSE
	add sp, sp, #8          ; libera vectores de pila
	LDMIA sp!, {r4-r11, lr} ; Recupera el valor de los registros
	bx lr                   ; return FALSE
	
  ; Si LongLinea == 4
returnTrue
	mov r0, #1              ; r0 := TRUE
	add sp, sp, #8          ; libera vectores de pila
	LDMIA sp!, {r4-r11, lr} ; Recupera el valor de los registros
	bx lr                   ; return TRUE
	
	END