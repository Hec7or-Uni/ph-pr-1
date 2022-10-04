#ifndef TABLEROS_H
#define TABLEROS_H

// tableros en memoria a mitad de una partida, toca jugar blancas
#include "celda.h"

static CELDA cuadricula_1[7][8] =
    {
        0, 0XC1, 0XC2, 0XC3, 0XC4, 0XC5, 0Xc6, 0XC7,
        0XF1, 0, 5, 0, 5, 0, 5, 0,
        0XF2, 0, 0, 5, 5, 5, 0, 0,
        0XF3, 0, 5, 5, 0, 0, 0, 0,
        0XF4, 0, 0, 5, 0, 0, 0, 0,
        0XF5, 0, 0, 0, 0, 0, 0, 0,
        0XF6, 0, 0, 0, 0, 0, 0, 0};

// False para cada posicion [f,c]
const CELDA cuadricula_2[7][8] =
    {
        0, 0XC1, 0XC2, 0XC3, 0XC4, 0XC5, 0Xc6, 0XC7,
        0XF1, 6, 5, 5, 6, 5, 5, 6,
        0XF2, 5, 6, 5, 6, 5, 6, 5,
        0XF3, 5, 5, 6, 6, 6, 5, 5,
        0XF4, 6, 6, 6, 5, 6, 6, 6,
        0XF5, 5, 5, 6, 6, 6, 5, 5,
        0XF6, 5, 6, 5, 6, 5, 6, 5};

// true para cualquier posicion de 5's y 6's
const CELDA cuadricula_3[7][8] =
    {
        0, 0XC1, 0XC2, 0XC3, 0XC4, 0XC5, 0Xc6, 0XC7,
        0XF1, 5, 6, 6, 6, 6, 6, 5,
        0XF2, 6, 5, 0, 0, 0, 5, 6,
        0XF3, 6, 0, 5, 5, 5, 0, 6,
        0XF4, 6, 0, 5, 5, 5, 0, 6,
        0XF5, 6, 5, 0, 0, 0, 5, 6,
        0XF6, 5, 6, 6, 6, 6, 6, 5};
// Datos para comprobar los 5's
const uint8_t cuadricula_3_filas_5_true[] = {1, 1, 6, 6, 3, 3, 4, 4, 3, 4, 0};
const uint8_t cuadricula_3_columnas_5_true[] = {1, 7, 1, 7, 3, 5, 3, 5, 4, 4, 0};
// Datos para comprobar los 6's
const uint8_t cuadricula_3_filas_6_true[] = {1, 1, 1, 1, 1, 2, 3, 4, 5, 2, 3, 4, 5, 6, 6, 6, 6, 6, 0};
const uint8_t cuadricula_3_columnas_6_true[] = {2, 3, 4, 5, 6, 1, 1, 1, 1, 7, 7, 7, 7, 2, 3, 4, 5, 6, 0};
// Datos para comprobar los vacios
const uint8_t cuadricula_3_filas_false[] = {2, 2, 2, 3, 3, 4, 4, 5, 5, 5, 0};
const uint8_t cuadricula_3_columnas_false[] = {3, 4, 5, 2, 6, 2, 6, 3, 4, 5, 0};

// Check all true
const CELDA cuadricula_4[7][8] =
    {
        0, 0XC1, 0XC2, 0XC3, 0XC4, 0XC5, 0Xc6, 0XC7,
        0XF1, 6, 5, 6, 5, 6, 5, 6,
        0XF2, 5, 6, 5, 6, 5, 6, 5,
        0XF3, 6, 5, 6, 5, 6, 5, 6,
        0XF4, 5, 6, 5, 6, 5, 6, 5,
        0XF5, 6, 5, 6, 5, 6, 5, 6,
        0XF6, 5, 6, 5, 6, 5, 6, 5};

#endif