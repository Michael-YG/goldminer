#! /usr/bin/env python3
import re
import sys
from intelhex import IntelHex

def parse_hex_numbers(hex_block):
    hex_numbers = re.findall(r"32'h([0-9a-fA-F]+)", hex_block) #r before the string is used to denote a raw string, which treats backslashes as literal characters.
    print(hex_numbers)
    result = [int(h,16) for h in hex_numbers]
    print(result)
    return result
    # return [int(h, 16) for h in hex_numbers]

def create_intel_hex(hex_numbers, start_address=0, output_filename='output.hex'):
    ih = IntelHex()
    byte_address = start_address
    for number in hex_numbers:
        for i in range(4):
            ih[byte_address] = (number >> (8 * (3 - i))) & 0xFF
            byte_address += 1
    ih.write_hex_file(output_filename)

def binary_to_hex(binary_num):
    decimal_num = int(binary_num, 2)  # Convert binary to decimal
    hex_num = hex(decimal_num)[2:]  # Convert decimal to hexadecimal
    padded_hex_num = hex_num.zfill(8) 
    return padded_hex_num.lower()  # Convert to uppercase for consistency

# Example usage
# binary_number = input("Enter a 32-bit binary number: ")
# hex_number = binary_to_hex(binary_number)
# print("Hexadecimal number:", hex_number)




if __name__ == "__main__":
    hex_block0 = """
    32'h428a2f98,32'h71374491,32'hb5c0fbcf,32'he9b5dba5,32'h3956c25b,32'h59f111f1,32'h923f82a4,32'hab1c5ed5,
	32'hd807aa98,32'h12835b01,32'h243185be,32'h550c7dc3,32'h72be5d74,32'h80deb1fe,32'h9bdc06a7,32'hc19bf174,
	32'he49b69c1,32'hefbe4786,32'h0fc19dc6,32'h240ca1cc,32'h2de92c6f,32'h4a7484aa,32'h5cb0a9dc,32'h76f988da,
	32'h983e5152,32'ha831c66d,32'hb00327c8,32'hbf597fc7,32'hc6e00bf3,32'hd5a79147,32'h06ca6351,32'h14292967,
	32'h27b70a85,32'h2e1b2138,32'h4d2c6dfc,32'h53380d13,32'h650a7354,32'h766a0abb,32'h81c2c92e,32'h92722c85,
	32'ha2bfe8a1,32'ha81a664b,32'hc24b8b70,32'hc76c51a3,32'hd192e819,32'hd6990624,32'hf40e3585,32'h106aa070,
	32'h19a4c116,32'h1e376c08,32'h2748774c,32'h34b0bcb5,32'h391c0cb3,32'h4ed8aa4a,32'h5b9cca4f,32'h682e6ff3,
	32'h748f82ee,32'h78a5636f,32'h84c87814,32'h8cc70208,32'h90befffa,32'ha4506ceb,32'hbef9a3f7,32'hc67178f2
    """
    """Block header: 040000202c04d4c450187d1da9b1bc23ba47d67fe028d22486fd0c00000000000000000059a3a33d4642c799af9f54a4dd351fff9130e6a89d4e251130c60064878616e906b5ea60ce9813173a25caf3"""
    hex_block1 = """00000100000000000000000000100000,
    00101100000001001101010011000100,
    01010000000110000111110100011101,
    10101001101100011011110000100011,
    10111010010001111101011001111111,
    11100000001010001101001000100100,
    10000110111111010000110000000000,
    00000000000000000000000000000000,
    00000000000000000000000000000000,
    01011001101000111010001100111101,
    01000110010000101100011110011001,
    10101111100111110101010010100100,
    11011101001101010001111111111111,
    10010001001100001110011010101000,
    10011101010011100010010100010001,
    00110000110001100000000001100100"""
    hex_block2 = """10000111100001100001011011101001,
    00000110101101011110101001100000,
    11001110100110000001001100010111,
    00111010001001011100101011110011,
    10000000000000000000000000000000,
    00000000000000000000000000000000,
    00000000000000000000000000000000,
    00000000000000000000000000000000,
    00000000000000000000000000000000,
    00000000000000000000000000000000,
    00000000000000000000000000000000,
    00000000000000000000000000000000,
    00000000000000000000000000000000,
    00000000000000000000000000000000,
    00000000000000000000000000000000,
    00000000000000000000001010000000"""

    hex0_bin = hex_block1.split(',')
    hex0 = [('0x'+ binary_to_hex(i)) for i in hex0_bin]
    for h in hex0:
        print(h)
    print("-------------------")
    hex1_bin = hex_block2.split(',')
    hex1 = ['0x'+ binary_to_hex(i) for i in hex1_bin]
    for h in hex1:
        print(h)

    # hex_numbers = parse_hex_numbers(hex_block0)
    # create_intel_hex(hex_numbers, output_filename='output.hex')
    # # print("Intel HEX file 'output.hex' has been created.")
