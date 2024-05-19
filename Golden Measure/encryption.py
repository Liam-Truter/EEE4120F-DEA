import time

# Prompt the user to enter a number between 0 and 255
user_input_number = int(input("Enter a number between 0 and 255: "))

# Ensure the number is within the valid range
if not (0 <= user_input_number <= 255):
    raise ValueError("The number must be between 0 and 255")

# Convert the number to its binary representation and pad with leading zeros to make it 8 bits
binary_representation = bin(user_input_number)[2:].zfill(8)

# Prompt the user for the input file name
input_file_name = input("Enter the name of the input file (without extension): ")

# Measure the start time
start_time = time.time()

# Open the file in read mode and read the content
with open(input_file_name + ".txt", 'r', encoding='utf-8') as file:
    file_content = file.read()

# Function to perform a left bit shift with wrap-around
def left_shift_wrap(binary_str):
    return binary_str[1:] + binary_str[0]

# Initialize variables for the XOR operation result
result_str = ""

# Iterate over each character in the file content
for char in file_content:
    # Convert the character to its binary representation
    binary_char = bin(ord(char))[2:].zfill(8)
    
    # Initialize an empty string to store the XOR result for the current character
    xor_result = ""

    # Perform the XOR operation bit by bit
    for i, bit in enumerate(binary_char):
        a_int = int(bit)
        b_int = int(binary_representation[i])  # Use the binary representation of the user input

        # Perform XOR operation
        result_int = a_int ^ b_int

        # Append the XOR result bit to xor_result
        xor_result += str(result_int)

    # Convert the binary XOR result to a character and append to result_str
    result_str += chr(int(xor_result, 2))

    # Shift the key to the left by one bit with wrap-around after each character
    binary_representation = left_shift_wrap(binary_representation)

# Write the result to the output file with UTF-8 encoding
with open('OutPutFile_encrypted.txt', 'w', encoding='utf-8') as output_file:
    output_file.write(result_str)

# Measure the end time and calculate the duration
end_time = time.time()
duration = end_time - start_time

print(f"Time taken: {duration:.4f} seconds")
