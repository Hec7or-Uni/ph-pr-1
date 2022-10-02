#include "conecta4_2022.h"
#include "celda.h"

#define NUM_TESTS 5

typedef struct
{
  CELDA *cuadricula;
  uint8_t fila, columna, color, res;
} tablero_prueba;

void test_tableros()
{
#include "tableros.h"

  tablero_prueba tableros[NUM_TESTS] = {
      {cuadricula_1, 1, 1, 1, 1},
      {cuadricula_2, 1, 1, 1, 1},
      {cuadricula_3, 1, 1, 1, 1},
      {cuadricula_4, 1, 1, 1, 1},
      {cuadricula_5, 1, 1, 1, 1},
      /*{cuadricula_6, 1, 1, 1, 1},
      {cuadricula_7, 1, 1, 1, 1},
      {cuadricula_8, 1, 1, 1, 1},
      {cuadricula_9, 1, 1, 1, 1},
      {cuadricula_10, 1, 1, 1, 1}*/
  };

  // Consultar en memoria:
  //   si al terminar el bucle for vale 0xF hay un fallo
  //   si vale 0x1 todos los tests han devuelto los resultados esperados
  static uint8_t check = 1;

  for (uint8_t i = 0; i < NUM_TESTS; ++i)
  {
    if (tableros[i].res != C4_verificar_4_en_linea(tableros[i].cuadricula, tableros[i].fila, tableros[i].columna, tableros[i].color))
    {
      check = 0xf;
      break;
    }
  }
}