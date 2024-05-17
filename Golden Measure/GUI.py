import tkinter as tk
from tkinter import filedialog
from tkinter import messagebox
from encryption import encrypt_file

def browse_file():
    file_path = filedialog.askopenfilename()
    if file_path:
        entry_file.delete(0, tk.END)
        entry_file.insert(tk.END, file_path)

def encrypt():
    key = entry_key.get()
    file_path = entry_file.get()
    if not key:
        messagebox.showerror("Error", "Please enter the encryption key.")
        return
    if not file_path:
        messagebox.showerror("Error", "Please select an input file.")
        return
    try:
        encrypt_file(key, file_path)
        messagebox.showinfo("Success", "Encryption successful.")
    except Exception as e:
        messagebox.showerror("Error", f"Encryption failed: {str(e)}")

# Create the main window
root = tk.Tk()
root.title("Encryption Program")

# Create labels
label_key = tk.Label(root, text="Encryption Key:")
label_key.grid(row=0, column=0, padx=5, pady=5, sticky=tk.W)

label_file = tk.Label(root, text="Input File:")
label_file.grid(row=1, column=0, padx=5, pady=5, sticky=tk.W)

# Create entry boxes
entry_key = tk.Entry(root)
entry_key.grid(row=0, column=1, padx=5, pady=5)

entry_file = tk.Entry(root)
entry_file.grid(row=1, column=1, padx=5, pady=5)

# Create browse button
button_browse = tk.Button(root, text="Browse", command=browse_file)
button_browse.grid(row=1, column=2, padx=5, pady=5)

# Create encrypt button
button_encrypt = tk.Button(root, text="Encrypt", command=encrypt)
button_encrypt.grid(row=2, column=0, columnspan=2, padx=5, pady=5)

root.mainloop()
