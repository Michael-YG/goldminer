/*
 * Userspace program that communicates with the vga_ball device driver
 * through ioctls
 *
 * Stephen A. Edwards
 * Columbia University
 */

#include <stdio.h>
#include "vga_ball.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>

int vga_ball_fd;


void write_input(const vga_ball_input_t *input)
{
  vga_ball_arg_t vla;
  vla.input = *input;
  if (ioctl(vga_ball_fd, VGA_BALL_WRITE_INPUT, &vla)) {
      perror("ioctl(VGA_BALL_WRITE_INPUT) failed");
      return;
  }
}

void read_hash(vga_ball_hash_t *hash)
{
  vga_ball_arg_t vla;
  if (ioctl(vga_ball_fd, VGA_BALL_READ_HASH, &vla)) {
      perror("ioctl(VGA_BALL_READ_HASH) failed");
      return;
  }
  *hash = vla.hash;
}

void read_done(unsigned *done)
{
  vga_ball_arg_t vla;
  if (ioctl(vga_ball_fd, VGA_BALL_READ_DONE, &vla)) {
      perror("ioctl(VGA_BALL_READ_DONE) failed");
      return;
  }
  *done = vla.done;
}

int main()
{
  vga_ball_arg_t vla;
  static const char filename[] = "/dev/vga_ball";

  printf("VGA ball Userspace program started\n");

  if ( (vga_ball_fd = open(filename, O_RDWR)) == -1) {
    fprintf(stderr, "could not open %s\n", filename);
    return -1;
  }

  unsigned done = 0;
  unsigned debug = 0;

  vga_ball_input_t input;
  input.w0  = 0x5e824e54;
  input.w1  = 0xfe9dd9c5;
  input.w2  = 0x968697c0;
  input.w3  = 0xd3b72297;

  input.w4  = 0x6349fa44;
  input.w5  = 0xd5abe17f;
  input.w6  = 0xae68fd79;
  input.w7  = 0x511e972a;

  input.w8  = 0xb64b80c8;
  input.w9  = 0x6ae5422f;
  input.w10 = 0xaa4dcc23;
  input.w11 = 0x77f7aa64;

  input.w12 = 0x7f27019d;
  input.w13 = 0x14bcd278;
  input.w14 = 0xac411c94;
  input.w15 = 0x5f0909fa;

  write_input(&input);
  while (1) {
    read_done(&done);
    if(done) break;
  }
  write_input(&input);
  while (1) {
    read_done(&done);
    if(done) break;
  }
  write_input(&input);
  while (1) {
    read_done(&done);
    if(done) break;
  }

  printf("%x\n", done);

  vga_ball_hash_t hash;
  hash.h0 = 0x00000000;
  hash.h1 = 0x00000000;
  hash.h2 = 0x00000000;
  hash.h3 = 0x00000000;
  hash.h4 = 0x00000000;
  hash.h5 = 0x00000000;
  hash.h6 = 0x00000000;
  hash.h7 = 0x00000000;
  read_hash(&hash);

  if(debug) {
    printf("%x\n", hash.h0);
    printf("%x\n", hash.h1);
    printf("%x\n", hash.h2);
    printf("%x\n", hash.h3);
    printf("%x\n", hash.h4);
    printf("%x\n", hash.h5);
    printf("%x\n", hash.h6);
    printf("%x\n", hash.h7);
  }

  unsigned golden[8] = {0x23382b78, 0x8b62c109, 0xc868ec89, 0xbff6985d,
                        0x7d5056f7, 0x7cf1c3a8, 0x9e532f2b, 0x783da0dc};
  unsigned pass = 0;

  if (hash.h0 == golden[0] && hash.h1 == golden[1] && hash.h2 == golden[2] && hash.h3 == golden[3]
  &&  hash.h4 == golden[4] && hash.h5 == golden[5] && hash.h6 == golden[6] && hash.h7 == golden[7])
    pass = 1;

  if (pass)
    printf("PASS\n");
  else
    printf("FAIL\n");

  printf("VGA BALL Userspace program terminating\n");
  return 0;
}
