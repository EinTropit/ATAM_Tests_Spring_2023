#include "aux_tests.h"


int main() {
    int len = 1;
    uint8_t* input = malloc(len*4*4);
    get_input(input, len);
    /*printf("input:\n");
    for(int l=0; l<len; l++){
        for (int i=0; i<4; i++) {
            for (int j=0; j<4; j++) {
                printf("%c",*(input + l*4*4 + i*4 + j));
            }
        }
    }
    printf("\n");*/
    byteSubstitution((uint8_t(*)[4])input);
    printf("0x");
    for(int l=0; l<len; l++){
        for (int i=0; i<4; i++) {
            for (int j=0; j<4; j++) {
                printf("%02hhx",*(input + l*4*4 + i*4 + j));
            }
        }
    }
    printf("\n");
    free(input);
    return 0;
}