#ifndef _SHA256_H_
#define _SHA256_h_

#include <linux/icotl.h>

typedef struct {
    unsigned int i0;
    unsigned int i1;
    unsigned int i2;
    unsigned int i3;
    unsigned int i4;
    unsigned int i5;
    unsigned int i6;
    unsigned int i7;
    unsigned int i8;
    unsigned int i9;
    unsigned int i10;
    unsigned int i11;
    unsigned int i12;
    unsigned int i13;
    unsigned int i14;
    unsigned int i15;
} hashi_t;

typedef struct {
    hashi_t hash_input;
} hashi_arg_t;

typedef struct {
    unsigned int o0;
    unsigned int o1;
    unsigned int o2;
    unsigned int o3;
    unsigned int o4;
    unsigned int o5;
    unsigned int o6;
    unsigned int o7;
    unsigned int o8;
    unsigned int o9;
    unsigned int o10;
    unsigned int o11;
    unsigned int o12;
    unsigned int o13;
    unsigned int o14;
    unsigned int o15;
} hasho_t;

typedef struct {
    hasho_t hash_output;
} hasho_arg_t;

#define SHA256_IOC_MAGIC 's'


#endif