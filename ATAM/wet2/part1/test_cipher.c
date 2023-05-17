#include "aux_tests.h"

int main() {
    int len = get_len();
    uint8_t* input = malloc(len*4*4);
    get_input(input, len);
    uint8_t key[4][4];
    get_key(key);
    cipher((uint8_t(*)[4][4])input, key, len);
    printf("Encrypted:\n0x");
    for(int l=0; l<len; l++){
        for (int i=0; i<4; i++) {
            for (int j=0; j<4; j++) {
                printf("%02hhx",*(input + l*4*4 + i*4 + j));
            }
        }
    }
    
    decrypt((uint8_t(*)[4][4])input, key, len);

    printf("\n\nDecrypted:\n");
    for(int l=0; l<len; l++){
        for (int i=0; i<4; i++) {
            for (int j=0; j<4; j++) {
                printf("%c",*(input + l*4*4 + i*4 + j));
            }
        }
    }
    printf("\n");
    free(input);
    return 0;
}