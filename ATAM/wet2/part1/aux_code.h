#ifndef HW2_WET_AUX_CODE_H
#define HW2_WET_AUX_CODE_H
#include <stdint.h>
#include "students_code.h"

void mixColumns(uint8_t to_cipher[4][4]);
void decrypt(uint8_t input[][4][4], uint8_t key[4][4], uint8_t input_len);

#endif //HW2_WET_AUX_CODE_H
