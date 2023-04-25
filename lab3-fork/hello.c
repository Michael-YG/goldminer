/*
 * Userspace program that communicates with the vga_ball device driver
 * through ioctls
 *
 * Stephen A. Edwards
 * Columbia University
 */

#include <stdio.h>
#include "sha256.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>

int sha256_fd_0, sha256_fd_1, sha256_fd_2;


void write_input(const sha256_input *input, int index)
{
  sha256_arg vla;
  vla.input = *input;
  switch(index) {
    case 0:
      if(ioctl(sha256_fd_0, WRITE_INPUT_0, &vla)) {
        perror("ioctl(WRITE_INPUT_0) failed");
        return;
      }
      break;
    case 1:
      if(ioctl(sha256_fd_1, WRITE_INPUT_1, &vla)) {
        perror("ioctl(WRITE_INPUT_1) failed");
        return;
      }
      break;
    case 2:
      if(ioctl(sha256_fd_2, WRITE_INPUT_2, &vla)) {
        perror("ioctl(WRITE_INPUT_2) failed");
        return;
      }
      break;
  }
}

void reset(int index)
{
  sha256_arg vla;
  switch(index) {
    case 0:
      if(ioctl(sha256_fd_0, RESET_0, &vla)) {
        perror("ioctl(RESET_0) failed");
        return;
      }
      break;
    case 1:
      if(ioctl(sha256_fd_1, RESET_1, &vla)) {
        perror("ioctl(RESET_1) failed");
        return;
      }
      break;
    case 2:
      if(ioctl(sha256_fd_2, RESET_2, &vla)) {
        perror("ioctl(RESET_2) failed");
        return;
      }
      break;
  }
}

void read_hash(sha256_hash *hash, int index)
{
  sha256_arg vla;
  switch(index) {
    case 0:
      if (ioctl(sha256_fd_0, READ_HASH_0, &vla)) {
          perror("ioctl(READ_HASH_0) failed");
          return;
      }
      break;
    case 1:
      if (ioctl(sha256_fd_1, READ_HASH_1, &vla)) {
          perror("ioctl(READ_HASH_1) failed");
          return;
      }
      break;
    case 2:
      if (ioctl(sha256_fd_2, READ_HASH_2, &vla)) {
          perror("ioctl(READ_HASH_2) failed");
          return;
      }
      break;
  }
  *hash = vla.hash;
}

void read_done(unsigned *done, int index)
{
  sha256_arg vla;
  switch(index) {
    case 0:
      if (ioctl(sha256_fd_0, READ_DONE_0, &vla)) {
          perror("ioctl(READ_DONE_0) failed");
          return;
      }
      break;
    case 1:
      if (ioctl(sha256_fd_1, READ_DONE_1, &vla)) {
          perror("ioctl(READ_DONE_1) failed");
          return;
      }
      break;
    case 2:
      if (ioctl(sha256_fd_2, READ_DONE_2, &vla)) {
          perror("ioctl(READ_DONE_2) failed");
          return;
      }
      break;
  }
  *done = vla.done;
}

int main()
{
  sha256_arg vla;
  static const char filename_0[] = "/dev/sha256_0";
  static const char filename_1[] = "/dev/sha256_1";
  static const char filename_2[] = "/dev/sha256_2";

  printf("SHA256 Userspace program started\n");

  if ( (sha256_fd_0 = open(filename_0, O_RDWR)) == -1) {
    fprintf(stderr, "could not open %s\n", filename_0);
    return -1;
  }
  if ( (sha256_fd_1 = open(filename_1, O_RDWR)) == -1) {
    fprintf(stderr, "could not open %s\n", filename_1);
    return -1;
  }
  if ( (sha256_fd_2 = open(filename_2, O_RDWR)) == -1) {
    fprintf(stderr, "could not open %s\n", filename_2);
    return -1;
  }

  unsigned done = 0;
  unsigned debug = 0;

  sha256_input input;
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

  write_input(&input, 0);
  write_input(&input, 1);
  write_input(&input, 2);
  while (1) {
    read_done(&done, 0);
    if(done) break;
  }
  while (1) {
    read_done(&done, 1);
    if(done) break;
  }
  while (1) {
    read_done(&done, 2);
    if(done) break;
  }
  reset(0);
  reset(1);
  reset(2);
  write_input(&input, 0);
  write_input(&input, 1);
  write_input(&input, 2);
  while (1) {
    read_done(&done, 0);
    if(done) break;
  }
  while (1) {
    read_done(&done, 1);
    if(done) break;
  }
  while (1) {
    read_done(&done, 2);
    if(done) break;
  }
  write_input(&input, 0);
  write_input(&input, 1);
  write_input(&input, 2);
  while (1) {
    read_done(&done, 0);
    if(done) break;
  }
  while (1) {
    read_done(&done, 1);
    if(done) break;
  }
  while (1) {
    read_done(&done, 2);
    if(done) break;
  }
  write_input(&input, 0);
  write_input(&input, 1);
  write_input(&input, 2);
  while (1) {
    read_done(&done, 0);
    if(done) break;
  }
  while (1) {
    read_done(&done, 1);
    if(done) break;
  }
  while (1) {
    read_done(&done, 2);
    if(done) break;
  }

  //printf("%x\n", done);

  sha256_hash hash_0;
  hash_0.h0 = 0x00000000;
  hash_0.h1 = 0x00000000;
  hash_0.h2 = 0x00000000;
  hash_0.h3 = 0x00000000;
  hash_0.h4 = 0x00000000;
  hash_0.h5 = 0x00000000;
  hash_0.h6 = 0x00000000;
  hash_0.h7 = 0x00000000;
  read_hash(&hash_0, 0);

  sha256_hash hash_1;
  hash_1.h0 = 0x00000000;
  hash_1.h1 = 0x00000000;
  hash_1.h2 = 0x00000000;
  hash_1.h3 = 0x00000000;
  hash_1.h4 = 0x00000000;
  hash_1.h5 = 0x00000000;
  hash_1.h6 = 0x00000000;
  hash_1.h7 = 0x00000000;
  read_hash(&hash_1, 1);

  sha256_hash hash_2;
  hash_2.h0 = 0x00000000;
  hash_2.h1 = 0x00000000;
  hash_2.h2 = 0x00000000;
  hash_2.h3 = 0x00000000;
  hash_2.h4 = 0x00000000;
  hash_2.h5 = 0x00000000;
  hash_2.h6 = 0x00000000;
  hash_2.h7 = 0x00000000;
  read_hash(&hash_2, 2);

  if(debug) {
    printf("%x\n", hash_0.h0);
    printf("%x\n", hash_0.h1);
    printf("%x\n", hash_0.h2);
    printf("%x\n", hash_0.h3);
    printf("%x\n", hash_0.h4);
    printf("%x\n", hash_0.h5);
    printf("%x\n", hash_0.h6);
    printf("%x\n", hash_0.h7);

    printf("%x\n", hash_1.h0);
    printf("%x\n", hash_1.h1);
    printf("%x\n", hash_1.h2);
    printf("%x\n", hash_1.h3);
    printf("%x\n", hash_1.h4);
    printf("%x\n", hash_1.h5);
    printf("%x\n", hash_1.h6);
    printf("%x\n", hash_1.h7);

    printf("%x\n", hash_2.h0);
    printf("%x\n", hash_2.h1);
    printf("%x\n", hash_2.h2);
    printf("%x\n", hash_2.h3);
    printf("%x\n", hash_2.h4);
    printf("%x\n", hash_2.h5);
    printf("%x\n", hash_2.h6);
    printf("%x\n", hash_2.h7);
  }

  unsigned golden[8] = {0x23382b78, 0x8b62c109, 0xc868ec89, 0xbff6985d,
                        0x7d5056f7, 0x7cf1c3a8, 0x9e532f2b, 0x783da0dc};
  unsigned pass = 0;

  if (hash_0.h0 == golden[0] && hash_0.h1 == golden[1] && hash_0.h2 == golden[2] && hash_0.h3 == golden[3]
  &&  hash_0.h4 == golden[4] && hash_0.h5 == golden[5] && hash_0.h6 == golden[6] && hash_0.h7 == golden[7])
    pass = 1;
  if (pass)
    printf("PASS\n");
  else
    printf("FAIL\n");

  pass = 0;
  if (hash_1.h0 == golden[0] && hash_1.h1 == golden[1] && hash_1.h2 == golden[2] && hash_1.h3 == golden[3]
  &&  hash_1.h4 == golden[4] && hash_1.h5 == golden[5] && hash_1.h6 == golden[6] && hash_1.h7 == golden[7])
    pass = 1;
  if (pass)
    printf("PASS\n");
  else
    printf("FAIL\n");

  pass = 0;
  if (hash_2.h0 == golden[0] && hash_2.h1 == golden[1] && hash_2.h2 == golden[2] && hash_2.h3 == golden[3]
  &&  hash_2.h4 == golden[4] && hash_2.h5 == golden[5] && hash_2.h6 == golden[6] && hash_2.h7 == golden[7])
    pass = 1;
  if (pass)
    printf("PASS\n");
  else
    printf("FAIL\n");

  printf("SHA256 Userspace program terminating\n");
  return 0;
}
