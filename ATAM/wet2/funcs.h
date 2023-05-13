
#ifndef TEST_FUNC_H
#define TEST_FUNC_H
#include <stdint.h>
#include <stdio.h>
#include "aux_code.h"

void keyMixing_c_imp(uint8_t input[4][4], uint8_t key[4][4]);
void byteSubstitution_c_imp(uint8_t input[4][4]);
void shiftRows_c_imp(uint8_t input[4][4]);
void cipher_c_imp(uint8_t input[][4][4], uint8_t key[4][4], uint8_t len);

void keyMixing(uint8_t input[4][4], uint8_t key[4][4]);

#endif //TEST_FUNC_H