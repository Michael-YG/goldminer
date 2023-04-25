use libc::c_uint;
use nix::ioctl_write_int;
use std::fs::OpenOptions;
use std::os::unix::io::{AsRawFd, RawFd};

const DEBUG: bool = false;
const VGA_BALL_MAGIC: char = 'q';
const WRITE_INPUT_0: u8 = 1;
const READ_DONE_0: u8 = 2;
const READ_HASH_0: u8 = 3;
const RESET_0: u8 = 10;

const WRITE_INPUT_1: u8 = 4;
const READ_DONE_1: u8 = 5;
const READ_HASH_1: u8 = 6;
const RESET_1: u8 = 11;

const WRITE_INPUT_2: u8 = 7;
const READ_DONE_2: u8 = 8;
const READ_HASH_2: u8 = 9;
const RESET_2: u8 = 12;

ioctl_write_int!(write_input_0, VGA_BALL_MAGIC, WRITE_INPUT_0);
ioctl_write_int!(read_done_0, VGA_BALL_MAGIC, READ_DONE_0);
ioctl_write_int!(read_hash_0, VGA_BALL_MAGIC, READ_HASH_0);
ioctl_write_int!(reset_0, VGA_BALL_MAGIC, RESET_0);

ioctl_write_int!(write_input_1, VGA_BALL_MAGIC, WRITE_INPUT_1);
ioctl_write_int!(read_done_1, VGA_BALL_MAGIC, READ_DONE_1);
ioctl_write_int!(read_hash_1, VGA_BALL_MAGIC, READ_HASH_1);
ioctl_write_int!(reset_1, VGA_BALL_MAGIC, RESET_1);

ioctl_write_int!(write_input_2, VGA_BALL_MAGIC, WRITE_INPUT_2);
ioctl_write_int!(read_done_2, VGA_BALL_MAGIC, READ_DONE_2);
ioctl_write_int!(read_hash_2, VGA_BALL_MAGIC, READ_HASH_2);
ioctl_write_int!(reset_2, VGA_BALL_MAGIC, RESET_2);

#[allow(dead_code)]
pub fn say_hi() {
    println!("mod acc says hi!");
}

#[derive(Copy, Clone, Debug, Default)]
#[repr(C)]
pub struct vga_ball_input_t {
    w0: c_uint,
    w1: c_uint,
    w2: c_uint,
    w3: c_uint,
    w4: c_uint,
    w5: c_uint,
    w6: c_uint,
    w7: c_uint,
    w8: c_uint,
    w9: c_uint,
    w10: c_uint,
    w11: c_uint,
    w12: c_uint,
    w13: c_uint,
    w14: c_uint,
    w15: c_uint,
}

#[derive(Debug, Default, Eq, PartialEq)]
#[repr(C)]
pub struct vga_ball_hash_t {
    h0: c_uint,
    h1: c_uint,
    h2: c_uint,
    h3: c_uint,
    h4: c_uint,
    h5: c_uint,
    h6: c_uint,
    h7: c_uint,
}

#[derive(Debug, Default)]
#[repr(C)]
pub struct vga_ball_arg_t {
    input: vga_ball_input_t,
    done: c_uint,
    hash: vga_ball_hash_t,
}

pub fn write_input(fd: RawFd, input: vga_ball_input_t, index: u8) {
    let mut vla = vga_ball_arg_t {
        input,
        hash: vga_ball_hash_t::default(),
        done: c_uint::default(),
    };
    let ptr = &mut vla as *mut vga_ball_arg_t;
    let addr = ptr as u32;

    match index {
        0 => unsafe {
            write_input_0(fd, addr).unwrap();
        },
        1 => unsafe {
            write_input_1(fd, addr).unwrap();
        },
        2 => unsafe {
            write_input_2(fd, addr).unwrap();
        },
        _ => println!("Didn't match"),
    }
}

pub fn read_done(fd: RawFd, done: &mut c_uint, index: u8) {
    let mut vla = vga_ball_arg_t::default();
    let ptr = &mut vla as *mut vga_ball_arg_t;
    let addr = ptr as u32;

    match index {
        0 => unsafe {
            read_done_0(fd, addr).unwrap();
        },
        1 => unsafe {
            read_done_1(fd, addr).unwrap();
        },
        2 => unsafe {
            read_done_2(fd, addr).unwrap();
        },
        _ => println!("Didn't match"),
    }

    *done = vla.done;
}

pub fn read_hash(fd: RawFd, hash: &mut vga_ball_hash_t, index: u8) {
    let mut vla = vga_ball_arg_t::default();
    let ptr = &mut vla as *mut vga_ball_arg_t;
    let addr = ptr as u32;

    match index {
        0 => unsafe {
            read_hash_0(fd, addr).unwrap();
        },
        1 => unsafe {
            read_hash_1(fd, addr).unwrap();
        },
        2 => unsafe {
            read_hash_2(fd, addr).unwrap();
        },
        _ => println!("Didn't match"),
    }

    *hash = vla.hash;
}

pub fn reset(fd: RawFd, index: u8) {
    match index {
        0 => unsafe {
            reset_0(fd, 0).unwrap();
        },
        1 => unsafe {
            reset_1(fd, 0).unwrap();
        },
        2 => unsafe {
            reset_2(fd, 0).unwrap();
        },
        _ => println!("Didn't match"),
    }
}
