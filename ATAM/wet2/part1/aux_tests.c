#include "aux_tests.h"

int get_len() {
    char buffer[100];
    fgets(buffer, 100 , stdin);
    return atoi(buffer);
}

void get_input(uint8_t* input, int len) {
    for(int l=0; l<len; l++){
        for (int i=0; i<4; i++) {
            for (int j=0; j<4; j++) {
                *(input + l*4*4 + i*4 + j) = (uint8_t)fgetc(stdin);
            }
        }
    }
}
void get_key(uint8_t key[4][4]) {
    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            key[i][j] = (uint8_t)fgetc(stdin);
        }
    }
}