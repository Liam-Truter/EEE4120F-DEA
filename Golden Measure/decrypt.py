# Prompt the user to enter something
user_input = input("Enter they key: ")


# Create an empty list to store characters
char_array = []

# Iterate over each character in the user input and append it to the list
for char in user_input:
    char_array.append(char)

# Open the encrypted file in read mode
with open('OutPutFile_encypted.txt', 'r') as file:
   
    # Read the entire encrypted file content
    encrypted_content = file.read()

# Initialize an empty list to store decrypted characters
decrypted_characters = []

# Iterate over each character in the encrypted content
for i in range(0, len(encrypted_content), 8):
    # Extract 8 bits (1 byte) at a time
    binary_char = encrypted_content[i:i+8]
    
    # Initialize an empty string to store the decrypted character
    decrypted_char = ''
    
    # Iterate over each bit in the binary representation
    for j in range(8):
        # Convert the bit to an integer
        encrypted_bit = int(binary_char[j])
        
        # XOR the encrypted bit with the corresponding key bit (user input)
        decrypted_bit = encrypted_bit ^ int(char_array[j])
        
        # Convert the decrypted bit back to a string
        decrypted_char += str(decrypted_bit)
    
    # Convert the decrypted binary string to a character and append it to the list
    decrypted_characters.append(chr(int(decrypted_char, 2)))

# Join the decrypted characters into a string
decrypted_content = ''.join(decrypted_characters)

# Save the decrypted content to a file
with open('DecryptedFile.txt', 'w') as decrypted_file:
    decrypted_file.write(decrypted_content)

print("Decrypted content has been saved to DecryptedFile.txt")

