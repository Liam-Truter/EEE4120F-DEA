def write_variable_multiple_times(variable, times, file):
    for _ in range(times):
        file.write(variable )

# Example usage:
variable = "abcde123 4"
times = 100000


# Open a text file for writing
with open("1000000.txt", "w") as file:
    write_variable_multiple_times(variable, times, file)
