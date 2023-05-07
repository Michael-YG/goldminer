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
// #define TEST_RESET 1

int sha256_acc_fd0, sha256_acc_fd1, sha256_acc_fd2;

void write_hash0(const registers_i_t * re){
    if(ioctl(sha256_acc_fd0, ACC_WRITE_HASH0, re)){
        perror("ioctl(ACC_WRITE_HASH0) failed");
        return;
    }
}
void write_hash1(const registers_i_t * re){
    if(ioctl(sha256_acc_fd1, ACC_WRITE_HASH1, re)){
        perror("ioctl(ACC_WRITE_HASH1) failed");
        return;
    }
}
void write_hash2(const registers_i_t * re){
    if(ioctl(sha256_acc_fd2, ACC_WRITE_HASH2, re)){
        perror("ioctl(ACC_WRITE_HASH2) failed");
        return;
    }
}

void read_hash0(registers_o_t * re){
    if(ioctl(sha256_acc_fd0, ACC_READ_HASH0, re)){
        perror("ioctl(ACC_READ_HASH0) failed");
        return;
    }
}
void read_hash1(registers_o_t * re){
    if(ioctl(sha256_acc_fd1, ACC_READ_HASH1, re)){
        perror("ioctl(ACC_READ_HASH1) failed");
        return;
    }
}
void read_hash2(registers_o_t * re){
    if(ioctl(sha256_acc_fd2, ACC_READ_HASH2, re)){
        perror("ioctl(ACC_READ_HASH2) failed");
        return;
    }
}

unsigned int read_control0(){
    unsigned int result;
    if(ioctl(sha256_acc_fd0, CONTROL_READ0, &result)){
        perror("ioctl(CONTROL_READ0) failed ;o;");
        return 0;
    }
    return result;
}
unsigned int read_control1(){
    unsigned int result;
    if(ioctl(sha256_acc_fd1, CONTROL_READ1, &result)){
        perror("ioctl(CONTROL_READ1) failed ;o;");
        return 0;
    }
    return result;
}
unsigned int read_control2(){
    unsigned int result;
    if(ioctl(sha256_acc_fd2, CONTROL_READ2, &result)){
        perror("ioctl(CONTROL_READ2) failed ;o;");
        return 0;
    }
    return result;
}

void write_control0(unsigned int command_arg){
    unsigned int command = command_arg;
    if((ioctl(sha256_acc_fd0, CONTROL_WRITE0, &command)));
}
void write_control1(unsigned int command_arg){
    unsigned int command = command_arg;
    if((ioctl(sha256_acc_fd1, CONTROL_WRITE1, &command)));
}
void write_control2(unsigned int command_arg){
    unsigned int command = command_arg;
    if((ioctl(sha256_acc_fd2, CONTROL_WRITE2, &command)));
}

int main()
{
    static const char filename0[] = "/dev/sha256acc_1";
    static const char filename1[] = "/dev/sha256acc_2";
    static const char filename2[] = "/dev/sha256acc_3";

    write_control0(CONTROL_RESET);
    write_control1(CONTROL_RESET);
    write_control2(CONTROL_RESET);

    if((sha256_acc_fd0 = open(filename0, O_RDWR)) == -1){
        fprintf(stderr, "could not open file %s\n",filename0);
        exit(1);
    }
    if((sha256_acc_fd1 = open(filename1, O_RDWR)) == -1){
        fprintf(stderr, "could not open file %s\n",filename1);
        exit(1);
    }
    if((sha256_acc_fd2 = open(filename2, O_RDWR)) == -1){
        fprintf(stderr, "could not open file %s\n",filename2);
        exit(1);
    }
    printf("--------break point 0--------\n");
    registers_i_t hash_input = {};
    registers_o_t hash_output0 = {};
    registers_o_t hash_output1 = {};
    registers_o_t hash_output2 = {};
    #ifndef TEST_RESET

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
    write_hash0(&hash_input);
    write_hash1(&hash_input);
    write_hash2(&hash_input);
    printf("--------break point 1--------\n");
    write_control0(CONTROL_START);
    write_control1(CONTROL_START);
    write_control2(CONTROL_START);
    printf("--------break point 2--------\n");
    
    for(;;){
        // sleep(100);
        unsigned int read_value0 = read_control0();
        unsigned int read_value1 = read_control1();
        unsigned int read_value2 = read_control2();
        printf("read value0: %x\n",read_value0);
        // printf("read value1: %x\n",read_value1);
        // printf("read value2: %x\n",read_value2);
        if(read_value0 == 0x11111111 && read_value1 == 0x11111111 && read_value2 == 0x11111111)
            break;
    }
    printf("--------break point 3--------\n");
    #endif
    read_hash0(&hash_output0);
    read_hash1(&hash_output1);
    read_hash2(&hash_output2);

    printf("--------break point 4--------\n");
    write_control0(CONTROL_ACK);
    write_control1(CONTROL_ACK);
    write_control2(CONTROL_ACK);

    printf("----- OUTPUT OF ACC0 -----\n");
    printf("hash_output0.r0: %x\n", hash_output0.r0);
    printf("hash_output0.r1: %x\n", hash_output0.r1);
    printf("hash_output0.r2: %x\n", hash_output0.r2);
    printf("hash_output0.r3: %x\n", hash_output0.r3);
    printf("hash_output0.r4: %x\n", hash_output0.r4);
    printf("hash_output0.r5: %x\n", hash_output0.r5);
    printf("hash_output0.r6: %x\n", hash_output0.r6);
    printf("hash_output0.r7: %x\n", hash_output0.r7);

    printf("----- OUTPUT OF ACC1 -----\n");
    printf("hash_output1.r0: %x\n", hash_output1.r0);
    printf("hash_output1.r1: %x\n", hash_output1.r1);
    printf("hash_output1.r2: %x\n", hash_output1.r2);
    printf("hash_output1.r3: %x\n", hash_output1.r3);
    printf("hash_output1.r4: %x\n", hash_output1.r4);
    printf("hash_output1.r5: %x\n", hash_output1.r5);
    printf("hash_output1.r6: %x\n", hash_output1.r6);
    printf("hash_output1.r7: %x\n", hash_output1.r7);

    printf("----- OUTPUT OF ACC2 -----\n");
    printf("hash_output2.r0: %x\n", hash_output2.r0);
    printf("hash_output2.r1: %x\n", hash_output2.r1);
    printf("hash_output2.r2: %x\n", hash_output2.r2);
    printf("hash_output2.r3: %x\n", hash_output2.r3);
    printf("hash_output2.r4: %x\n", hash_output2.r4);
    printf("hash_output2.r5: %x\n", hash_output2.r5);
    printf("hash_output2.r6: %x\n", hash_output2.r6);
    printf("hash_output2.r7: %x\n", hash_output2.r7);
}

