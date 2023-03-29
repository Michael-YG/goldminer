#![feature(test)]
mod sha256;

fn main() {
    let input = "My name!";
    println!("{}", sha256::get_hash(input.as_bytes()));
}
