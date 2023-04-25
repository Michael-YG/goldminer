use crate::acc::{read_done, read_hash, reset, vga_ball_hash_t, vga_ball_input_t, write_input};
use libc::c_uint;
use std::fs::OpenOptions;
use std::os::unix::io::AsRawFd;

pub fn get_hash(bytes: &[u8], index: u8) -> Vec<u8> {
    let mut ret = Vec::<u8>::with_capacity(32);
    let len = bytes.len();
    let bits = len * 8;
    let length: u64 = bits.try_into().unwrap();
    let capacity: usize = ((len + 64) >> 6) << 6;
    let mut vec = Vec::<u8>::with_capacity(capacity);
    vec.extend_from_slice(bytes);
    vec.extend_from_slice(&[0x80u8]);
    while (vec.len() + 8) % 64 != 0 {
        vec.push(0u8);
    }
    vec.extend_from_slice(&length.to_be_bytes());

    let file = match index {
        0 => OpenOptions::new()
            .read(true)
            .write(true)
            .open("/dev/vga_ball_0")
            .unwrap(),
        1 => OpenOptions::new()
            .read(true)
            .write(true)
            .open("/dev/vga_ball_1")
            .unwrap(),
        _ => OpenOptions::new()
            .read(true)
            .write(true)
            .open("/dev/vga_ball_2")
            .unwrap(),
    };
    let raw_fd = file.as_raw_fd();

    reset(raw_fd, index);

    let mut pointer = 0;
    while pointer < vec.len() {
        let base = pointer;
        let input = vga_ball_input_t {
            w0: u32::from_be_bytes(vec[base + 0..base + 4].try_into().unwrap()),
            w1: u32::from_be_bytes(vec[base + 4..base + 8].try_into().unwrap()),
            w2: u32::from_be_bytes(vec[base + 8..base + 12].try_into().unwrap()),
            w3: u32::from_be_bytes(vec[base + 12..base + 16].try_into().unwrap()),
            w4: u32::from_be_bytes(vec[base + 16..base + 20].try_into().unwrap()),
            w5: u32::from_be_bytes(vec[base + 20..base + 24].try_into().unwrap()),
            w6: u32::from_be_bytes(vec[base + 24..base + 28].try_into().unwrap()),
            w7: u32::from_be_bytes(vec[base + 28..base + 32].try_into().unwrap()),
            w8: u32::from_be_bytes(vec[base + 32..base + 36].try_into().unwrap()),
            w9: u32::from_be_bytes(vec[base + 36..base + 40].try_into().unwrap()),
            w10: u32::from_be_bytes(vec[base + 40..base + 44].try_into().unwrap()),
            w11: u32::from_be_bytes(vec[base + 44..base + 48].try_into().unwrap()),
            w12: u32::from_be_bytes(vec[base + 48..base + 52].try_into().unwrap()),
            w13: u32::from_be_bytes(vec[base + 52..base + 56].try_into().unwrap()),
            w14: u32::from_be_bytes(vec[base + 56..base + 60].try_into().unwrap()),
            w15: u32::from_be_bytes(vec[base + 60..base + 64].try_into().unwrap()),
        };
        write_input(raw_fd, input, index);

        let mut done: c_uint = 0;
        loop {
            read_done(raw_fd, &mut done, index);
            if done == 1 {
                break;
            }
        }

        pointer += 64;
    }

    let mut hash: vga_ball_hash_t = vga_ball_hash_t::default();
    read_hash(raw_fd, &mut hash, index);
    for value in [
        hash.h0, hash.h1, hash.h2, hash.h3, hash.h4, hash.h5, hash.h6, hash.h7,
    ] {
        let bytes = value.to_be_bytes();
        ret.extend_from_slice(&bytes);
    }

    ret
}
