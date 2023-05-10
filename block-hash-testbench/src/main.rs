use bitcoin::blockdata::block::Header;
use bitcoin::consensus::Decodable;
use bitcoin::hashes::Hash;
use rand::{thread_rng, Rng};
use std::io::Cursor;
use std::time::{Duration, Instant};

mod acc;
mod sha256_hw;
mod sha256_sw;

const DEBUG: bool = true;
const TESTS: u32 = 25;

fn run_test(height: u32, gold_time: &mut Duration, hw_time: &mut Duration, sw_time: &mut Duration) -> Result<(), Box<dyn std::error::Error>> {
    let mut hw = true;
    // GET HEADER BYTES
    let header_bytes = get_block_header(height)?;

    // GET GOLDEN HASH
    let mut cursor = Cursor::new(header_bytes);
    let header = Header::consensus_decode(&mut cursor)?;
    let start = Instant::now();
    let gold_hash = header.block_hash().to_raw_hash();
    let end = Instant::now();
    let duration = end - start;
    *gold_time = *gold_time + duration;

    if DEBUG {
        println!(" BLOCK  {}", height);
        print!("GOLDEN  {}", hex::encode(&gold_hash[..]));
        println!("        {:?}", duration);
    }

    for i in 0..4 {
        if i == 3 {
            hw = false;
        }
        if hw {
            print!(" HW[{}]  ", i);
        } else {
            print!(" SW     ");
        }

        // GET HARDWARE HASH
        let start: Instant;
        let end: Instant;
        let duration: Duration;
        let hash: Vec<u8>;

        if hw {
            start = Instant::now();
            hash = sha256_hw::get_hash(&sha256_hw::get_hash(&header_bytes, i), i);
            end = Instant::now();
            duration = end - start;
            *hw_time = *hw_time + duration;
        } else {
            start = Instant::now();
            hash = sha256_sw::get_hash(&sha256_sw::get_hash(&header_bytes));
            end = Instant::now();
            duration = end - start;
            *sw_time = *sw_time + duration;
        };

        if DEBUG {
            print!("{}  ", hex::encode(&hash));
        }

        //CHECK
        if gold_hash.as_byte_array() == hash.as_slice() {
            print!("PASS  ");
            println!("{:?}", duration);
        } else {
            println!("FAIL  ");
            println!("{:?}", duration);
        }
    }
    println!("");
    Ok(())
}

fn get_block_header(height: u32) -> Result<[u8; 80], Box<dyn std::error::Error>> {
    // Get the key of the block at @height
    let key = reqwest::blocking::get(
        "https://mempool.space/api/block-height/".to_owned() + &height.to_string(),
    )?
    .text()?;

    // Get its header, serialize to byte array
    let resp =
        reqwest::blocking::get("https://mempool.space/api/block/".to_owned() + &key + "/header")?
            .text()?;
    let mut header_bytes = [0u8; 80];
    hex::decode_to_slice(resp, &mut header_bytes)?;
    Ok(header_bytes)
}

fn get_tip_height() -> Result<u32, Box<dyn std::error::Error>> {
    Ok(
        reqwest::blocking::get("https://mempool.space/api/blocks/tip/height")?
            .text()?
            .parse()?,
    )
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let tip_height = get_tip_height()?;
    let mut rng = thread_rng();
    let range = 0..tip_height;
    let mut gold_time: Duration = Duration::ZERO;
    let mut hw_time: Duration = Duration::ZERO;
    let mut sw_time: Duration = Duration::ZERO;
    for _ in 0..TESTS {
        let height = rng.gen_range(range.clone());
        run_test(height, &mut gold_time, &mut hw_time, &mut sw_time)?;
    }

    let average_gold = gold_time / TESTS;
    let average_hw = hw_time / (TESTS * 3);
    let average_sw = sw_time / TESTS;
    println!("Average gold time: {:?}", average_gold);
    println!("Average hw time  : {:?}", average_hw);
    println!("Average sw time  : {:?}", average_sw);

    Ok(())
}
