use libc::c_uint;
use nix::ioctl_write_int;
use std::fs::OpenOptions;
use std::os::unix::io::{AsRawFd, RawFd};

const DEBUG: bool = false;
const VGA_BALL_MAGIC: char = 'q';
const WRITE_INPUT_0: u8 = 1;
const READ_DONE_0: u8 = 2;
const READ_HASH_0: u8 = 3;

const WRITE_INPUT_1: u8 = 4;
const READ_DONE_1: u8 = 5;
const READ_HASH_1: u8 = 6;

const WRITE_INPUT_2: u8 = 7;
const READ_DONE_2: u8 = 8;
const READ_HASH_2: u8 = 9;

ioctl_write_int!(write_input_0, VGA_BALL_MAGIC, WRITE_INPUT_0);
ioctl_write_int!(read_done_0, VGA_BALL_MAGIC, READ_DONE_0);
ioctl_write_int!(read_hash_0, VGA_BALL_MAGIC, READ_HASH_0);

ioctl_write_int!(write_input_1, VGA_BALL_MAGIC, WRITE_INPUT_1);
ioctl_write_int!(read_done_1, VGA_BALL_MAGIC, READ_DONE_1);
ioctl_write_int!(read_hash_1, VGA_BALL_MAGIC, READ_HASH_1);

ioctl_write_int!(write_input_2, VGA_BALL_MAGIC, WRITE_INPUT_2);
ioctl_write_int!(read_done_2, VGA_BALL_MAGIC, READ_DONE_2);
ioctl_write_int!(read_hash_2, VGA_BALL_MAGIC, READ_HASH_2);

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

fn write_input(fd: RawFd, input: vga_ball_input_t, index: u8) {
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

fn read_done(fd: RawFd, done: &mut c_uint, index: u8) {
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

fn read_hash(fd: RawFd, hash: &mut vga_ball_hash_t, index: u8) {
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

fn main() {
    let file_0 = OpenOptions::new()
        .read(true)
        .write(true)
        .open("/dev/vga_ball_0")
        .unwrap();

    let file_1 = OpenOptions::new()
        .read(true)
        .write(true)
        .open("/dev/vga_ball_1")
        .unwrap();

    let file_2 = OpenOptions::new()
        .read(true)
        .write(true)
        .open("/dev/vga_ball_2")
        .unwrap();

    let input = vga_ball_input_t {
        w0: 0x5e824e54,
        w1: 0xfe9dd9c5,
        w2: 0x968697c0,
        w3: 0xd3b72297,

        w4: 0x6349fa44,
        w5: 0xd5abe17f,
        w6: 0xae68fd79,
        w7: 0x511e972a,

        w8: 0xb64b80c8,
        w9: 0x6ae5422f,
        w10: 0xaa4dcc23,
        w11: 0x77f7aa64,

        w12: 0x7f27019d,
        w13: 0x14bcd278,
        w14: 0xac411c94,
        w15: 0x5f0909fa,
    };

    for _ in 0..3 {
        let mut done: c_uint = 0;

        write_input(file_0.as_raw_fd(), input, 0);
        write_input(file_1.as_raw_fd(), input, 1);
        write_input(file_2.as_raw_fd(), input, 2);

        loop {
            read_done(file_0.as_raw_fd(), &mut done, 0);
            if done == 1 {
                break;
            };
        }
        done = 0;
        loop {
            read_done(file_1.as_raw_fd(), &mut done, 1);
            if done == 1 {
                break;
            };
        }
        done = 0;
        loop {
            read_done(file_2.as_raw_fd(), &mut done, 2);
            if done == 1 {
                break;
            };
        }
    }
    let mut output_0: vga_ball_hash_t = vga_ball_hash_t::default();
    let mut output_1: vga_ball_hash_t = vga_ball_hash_t::default();
    let mut output_2: vga_ball_hash_t = vga_ball_hash_t::default();
    read_hash(file_0.as_raw_fd(), &mut output_0, 0);
    read_hash(file_1.as_raw_fd(), &mut output_1, 1);
    read_hash(file_2.as_raw_fd(), &mut output_2, 2);

    let gold = vga_ball_hash_t {
        h0: 0x23382b78,
        h1: 0x8b62c109,
        h2: 0xc868ec89,
        h3: 0xbff6985d,
        h4: 0x7d5056f7,
        h5: 0x7cf1c3a8,
        h6: 0x9e532f2b,
        h7: 0x783da0dc,
    };

    if DEBUG {
        println!("{:x?}", output_0);
        println!("{:x?}", output_1);
        println!("{:x?}", output_2);
    }

    if output_0 == gold {
        println!("PASS");
    } else {
        println!("FAIL");
    }
    if output_1 == gold {
        println!("PASS");
    } else {
        println!("FAIL");
    }
    if output_2 == gold {
        println!("PASS");
    } else {
        println!("FAIL");
    }
}
