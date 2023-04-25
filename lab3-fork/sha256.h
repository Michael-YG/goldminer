#ifndef _SHA256_H
#define _SHA256_H

#include <linux/ioctl.h>

typedef struct {
	unsigned w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;
} sha256_input;

typedef struct {
	unsigned h0, h1, h2, h3, h4, h5, h6, h7;
} sha256_hash;

typedef struct {
  sha256_input input;
  unsigned done;
  sha256_hash hash;
} sha256_arg;

#define SHA256_MAGIC 'q'

/* ioctls and their arguments */
#define WRITE_INPUT_0 _IOW(SHA256_MAGIC, 1, sha256_arg *)
#define WRITE_INPUT_1 _IOW(SHA256_MAGIC, 4, sha256_arg *)
#define WRITE_INPUT_2 _IOW(SHA256_MAGIC, 7, sha256_arg *)

#define READ_DONE_0   _IOW(SHA256_MAGIC, 2, sha256_arg *)
#define READ_DONE_1   _IOW(SHA256_MAGIC, 5, sha256_arg *)
#define READ_DONE_2   _IOW(SHA256_MAGIC, 8, sha256_arg *)

#define READ_HASH_0   _IOW(SHA256_MAGIC, 3, sha256_arg *)
#define READ_HASH_1   _IOW(SHA256_MAGIC, 6, sha256_arg *)
#define READ_HASH_2   _IOW(SHA256_MAGIC, 9, sha256_arg *)

#define RESET_0       _IOW(SHA256_MAGIC, 10, sha256_arg *)
#define RESET_1       _IOW(SHA256_MAGIC, 11, sha256_arg *)
#define RESET_2       _IOW(SHA256_MAGIC, 12, sha256_arg *)
#endif
