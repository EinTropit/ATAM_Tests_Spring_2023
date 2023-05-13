#include "funcs.h"

void keyMixing_c_imp(uint8_t input[4][4], uint8_t key[4][4])
{
    for(int i = 0; i < 4; i++)
    {
        for(int j = 0; j < 4; j++)
        {
            input[i][j] = input[i][j] ^ key[i][j];
        }
    }
}

void byteSubstitution_c_imp(uint8_t input[4][4])
{
    for(int i = 0; i < 4; i++)
    {
        for(int j = 0; j < 4; j++)
        {
            input[i][j] = sbox[input[i][j]]; 
        }
    }
}  

void shiftRows_c_imp(uint8_t input[4][4])
{
    uint8_t temp[4][4];
    for(int i = 0; i < 4; i++)
    {
        for(int j = 0; j < 4; j++)
        {
            temp[i][j] = input[i][j];
        }
    }
    for(int i = 0; i < 4; i++)
    {
        for(int j = 0; j < 4; j++)
        {
            input[i][j] = temp[i][(j + i)%4];
        }
    }
}

void cipher_c_imp(uint8_t input[][4][4], uint8_t key[4][4], uint8_t len)
{
    uint8_t* temp_input;
    for (int i = 0; i < len; i++)
    {
        temp_input = (uint8_t*)input+16*i;
        keyMixing_c_imp((uint8_t(*)[4])temp_input, key);
        for (int j = 0; j < 9; j++)
        {
            byteSubstitution_c_imp((uint8_t(*)[4])temp_input);
            shiftRows_c_imp((uint8_t(*)[4])temp_input);
            mixColumns((uint8_t(*)[4])temp_input);
            keyMixing_c_imp((uint8_t(*)[4])temp_input, key);
        }
        byteSubstitution_c_imp((uint8_t(*)[4])temp_input);
        shiftRows_c_imp((uint8_t(*)[4])temp_input);
        keyMixing_c_imp((uint8_t(*)[4])temp_input, key);
    }
} 

