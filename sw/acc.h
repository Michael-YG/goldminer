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
#define ACC_WRITE_HASH _IOW(SHA256_IOC_MAGIC, 1, registers_i_t *)
#define ACC_READ_HASH _IOR(SHA256_IOC_MAGIC, 2, registers_o_t *)
#define CONTROL_READ _IOR(SHA256_IOC_MAGIC, 3, unsigned int *)
#define CONTROL_WRITE _IOW(SHA256_IOC_MAGIC, 4, unsigned int *)

#endif