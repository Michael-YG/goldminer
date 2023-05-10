#include <stdio.h>
#include "acc.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <memory.h>
#include <time.h>
#include "sha256.h"

// #define SPEED_TEST 10000
#define CONTROL_START 0xffffffff
#define CONTROL_RESET 0xff0000ff
#define CONTROL_ACK 0x0f0f0f0f

void write_control0(unsigned int command_arg);
void write_control1(unsigned int command_arg);
void write_control2(unsigned int command_arg);
void write_data0(const unsigned int * data);
void write_data1(const unsigned int * data);
void write_data2(const unsigned int * data);
void write_hash0(const registers_i_t * re);
void write_hash1(const registers_i_t * re);
void write_hash2(const registers_i_t * re);
void read_hash0(registers_o_t * re);
void read_hash1(registers_o_t * re);
void read_hash2(registers_o_t * re);
unsigned int read_control0();
unsigned int read_control1();
unsigned int read_control2();
void reset(int id);
void start(int id);
void ack(int id);
void display_hash(const registers_o_t * re, int id);

int sha256_acc_fd0, sha256_acc_fd1, sha256_acc_fd2;

int main(int argc, char *argv[])
{
    if(argc < 2){
        printf("Usage: ./miner s(software), h(hardware)\n");
        exit(1);
    }
    registers_i_t hash_input = {};
    registers_i_t hash_input1 = {};
    registers_i_t hash_input2 = {};
    registers_o_t hash_output0 = {};
    registers_o_t hash_output1 = {};
    registers_o_t hash_output2 = {};
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

    hash_input1.r0  = 0x04000020;
    hash_input1.r1  = 0x2c04d4c4;
    hash_input1.r2  = 0x50187d1d;
    hash_input1.r3  = 0xa9b1bc23;
    hash_input1.r4  = 0xba47d67f;
    hash_input1.r5  = 0xe028d224;
    hash_input1.r6  = 0x86fd0c00;
    hash_input1.r7  = 0x00000000;
    hash_input1.r8  = 0x00000000;
    hash_input1.r9  = 0x59a3a33d;
    hash_input1.r10 = 0x4642c799;
    hash_input1.r11 = 0xaf9f54a4;
    hash_input1.r12 = 0xdd351fff;
    hash_input1.r13 = 0x9130e6a8;
    hash_input1.r14 = 0x9d4e2511;
    hash_input1.r15 = 0x30c60064;

    hash_input2.r0  = 0x878616e9;
    hash_input2.r1  = 0x06b5ea60;
    hash_input2.r2  = 0xce981317;
    hash_input2.r3  = 0x3a25caf3;
    hash_input2.r4  = 0x80000000;
    hash_input2.r5  = 0x00000000;
    hash_input2.r6  = 0x00000000;
    hash_input2.r7  = 0x00000000;
    hash_input2.r8  = 0x00000000;
    hash_input2.r9  = 0x00000000;
    hash_input2.r10 = 0x00000000;
    hash_input2.r11 = 0x00000000;
    hash_input2.r12 = 0x00000000;
    hash_input2.r13 = 0x00000000;
    hash_input2.r14 = 0x00000000;
    hash_input2.r15 = 0x00000280;

    if(strcmp(argv[1], "s") == 0){
        printf("Software SHA256\n");
        SHA256_CTX ctx; 
        #ifdef SPEED_TEST
        clock_t start_s = clock(); 
        int i = 0;
        while (i < SPEED_TEST){
        #endif

        sha256_init(&ctx);
        sha256_transform(&ctx, (BYTE*)&hash_input1);
        sha256_transform(&ctx, (BYTE*)&hash_input2);

        #ifdef SPEED_TEST
        i++;
        }
        clock_t end_s = clock();
        double time_spent = (double)(end_s - start_s) / CLOCKS_PER_SEC;
        printf("Time elpased is %f seconds\n", time_spent);
        #endif

        display_hash((registers_o_t*)&ctx.state, 3);
        return 0;
    }

    else if(strcmp(argv[1], "h") == 0){
        printf("Hardware SHA256\n");
        static const char filename0[] = "/dev/sha256acc_1";
        static const char filename1[] = "/dev/sha256acc_2";
        static const char filename2[] = "/dev/sha256acc_3";

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
        reset(0);reset(1);reset(2);
        
        write_hash0(&hash_input);
        write_hash1(&hash_input);
        write_hash2(&hash_input);
        start(0);start(1);start(2);
        for(;;){
            // sleep(100);
            unsigned int read_value0 = read_control0();
            unsigned int read_value1 = read_control1();
            unsigned int read_value2 = read_control2();
            printf("read value0: %x\n",read_value0);
            if(read_value0 == 0x11111111 && read_value1 == 0x11111111 && read_value2 == 0x11111111)
                break;
        }

        read_hash0(&hash_output0);
        read_hash1(&hash_output1);
        read_hash2(&hash_output2);

        ack(0);ack(1);ack(2);
        printf("Fisrt round hash finished\n");
        // display_hash(&hash_output0, 0);
        // display_hash(&hash_output1, 1);
        // display_hash(&hash_output2, 2);
        reset(0);reset(1);reset(2);

        /* 
        write_hash0(&hash_input1);
        start(0);
        for(;;){
            unsigned int read_value0 = read_control0();
            printf("read value0: %x\n",read_value0);
            if(read_value0 == 0x11111111)
                break;
        }
        read_hash0(&hash_output0);
        read_hash1(&hash_output1);
        printf("Second round hash finished\n");
        display_hash(&hash_output0, 0);
        display_hash(&hash_output1, 1);
        ack(0);

        write_hash0(&hash_input);
        start(0);
        for(;;){
            unsigned int read_value0 = read_control0();
            printf("read value0: %x\n",read_value0);
            if(read_value0 == 0x11111111)
                break;
        }
        read_hash0(&hash_output0);
        read_hash0(&hash_output0);
        read_hash1(&hash_output1);
        printf("Third round hash finished\n");
        display_hash(&hash_output0, 0);
        display_hash(&hash_output1, 1);
        ack(0);
        */

        #ifdef SPEED_TEST 
        clock_t start_h = clock(); 
        int i = 0;
        while (i < SPEED_TEST){
        reset(0);
        #endif
        write_hash0(&hash_input1);
        start(0);
        ack(0);
        write_hash0(&hash_input2);
        start(0);
        ack(0);
        #ifdef SPEED_TEST
        i++;
        } 
        clock_t end_h = clock();
        double time_spent = (double)(end_h - start_h) / CLOCKS_PER_SEC;
        printf("Time elpased of hardware is %f seconds\n", time_spent);
        #endif
        read_hash0(&hash_output0);
        display_hash(&hash_output0, 0);

    }
}

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

void reset(int id){
    if(id == 0){
        write_control0(CONTROL_RESET);
    }
    else if(id == 1){
        write_control1(CONTROL_RESET);
    }
    else if(id == 2){
        write_control2(CONTROL_RESET);
    }
}

void ack(int id){
    if(id == 0){
        write_control0(CONTROL_ACK);
    }
    else if(id == 1){
        write_control1(CONTROL_ACK);
    }
    else if(id == 2){
        write_control2(CONTROL_ACK);
    }
}

void start(int id){
    if(id == 0){
        write_control0(CONTROL_START);
        write_control0(CONTROL_START);
    }
    else if(id == 1){
        write_control1(CONTROL_START);
        write_control1(CONTROL_START);
    }
    else if(id == 2){
        write_control2(CONTROL_START);
        write_control2(CONTROL_START);
    }
}

void display_hash(const registers_o_t* re, int id){
    if(id < 3){
        printf("----- OUTPUT OF ACC%d -----\n", id);
        printf("hash_output%d.r0: %x\n", id, re->r0);
        printf("hash_output%d.r1: %x\n", id, re->r1);
        printf("hash_output%d.r2: %x\n", id, re->r2);
        printf("hash_output%d.r3: %x\n", id, re->r3);
        printf("hash_output%d.r4: %x\n", id, re->r4);
        printf("hash_output%d.r5: %x\n", id, re->r5);
        printf("hash_output%d.r6: %x\n", id, re->r6);
        printf("hash_output%d.r7: %x\n", id, re->r7);
    } else if (id == 3){
        printf("----- OUTPUT OF sofware -----\n");
        printf("hash_output.r0: %x\n", re->r7);
        printf("hash_output.r1: %x\n", re->r6);
        printf("hash_output.r2: %x\n", re->r5);
        printf("hash_output.r3: %x\n", re->r4);
        printf("hash_output.r4: %x\n", re->r3);
        printf("hash_output.r5: %x\n", re->r2);
        printf("hash_output.r6: %x\n", re->r1);
        printf("hash_output.r7: %x\n", re->r0);
    }
}