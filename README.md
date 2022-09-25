# proy-hardware
## Sesión 1
---
Leer el guión y conocer la documentación suministrada

- [x] **Paso 1**: Estudiar la documentación.
- [x] **Paso 2**: Estudiar y depurar el código inicial del juego.
  - [x] Aprended a jugar interaccionando con el juego a través de la memoria.
  - [x] Monitorizar la ejecución de las funciones en C, verificando sobre el tablero en memoria la correcta ejecución.
  - [x] Realiza la función `C4_comprobar_empate` que detecta si tras la jugada actual el tablero está lleno.
   Jugar, o modificar el tablero en memoria, para verificar su correcto funcionamiento.
  - [x] Observar el código en ensamblador generado por el compilador y depurarlo paso a paso
  - [x] Dibuja el mapa de memoria (código, variables globales, pila, etc). 
  - [x] Dibuja el marco de activación en pila y el paso de parámetros de las llamadas a funciones que está empleando el compilador.
- [x] **Paso 3**: Analizar el rendimiento. 
  - [x] Hacer uso del analizador de rendimiento (profiling) para analizar el árbol de ejecución y los tiempos de ejecución de las diferentes funciones del juego
  - [x] Determinar las funciones principales del juego y las de mayor peso de cómputo.
- [ ] **Paso 4**: Implementar la función `conecta4_buscar_alineamiento_arm` en ensamblador ARM.
  - [ ] `conecta4_buscar_alineamiento_arm` debe tener optimización de código. 
  - [ ] Crear una nueva versión `conecta4_hay_linea_c_arm`, igual que la anterior pero que invoque a `conecta4_buscar_alineamiento_arm`.

## Sesión 2
---
traer el código fuente de los apartados 5 y 6 lo más avanzado posible.

- [ ] **Paso 5**: Implementar la función `conecta4_hay_linea_arm_c` en ensamblador ARM. Debéis tratar de optimizar el código. La función invocará a `conecta4_buscar_alineamiento_c`.
- [ ] **Paso 6**: Implementar la función `conecta4_hay_linea_arm_arm`. 
  - Diseña una función en ARM que sustituya a las iniciales de C devolviendo la misma salida.

## Sesión 3
---
Mostrar que todo lo anterior funciona correctamente.

- [ ] **Paso 7**: Verificación automática y comparación de resultados.
- [ ] **Paso 8**: Medidas de rendimiento.
---
- [ ] **Paso 9**: Optimizaciones del compilador.
