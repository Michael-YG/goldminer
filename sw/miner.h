#ifndef _MINER_H_
#define _MINER_H_

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

#endif