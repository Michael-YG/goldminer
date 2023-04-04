#ifndef _SHA256_H_
#define _SHA256_h_

#include <linux/icotl.h>

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
    // unsigned int r16; // wirte only sw -> hw
    // unsigned int r17; // read only: hw -> sw
} registers_t;

typedef struct {
    unsigned int rw;
    unsigned int rr;
} control_signal_t;

typedef struct {
    registers_t registers;
    control_signal_t control_signal;
} registers_arg_t;

// typedef struct {
//     unsigned int o0;
//     unsigned int o1;
//     unsigned int o2;
//     unsigned int o3;
//     unsigned int o4;
//     unsigned int o5;
//     unsigned int o6;
//     unsigned int o7;
//     unsigned int o8;
//     unsigned int o9;
//     unsigned int o10;
//     unsigned int o11;
//     unsigned int o12;
//     unsigned int o13;
//     unsigned int o14;
//     unsigned int o15;
// } hasho_t;

// typedef struct {
//     hasho_t hash_output;
// } hasho_arg_t;

#define SHA256_IOC_MAGIC 's'

// Commands definition
#define ACC_WRITE_HASH _IOW(SHA256_IOC_MAGIC, 1, registers_arg_t *)
#define ACC_READ_HASH _IOR(SHA256_IOC_MAGIC, 2, registers_arg_t *)
#define CONTROL_READ _IOR(SHA256_IOC_MAGIC, 3, unsigned int *)
#define CONTROL_WRITE _IOW(SHA256_IOC_MAGIC, 4, unsigned int *)
#define ACK_WRITE _IOW(SHA256_IOC_MAGIC, 5, unsigned int *)

#endif