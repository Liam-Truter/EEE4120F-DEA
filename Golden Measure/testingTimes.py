import time
# Prompt the user to enter something
user_input = input("Enter something: ")
input_file_name = input("Enter the name of the input file: ")

import time

i = 0
while i < 5:
    # Create an empty list to store characters
    char_array = []

    # Iterate over each character in the user input and append it to the list
    for char in user_input:
        char_array.append(char)

    

    # Ask the user for the input file

    start_time = time.time()
    # Open the file in read mode
    with open(input_file_name + ".txt", 'r') as file:
        # Read the entire file content
        file_content = file.read()

    # Timer for golden measure

    # Initialize an empty list to store characters
    characters = []

    # Iterate over each character in the file content
    for char in file_content:
        temp = bin(ord(char))[2:]
        temp = temp.zfill(8)
        # Append the character to the list10
        characters.append(temp)

    p = 0
    result_str = ""
    for binary_char in characters:
        for bin in binary_char:
            # Convert strings to integers
            a_int = int(bin)
            b_int = int(char_array[p])
            p = p + 1

            # Perform XOR operation
            result_int = a_int ^ b_int

            # Convert result back to string
            result_str += str(result_int)

        p = 0

    # Write the result to the output file

    with open('OutPutFile_encypted.txt', 'w') as output_file:
        output_file.write(result_str)

    end_time = time.time()
    duration = end_time - start_time

    print(f" {duration:.4f} ")
    start_time = 0
    end_time = 0
    duration = 0

    # Reset variables
    char_array = []
    
    characters = []
    result_str = ""
    
    
    i += 1
