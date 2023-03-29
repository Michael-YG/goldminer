extern crate test;

//interfaces
//block diagram showing exactly what the hardware will do.

use std::num::Wrapping;
use std::ops::Shr;

const ROUNDS: u32 = 7;

#[allow(dead_code)]
pub fn say_hi() {
    println!("mod sha256 says hi!");
}

pub fn get_hash(bytes: &[u8]) -> String {
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
    //print_message_block(&vec);
    //assert!((vec.len() * 8) % 512 == 0);

    let mut h0 = H0;
    let mut h1 = H1;
    let mut h2 = H2;
    let mut h3 = H3;
    let mut h4 = H4;
    let mut h5 = H5;
    let mut h6 = H6;
    let mut h7 = H7;

    //let mut pointer = 0;
    //	while pointer < vec.len() {
    let mut data = 0x00000000u32;
    for _ in 0..ROUNDS {
        // ********** PART 1 ************ //

        let mut message_schedule = [Wrapping(0u32); 64];

        /*
                        for (i, byte) in vec[pointer..pointer + 64].iter().enumerate() {
                            message_schedule[i / 4].0 |= (*byte as u32) << (3 - (i % 4)) * 8;
                        }
        */
        for i in 0..16 {
            data = if data == 0xffffffff {
                0x00000000
            } else {
                data + 0x11111111
            };
            message_schedule[i] = Wrapping(data);
        }
        data = if data == 0xffffffff {
            0x00000000
        } else {
            data + 0x11111111
        };
        //print_schedule(&message_schedule);

        for i in 16..64 {
            let sigma_0 = sigma_0(message_schedule[i - 15]);
            let sigma_1 = sigma_1(message_schedule[i - 2]);
            message_schedule[i] =
                message_schedule[i - 16] + sigma_0 + message_schedule[i - 7] + sigma_1;
        }

        // ********** PART 2 ************ //

        let mut a = h0;
        let mut b = h1;
        let mut c = h2;
        let mut d = h3;
        let mut e = h4;
        let mut f = h5;
        let mut g = h6;
        let mut h = h7;

        let mut temp1: Wrapping<u32>;
        let mut temp2: Wrapping<u32>;

        for i in 0..64 {
            temp1 = h + sum_1(e) + choice(e, f, g) + K[i] + message_schedule[i];
            temp2 = sum_0(a) + majority(a, b, c);
            h = g;
            g = f;
            f = e;
            e = d + temp1;
            d = c;
            c = b;
            b = a;
            a = temp1 + temp2;
        }

        h0 += a;
        h1 += b;
        h2 += c;
        h3 += d;
        h4 += e;
        h5 += f;
        h6 += g;
        h7 += h;

        //pointer += 64;
    }

    format!(
        "{:0>8x} {:0>8x} {:0>8x} {:0>8x} {:0>8x} {:0>8x} {:0>8x} {:0>8x}",
        h0, h1, h2, h3, h4, h5, h6, h7
    )
}

#[cfg(test)]
mod tests {
    use super::*;
    use test::Bencher;

    #[test]
    fn single_message() {
        assert_eq!(
            "9fcef88ccb42a5170778e1febe81d7875d501f042e83266c0e2f05315a0c6f77",
            get_hash("My name is Jules!".as_bytes())
        );
    }

    #[bench]
    fn bench_add_two(b: &mut Bencher) {
        b.iter(|| get_hash("My name is Jules!".as_bytes()));
    }
}

fn sigma_0(Wrapping(w): Wrapping<u32>) -> Wrapping<u32> {
    return Wrapping(w.rotate_right(7) ^ w.rotate_right(18) ^ w.shr(3));
}

fn sigma_1(Wrapping(w): Wrapping<u32>) -> Wrapping<u32> {
    return Wrapping(w.rotate_right(17) ^ w.rotate_right(19) ^ w.shr(10));
}

fn sum_0(Wrapping(a): Wrapping<u32>) -> Wrapping<u32> {
    return Wrapping(a.rotate_right(2) ^ a.rotate_right(13) ^ a.rotate_right(22));
}

fn sum_1(Wrapping(e): Wrapping<u32>) -> Wrapping<u32> {
    return Wrapping(e.rotate_right(6) ^ e.rotate_right(11) ^ e.rotate_right(25));
}

fn choice(
    Wrapping(e): Wrapping<u32>,
    Wrapping(f): Wrapping<u32>,
    Wrapping(g): Wrapping<u32>,
) -> Wrapping<u32> {
    return Wrapping((e & f) ^ ((!e) & g));
}

fn majority(
    Wrapping(a): Wrapping<u32>,
    Wrapping(b): Wrapping<u32>,
    Wrapping(c): Wrapping<u32>,
) -> Wrapping<u32> {
    return Wrapping((a & b) ^ (a & c) ^ (b & c));
}

#[allow(dead_code)]
fn print_message_block(x: &Vec<u8>) {
    for i in 0..x.len() {
        print!("{:0>8b}", x[i]);
        if (i + 1) % 4 == 0 {
            print!("\n");
        } else {
            print!(" ");
        }
    }
    print!("\n");
}

#[allow(dead_code)]
fn print_schedule(x: &[Wrapping<u32>]) {
    for i in 0..x.len() {
        print!("w");
        print!("{:<3}", i);
        println!("{:0>8x}", x[i]);
    }
}

const H0: Wrapping<u32> = Wrapping(0x6a09e667);
const H1: Wrapping<u32> = Wrapping(0xbb67ae85);
const H2: Wrapping<u32> = Wrapping(0x3c6ef372);
const H3: Wrapping<u32> = Wrapping(0xa54ff53a);
const H4: Wrapping<u32> = Wrapping(0x510e527f);
const H5: Wrapping<u32> = Wrapping(0x9b05688c);
const H6: Wrapping<u32> = Wrapping(0x1f83d9ab);
const H7: Wrapping<u32> = Wrapping(0x5be0cd19);

const K: [Wrapping<u32>; 64] = [
    Wrapping(0x428a2f98),
    Wrapping(0x71374491),
    Wrapping(0xb5c0fbcf),
    Wrapping(0xe9b5dba5),
    Wrapping(0x3956c25b),
    Wrapping(0x59f111f1),
    Wrapping(0x923f82a4),
    Wrapping(0xab1c5ed5),
    Wrapping(0xd807aa98),
    Wrapping(0x12835b01),
    Wrapping(0x243185be),
    Wrapping(0x550c7dc3),
    Wrapping(0x72be5d74),
    Wrapping(0x80deb1fe),
    Wrapping(0x9bdc06a7),
    Wrapping(0xc19bf174),
    Wrapping(0xe49b69c1),
    Wrapping(0xefbe4786),
    Wrapping(0x0fc19dc6),
    Wrapping(0x240ca1cc),
    Wrapping(0x2de92c6f),
    Wrapping(0x4a7484aa),
    Wrapping(0x5cb0a9dc),
    Wrapping(0x76f988da),
    Wrapping(0x983e5152),
    Wrapping(0xa831c66d),
    Wrapping(0xb00327c8),
    Wrapping(0xbf597fc7),
    Wrapping(0xc6e00bf3),
    Wrapping(0xd5a79147),
    Wrapping(0x06ca6351),
    Wrapping(0x14292967),
    Wrapping(0x27b70a85),
    Wrapping(0x2e1b2138),
    Wrapping(0x4d2c6dfc),
    Wrapping(0x53380d13),
    Wrapping(0x650a7354),
    Wrapping(0x766a0abb),
    Wrapping(0x81c2c92e),
    Wrapping(0x92722c85),
    Wrapping(0xa2bfe8a1),
    Wrapping(0xa81a664b),
    Wrapping(0xc24b8b70),
    Wrapping(0xc76c51a3),
    Wrapping(0xd192e819),
    Wrapping(0xd6990624),
    Wrapping(0xf40e3585),
    Wrapping(0x106aa070),
    Wrapping(0x19a4c116),
    Wrapping(0x1e376c08),
    Wrapping(0x2748774c),
    Wrapping(0x34b0bcb5),
    Wrapping(0x391c0cb3),
    Wrapping(0x4ed8aa4a),
    Wrapping(0x5b9cca4f),
    Wrapping(0x682e6ff3),
    Wrapping(0x748f82ee),
    Wrapping(0x78a5636f),
    Wrapping(0x84c87814),
    Wrapping(0x8cc70208),
    Wrapping(0x90befffa),
    Wrapping(0xa4506ceb),
    Wrapping(0xbef9a3f7),
    Wrapping(0xc67178f2),
];
