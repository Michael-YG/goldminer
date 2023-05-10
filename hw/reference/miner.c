#include <stdio.h>
#include <string.h>
#include <time.h>
// #include <stdlib.h>
// #include <curl/curl.h>
#include "sha256.h"

typedef struct {
    unsigned int r0;
    unsigned int r1;
    unsigned int r2;
    unsigned int r3;
    unsigned int r4;
    unsigned int r5;
    unsigned int r6;
    unsigned int r7;
    unsigned int r8;
    unsigned int r9;
    unsigned int r10;
    unsigned int r11;
    unsigned int r12;
    unsigned int r13;
    unsigned int r14;
    unsigned int r15;
} registers_i_t;

// // Struct to hold response data
// struct ResponseData {
//     char *data;
//     size_t size;
// };

// // Callback function to write response data
// size_t write_callback(char *ptr, size_t size, size_t nmemb, void *userdata) {
//     size_t total_size = size * nmemb;
//     struct ResponseData *response = (struct ResponseData *)userdata;

//     // Reallocate memory to fit new data
//     response->data = realloc(response->data, response->size + total_size + 1);
//     if (response->data == NULL) {
//         printf("Out of memory!\n");
//         return 0;
//     }

//     // Copy the response data to the buffer
//     memcpy(&(response->data[response->size]), ptr, total_size);
//     response->size += total_size;
//     response->data[response->size] = '\0';

//     return total_size;
// }

int
main(){
    // CURL *curl;
    // CURLcode res;
    // struct ResponseData response;

    // // Initialize libcurl
    // curl_global_init(CURL_GLOBAL_DEFAULT);

    // // Create a curl handle
    // curl = curl_easy_init();
    // if (curl) {
    //     // Set the URL to make the GET request to
    //     curl_easy_setopt(curl, CURLOPT_URL, "https://mempool.space/api/block/0000000000000000000065bda8f8a88f2e1e00d9a6887a43d640e52a4c7660f2/header");

    //     // Set the callback function to handle the response data
    //     curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);

    //     // Pass the response struct as user data to the callback function
    //     curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

    //     // Perform the GET request
    //     res = curl_easy_perform(curl);

    //     // Check for errors
    //     if (res != CURLE_OK) {
    //         fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
    //     } else {
    //         // Print the response data
    //         printf("Response:\n%s\n", response.data);
    //     }

    //     // Clean up the curl handle
    //     curl_easy_cleanup(curl);
    // }

    // Clean up libcurl
    // curl_global_cleanup();

    // Free the response data buffer
    // free(response.data);


    SHA256_CTX ctx;
    registers_i_t input_data = {};

    input_data.r0  =  0x000000dc;
    input_data.r1  =  0x00000000;
    input_data.r2  =  0x3239b540;
    input_data.r3  =  0x3339b233;
    input_data.r4  =  0x30b33239;
    input_data.r5  =  0xb335b239;
    input_data.r6  =  0xb5b239b5;
    input_data.r7  =  0x39b0b533;
    input_data.r8  =  0x33353235;
    input_data.r9  =  0xb530b5b6;
    input_data.r10 =  0x30b335b2;
    input_data.r11 =  0x35b239b5;
    input_data.r12 =  0x39b0b533;
    input_data.r13 =  0x3239b0b3;
    input_data.r14 =  0x00000000;
    input_data.r15 =  0x000001bf;

    int i = 0;
    clock_t start_time = clock();

    while (i < 100000){
    sha256_init(&ctx);
    sha256_transform(&ctx, (BYTE*)&input_data);
    sha256_transform(&ctx, (BYTE*)&input_data);
    i++;
    }

    clock_t end_time = clock();
    
    double elapsed_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;

    printf("Elapsed time: %.5f seconds\n", elapsed_time);
    
}
