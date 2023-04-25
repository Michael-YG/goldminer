use rand::{thread_rng, Rng};

mod acc;
mod sha256_hw;
mod sha256_sw;

const DEBUG: bool = false;

fn run_test(height: u32) -> Result<(), Box<dyn std::error::Error>> {
    // SETUP
    print!("{:>6}... ", height);
    // Get the hash of the block at @height
    let gold = reqwest::blocking::get(
        "https://mempool.space/api/block-height/".to_owned() + &height.to_string(),
    )?
    .text()?;
    if DEBUG {
        println!("{}", gold);
    }
    // Get its header, serialize to byte array
    let resp =
        reqwest::blocking::get("https://mempool.space/api/block/".to_owned() + &gold + "/header")?
            .text()?;
    let mut header_bytes = [0u8; 80];
    hex::decode_to_slice(resp, &mut header_bytes as &mut [u8]).unwrap();

    // TEST
    //let hash_1 = sha256_sw::get_hash(&header_bytes);
    let hash_1 = sha256_hw::get_hash(&header_bytes);
    //let mut hash_2 = sha256_sw::get_hash(&hash_1);
    let mut hash_2 = sha256_hw::get_hash(&hash_1);
    // Bitcoin is little endian
    hash_2.reverse();

    //CLEANUP
    if DEBUG {
        println!("{}", hex::encode(&hash_2));
    }
    if gold == hex::encode(hash_2) {
        println!("PASS");
    } else {
        println!("FAIL");
    }
    Ok(())
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
