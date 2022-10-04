#include "conecta4_2022.h"
#include "celda.h"

int test(CELDA cuadricula[TAM_FILS][TAM_COLS], uint8_t f, uint8_t c, const int res)
{
  return res != C4_verificar_4_en_linea(cuadricula, f, c, celda_color(cuadricula[f][c]));
}

// Comprueba que da falsos para cada posicion del tablero
void testAllPostions(CELDA cuadricula[TAM_FILS][TAM_COLS], const int res, uint8_t *fila_fail, uint8_t *col_fail, uint8_t *fail, uint8_t test_fail)
{
  for (int i = 1; i <= NUM_FILAS; i++)
  {
    for (int j = 1; j <= NUM_COLUMNAS; j++)
    {
      if (test(cuadricula, i, j, res))
      {
        *fila_fail = i;
        *col_fail = j;
        *fail = test_fail;
      }
    }
  }
}

void testSomePositions(CELDA cuadricula[TAM_FILS][TAM_COLS], uint8_t *filas, uint8_t *columnas, const int res, uint8_t *fila_fail, uint8_t *col_fail, uint8_t *fail, uint8_t test_fail)
{
  for (uint8_t *f = filas, *c = columnas; *f != 0; f++, c++)
  {
    if (test(cuadricula, *f, *c, res))
    {
      *fila_fail = *f;
      *col_fail = *c;
      *fail = test_fail;
      break;
    }
  }
}

void test_tableros()
{
#include "tableros.h"
  // Consultar en memoria:
  // (si 0 todo OK)
  static uint8_t fila_fail = 0, col_fail = 0, fail = 0;
  testAllPostions(cuadricula_2, FALSE, &fila_fail, &col_fail, &fail, 1);
  if (!fail)
    testSomePositions(cuadricula_3, cuadricula_3_filas_5_true, cuadricula_3_columnas_5_true, TRUE, &fila_fail, &col_fail, &fail, 2);
  if (!fail)
    testSomePositions(cuadricula_3, cuadricula_3_filas_6_true, cuadricula_3_columnas_6_true, TRUE, &fila_fail, &col_fail, &fail, 3);
  if (!fail)
    testSomePositions(cuadricula_3, cuadricula_3_filas_false, cuadricula_3_columnas_false, FALSE, &fila_fail, &col_fail, &fail, 4);
  if (!fail)
    testAllPostions(cuadricula_4, TRUE, &fila_fail, &col_fail, &fail, 5);
}