#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <inttypes.h>
#include <ctype.h>
#include <string.h>
#include <time.h>

#include "print.h"
#include "api.h"

extern uint64_t mayo2_crypto_sign_keypair(unsigned char *pk, unsigned char *sk);
extern int
mayo2_crypto_sign(unsigned char *sm,
            const unsigned char *m, unsigned long long mlen,
            const unsigned char *sk);
extern int
mayo2_crypto_sign_open(unsigned char *sm,
            const unsigned char *m, unsigned long long mlen,
            const unsigned char *pk);

int main(void) {
    
    unsigned char *pk  = calloc(CRYPTO_PUBLICKEYBYTES, 1);
    unsigned char *sk  = calloc(CRYPTO_SECRETKEYBYTES, 1);

    unsigned char seed[48];
    
    uint64_t ret_val;

     int r;
    

    clock_t start, end;
    double cpu_time_used;

   
    start = clock();
    
    ret_val = mayo2_crypto_sign_keypair(pk, sk);
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

    
    printf("Time taken to generate the key: %f seconds\n", cpu_time_used);
    if(ret_val == 0){
        printf("\n[1]. Mayo2 public key and secret key generated\n");
    }
    else{
        printf("\n[FATAL]: Mayo2 public key and secret key generation failed\n");
    }

    printf("\nSecret Key starts:\n");

    for(int i = 0; i < CRYPTO_SECRETKEYBYTES; i++){
        printf("%02x",sk[i]);
    }
   
   
    printf("\nPublic Key starts:\n");

    for(int i = 0; i < CRYPTO_PUBLICKEYBYTES; i++){
        printf("%02x",pk[i]);
    }
    unsigned long long mlen = 99;
    unsigned char m[99] = { 
        0x2B, 0x8C, 0x4B, 0x0F, 0x29, 0x36, 0x3E, 0xAE, 0xE4, 0x69, 0xA7, 0xE3, 0x35, 0x24, 0x53, 0x8A,
    0xA0, 0x66, 0xAE, 0x98, 0x98, 0x0E, 0xAA, 0x19, 0xD1, 0xF1, 0x05, 0x93, 0x20, 0x3D, 0xA2, 0x14,
    0x3B, 0x9E, 0x9E, 0x19, 0x73, 0xF7, 0xFF, 0x0E, 0x6C, 0x6A, 0xAA, 0x3C, 0x0B, 0x90, 0x0E, 0x50,
    0xD0, 0x03, 0x41, 0x2E, 0xFE, 0x96, 0xDE, 0xEC, 0xE3, 0x04, 0x6D, 0x8C, 0x46, 0xBC, 0x77, 0x09,
    0x22, 0x87, 0x89, 0x77, 0x5A, 0xBD, 0xF5, 0x6A, 0xED, 0x64, 0x16, 0xC9, 0x00, 0x33, 0x78, 0x0C,
    0xB7, 0xA4, 0x98, 0x48, 0x15, 0xDA, 0x1B, 0x14, 0x66, 0x0D, 0xCF, 0x34, 0xAA, 0x34, 0xBF, 0x82,
    0xCE, 0xBB, 0xCF
        
        };
   
    unsigned long long smlen = 180;
 
    unsigned char *sma;
    sma = (unsigned char *)calloc(mlen + CRYPTO_BYTES, sizeof(unsigned char));
     start = clock();
    r = mayo2_crypto_sign(sma, m, mlen, sk);
    end = clock();
      cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("\n\nTime taken to sign: %f seconds\n", cpu_time_used);

    if(r == 0){
        printf("\n[2]. Mayo2 Signature Generated\n");
    }
    else{
        printf("\n[FATAL]: Mayo2 Signature Generation failed\n");
    }
    printf("\nsignature:\n");

    for(int i = 0; i < 180; i++){
        printf("%02x",sma[i]);
    }

    
    start = clock();
    
    
   r = mayo2_crypto_sign_open(sma, m, mlen, pk);
   
    end = clock();
     cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

    // Print the result
    printf("\n\nTime taken to verify: %f seconds\n", cpu_time_used);

    if(r == 0){
        printf("\n[3]. Mayo2 Signature Verified\n");
    }
    else{
        printf("\n[FATAL]: Mayo2 Verification failed\n");
    }



}
