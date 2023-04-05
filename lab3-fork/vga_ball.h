#ifndef _VGA_BALL_H
#define _VGA_BALL_H

#include <linux/ioctl.h>

typedef struct {
	unsigned w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;
} vga_ball_input_t;

typedef struct {
	unsigned h0, h1, h2, h3, h4, h5, h6, h7;
} vga_ball_hash_t;

typedef struct {
  vga_ball_input_t input;
  unsigned done;
  vga_ball_hash_t hash;
} vga_ball_arg_t;

#define VGA_BALL_MAGIC 'q'

/* ioctls and their arguments */
#define VGA_BALL_WRITE_INPUT _IOW(VGA_BALL_MAGIC, 1, vga_ball_arg_t *)
#define VGA_BALL_READ_DONE   _IOR(VGA_BALL_MAGIC, 2, vga_ball_arg_t *)
#define VGA_BALL_READ_HASH   _IOR(VGA_BALL_MAGIC, 3, vga_ball_arg_t *)
#endif
