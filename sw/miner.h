#ifndef _MINER_H_
#define _MINER_H_
#include "acc.h"

static registers_i_t hash_input = {
    0x000000dc,
    0x00000000,
    0x3239b540,
    0x3339b233,
    0x30b33239,
    0xb335b239,
    0xb5b239b5,
    0x39b0b533,
    0x33353235,
    0xb530b5b6,
    0x30b335b2,
    0x35b239b5,
    0x39b0b533,
    0x3239b0b3,
    0x00000000,
    0x000001bf
};

// 040000202c04d4c450187d1da9b1bc23ba47d67fe028d22486fd0c00000000000000000059a3a33d4642c799af9f54a4dd351fff9130e6a89d4e251130c60064878616e906b5ea60ce9813173a25caf3
static registers_i_t hash_input1 = {
    0x04000020,
    0x2c04d4c4,
    0x50187d1d,
    0xa9b1bc23,
    0xba47d67f,
    0xe028d224,
    0x86fd0c00,
    0x00000000,
    0x00000000,
    0x59a3a33d,
    0x4642c799,
    0xaf9f54a4,
    0xdd351fff,
    0x9130e6a8,
    0x9d4e2511,
    0x30c60064
};

static registers_i_t hash_input2 = {
    0x878616e9,
    0x06b5ea60,
    0xce981317,
    0x3a25caf3,
    0x80000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000280
};

//02000000ce0782217396e8f2e91e0b76a8a245cff7f13efab645c51000000000000000006c684bb0477609cbc986385c38fc628cce68f7d52e26b466e3ba5ef07bb83c9df30f94558e41161818426aac
static registers_i_t hash_input3 = {
    0x02000000,
    0xce078221,
    0x7396e8f2,
    0xe91e0b76,
    0xa8a245cf,
    0xf7f13efa,
    0xb645c510,
    0x00000000,
    0x00000000,
    0x6c684bb0,
    0x477609cb,
    0xc986385c,
    0x38fc628c,
    0xce68f7d5,
    0x2e26b466,
    0xe3ba5ef0
};

static registers_i_t hash_input4 = {
    0x7bb83c9d,
    0xf30f9455,
    0x8e411618,
    0x18426aac,
    0x80000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000280
};

#endif