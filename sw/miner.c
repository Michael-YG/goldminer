#include <stdio.h>
#include "acc.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>

#define CONTROL_START 0xffffffff
#define CONTROL_RESET 0xff0000ff
#define CONTROL_ACK 0x0f0f0f0f

int sha256_acc_fd;

void write_hash(const registers_i_t * re){
    if(ioctl(sha256_acc_fd, ACC_WRITE_HASH, re)){
        perror("ioctl(ACC_WRITE_HASH) failed");
        return;
    }
}

void read_hash(registers_o_t * re){
    if(ioctl(sha256_acc_fd, ACC_READ_HASH, re)){
        perror("ioctl(ACC_READ_HASH) failed");
        return;
    }
}

unsigned int read_control(){
    unsigned int result;
    if(ioctl(sha256_acc_fd, CONTROL_READ, &result)){
        perror("ioctl(CONTROL_READ) failed ;o;");
        return 0;
    }
    return result;
}

void write_control(unsigned int command_arg){
    unsigned int command = command_arg;
    if((ioctl(sha256_acc_fd, CONTROL_WRITE, &command)));
}

int main()
{
    static const char filename[] = "/dev/sha256_acc";
    write_control(CONTROL_RESET);

    if((sha256_acc_fd = open(filename, O_RDWR)) == -1){
        fprintf(stderr, "could not open file %s\n",filename);
        exit(1);
    }

    printf("--------break point 0--------\n");

    registers_i_t hash_input = {};
    registers_o_t hash_output = {};

    // hash_input.r0 = 0x000000dc;
    // hash_input.r1 = 0x00000000;
    // hash_input.r2 = 0x324eba80;
    // hash_input.r3 = 0x3339b233;
    // hash_input.r4 = 0x30263239;
    // hash_input.r5 = 0xb363b239;
    // hash_input.r6 = 0xb5b239d5;
    // hash_input.r7 = 0x38d81693;
    // hash_input.r8 = 0x334932d5;
    // hash_input.r9 = 0xb4c15bb6;
    // hash_input.r10 = 0x3026b5b2;
    // hash_input.r11 = 0x36b239d5;
    // hash_input.r12 = 0x38d81693;
    // hash_input.r13 = 0x324e98b3;
    // hash_input.r14 = 0x00000000;
    // hash_input.r15 = 0x0000001d;
     hash_input.r0  =  0x000000dc;
     hash_input.r1  =  0x00000000;
     hash_input.r2  =  0x3239b540;
     hash_input.r3  =  0x3339b233;
     hash_input.r4  =  0x30b33239;
     hash_input.r5  =  0xb335b239;
     hash_input.r6  =  0xb5b239b5;
     hash_input.r7  =  0x39b0b533;
     hash_input.r8  =  0x33353235;
     hash_input.r9  =  0xb530b5b6;
     hash_input.r10 =  0x30b335b2;
     hash_input.r11 =  0x35b239b5;
     hash_input.r12 =  0x39b0b533;
     hash_input.r13 =  0x3239b0b3;
     hash_input.r14 =  0x00000000;
     hash_input.r15 =  0x000001bf;
    write_hash(&hash_input);
    printf("--------break point 1--------\n");
    write_control(CONTROL_START);
    printf("--------break point 2--------\n");
    
    for(;;){
        // sleep(100);
        unsigned int read_value = read_control();
        printf("read value: %x\n",read_value);
        if(read_value == 0x11111111)
            break;
    }
    printf("--------break point 3--------\n");
    read_hash(&hash_output);

    printf("--------break point 4--------\n");
    write_control(CONTROL_ACK);

    printf("--------break point 5--------\n");
    printf("hash_output.r0: %x\n", hash_output.r0);
    printf("hash_output.r1: %x\n", hash_output.r1);
    printf("hash_output.r2: %x\n", hash_output.r2);
    printf("hash_output.r3: %x\n", hash_output.r3);
    printf("hash_output.r4: %x\n", hash_output.r4);
    printf("hash_output.r5: %x\n", hash_output.r5);
    printf("hash_output.r6: %x\n", hash_output.r6);
    printf("hash_output.r7: %x\n", hash_output.r7);
}

