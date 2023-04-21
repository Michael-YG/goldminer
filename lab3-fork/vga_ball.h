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
#define VGA_BALL_WRITE_INPUT_0 _IOW(VGA_BALL_MAGIC, 1, vga_ball_arg_t *)
#define VGA_BALL_READ_DONE_0   _IOW(VGA_BALL_MAGIC, 2, vga_ball_arg_t *)
#define VGA_BALL_READ_HASH_0   _IOW(VGA_BALL_MAGIC, 3, vga_ball_arg_t *)

#define VGA_BALL_WRITE_INPUT_1 _IOW(VGA_BALL_MAGIC, 4, vga_ball_arg_t *)
#define VGA_BALL_READ_DONE_1   _IOW(VGA_BALL_MAGIC, 5, vga_ball_arg_t *)
#define VGA_BALL_READ_HASH_1   _IOW(VGA_BALL_MAGIC, 6, vga_ball_arg_t *)

#define VGA_BALL_WRITE_INPUT_2 _IOW(VGA_BALL_MAGIC, 7, vga_ball_arg_t *)
#define VGA_BALL_READ_DONE_2   _IOW(VGA_BALL_MAGIC, 8, vga_ball_arg_t *)
#define VGA_BALL_READ_HASH_2   _IOW(VGA_BALL_MAGIC, 9, vga_ball_arg_t *)
#endif
