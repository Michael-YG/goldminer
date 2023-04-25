use libc::c_uint;
use nix::ioctl_write_int;
use std::os::unix::io::RawFd;

const SHA256_MAGIC: char = 'q';

const WRITE_INPUT_0: u8 = 1;
const WRITE_INPUT_1: u8 = 4;
const WRITE_INPUT_2: u8 = 7;

const READ_DONE_0: u8 = 2;
const READ_DONE_1: u8 = 5;
const READ_DONE_2: u8 = 8;

const READ_HASH_0: u8 = 3;
const READ_HASH_1: u8 = 6;
const READ_HASH_2: u8 = 9;

const RESET_0: u8 = 10;
const RESET_1: u8 = 11;
const RESET_2: u8 = 12;

ioctl_write_int!(write_input_0, SHA256_MAGIC, WRITE_INPUT_0);
ioctl_write_int!(write_input_1, SHA256_MAGIC, WRITE_INPUT_1);
ioctl_write_int!(write_input_2, SHA256_MAGIC, WRITE_INPUT_2);

ioctl_write_int!(read_done_0, SHA256_MAGIC, READ_DONE_0);
ioctl_write_int!(read_done_1, SHA256_MAGIC, READ_DONE_1);
ioctl_write_int!(read_done_2, SHA256_MAGIC, READ_DONE_2);

ioctl_write_int!(read_hash_0, SHA256_MAGIC, READ_HASH_0);
ioctl_write_int!(read_hash_1, SHA256_MAGIC, READ_HASH_1);
ioctl_write_int!(read_hash_2, SHA256_MAGIC, READ_HASH_2);

ioctl_write_int!(reset_0, SHA256_MAGIC, RESET_0);
ioctl_write_int!(reset_1, SHA256_MAGIC, RESET_1);
ioctl_write_int!(reset_2, SHA256_MAGIC, RESET_2);

#[derive(Copy, Clone, Debug, Default)]
#[repr(C)]
pub struct sha256_input {
    pub w0: c_uint,
    pub w1: c_uint,
    pub w2: c_uint,
    pub w3: c_uint,
    pub w4: c_uint,
    pub w5: c_uint,
    pub w6: c_uint,
    pub w7: c_uint,
    pub w8: c_uint,
    pub w9: c_uint,
    pub w10: c_uint,
    pub w11: c_uint,
    pub w12: c_uint,
    pub w13: c_uint,
    pub w14: c_uint,
    pub w15: c_uint,
}

#[derive(Debug, Default, Eq, PartialEq)]
#[repr(C)]
pub struct sha256_hash {
    pub h0: c_uint,
    pub h1: c_uint,
    pub h2: c_uint,
    pub h3: c_uint,
    pub h4: c_uint,
    pub h5: c_uint,
    pub h6: c_uint,
    pub h7: c_uint,
}

#[derive(Debug, Default)]
#[repr(C)]
pub struct sha256_arg {
    input: sha256_input,
    done: c_uint,
    hash: sha256_hash,
}

pub fn write_input(fd: RawFd, input: sha256_input, index: u8) {
    let mut vla = sha256_arg {
        input,
        hash: sha256_hash::default(),
        done: c_uint::default(),
    };
    let ptr = &mut vla as *mut sha256_arg;
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
    let mut vla = sha256_arg::default();
    let ptr = &mut vla as *mut sha256_arg;
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

pub fn read_hash(fd: RawFd, hash: &mut sha256_hash, index: u8) {
    let mut vla = sha256_arg::default();
    let ptr = &mut vla as *mut sha256_arg;
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
