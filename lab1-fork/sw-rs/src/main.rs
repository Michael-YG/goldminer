#![feature(test)]
mod sha256;

fn main() {
    //let input = "My name!";
    let input = ";klajsd;flkjasd;flkajsdfl;kasjdf;lkasjdf;lkasdjf;alskdfj;alsdkfja;sldkfja;lsdkfj;alsdkfja;sldkfjas;odfasd;ofjao;sdifjoadsijfaosd;ifjd;asoijfo;aisdjfo;aisdjf;aldsjfadl;kjfa;sdf";
    println!("{}", sha256::get_hash(input.as_bytes()));
}
