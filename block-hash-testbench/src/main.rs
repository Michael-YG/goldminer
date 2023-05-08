use bitcoin::blockdata::block::Header;
use bitcoin::consensus::Decodable;
use bitcoin::hashes::Hash;
use rand::{thread_rng, Rng};
use std::io::Cursor;

mod acc;
mod sha256_hw;

const DEBUG: bool = true;

fn run_test(height: u32) -> Result<(), Box<dyn std::error::Error>> {
    // GET HEADER BYTES
    let header_bytes = get_block_header(height)?;

    // GET GOLDEN HASH
    let mut cursor = Cursor::new(header_bytes);
    let header = Header::consensus_decode(&mut cursor)?;
    let gold_hash = header.block_hash().to_raw_hash();

    if DEBUG {
        println!(" BLOCK  {}", height);
        println!("GOLDEN  {}", hex::encode(&gold_hash[..]));
    }

    for i in 0..3 {
        print!(" HW[{}]  ", i);
        // GET HARDWARE HASH
        let hw_hash = sha256_hw::get_hash(&header_bytes, i);
        let hw_hash = sha256_hw::get_hash(&hw_hash, i);

        if DEBUG {
            print!("{}  ", hex::encode(&hw_hash));
        }

        //CHECK
        if gold_hash.as_byte_array() == hw_hash.as_slice() {
            println!("PASS");
        } else {
            println!("FAIL");
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
    for _ in 0..5 {
        let height = rng.gen_range(range.clone());
        run_test(height)?;
    }
    Ok(())
}
