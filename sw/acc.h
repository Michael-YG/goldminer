#ifndef _SHA256_H_
#define _SHA256_H_

#include <linux/ioctl.h>

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

typedef struct {
    unsigned int r0;
    unsigned int r1;
    unsigned int r2;
    unsigned int r3;
    unsigned int r4;
    unsigned int r5;
    unsigned int r6;
    unsigned int r7;
} registers_o_t;

typedef struct {
    unsigned int rr;
} control_signal_t;

typedef struct {
    registers_i_t registers_i;
    registers_o_t registers_o;
    control_signal_t control_signal;
} registers_arg_t;

#define SHA256_IOC_MAGIC 's'

// Commands definition
#define ACC_WRITE_HASH0 _IOW(SHA256_IOC_MAGIC, 1, registers_i_t *)
#define ACC_READ_HASH0 _IOR(SHA256_IOC_MAGIC, 2, registers_o_t *)
#define CONTROL_READ0 _IOR(SHA256_IOC_MAGIC, 3, unsigned int *)
#define CONTROL_WRITE0 _IOW(SHA256_IOC_MAGIC, 4, unsigned int *)

#define ACC_WRITE_HASH1 _IOW(SHA256_IOC_MAGIC, 5, registers_i_t *)
#define ACC_READ_HASH1 _IOR(SHA256_IOC_MAGIC, 6, registers_o_t *)
#define CONTROL_READ1 _IOR(SHA256_IOC_MAGIC, 7, unsigned int *)
#define CONTROL_WRITE1 _IOW(SHA256_IOC_MAGIC, 8, unsigned int *)

#define ACC_WRITE_HASH2 _IOW(SHA256_IOC_MAGIC, 9, registers_i_t *)
#define ACC_READ_HASH2 _IOR(SHA256_IOC_MAGIC, 10, registers_o_t *)
#define CONTROL_READ2 _IOR(SHA256_IOC_MAGIC, 11, unsigned int *)
#define CONTROL_WRITE2 _IOW(SHA256_IOC_MAGIC, 12, unsigned int *)

#endif