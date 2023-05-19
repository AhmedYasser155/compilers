import tkinter as tk
import os

def compile_code():
    # Get the input from the input field
    input_code = input_text.get("1.0", tk.END)

    # save the code in a file 
    with open("phase2.txt", "w") as file:
        file.write(input_code)


    os.system("bash a.sh")

    # read the output quadruples from the output_quadruples.txt file
    # and put it in the output_quadruples field
    with open("finalQuads.txt", "r") as file:
        output_quadruples = file.read()
        #clear the output_quadruples field
        output_quadruples_text.delete("1.0", tk.END)
        #insert the output_quadruples in the output_quadruples field
        output_quadruples_text.insert(tk.END, output_quadruples)

    # read the symbol table from the symbol_table.txt file
    # and put it in the symbol_table field  
    with open("parseTable.txt", "r") as file:
        symbol_table = file.read()
        #clear the symbol_table field
        symbol_table_text.delete("1.0", tk.END)
        symbol_table_text.insert(tk.END, symbol_table)



# function that adds line numbers to the input_text field
def add_line_numbers():
    # get the number of lines in the input_text field
    line_numbers = input_text.index('end-1c').split('.')[0]
    # create a string with the line numbers
    line_numbers_string = '\n'.join(str(i) for i in range(1, int(line_numbers)))
    # insert the line numbers in the input_line_numbers field
    input_line_numbers.configure(text=line_numbers_string)
    #start at the top of the input_line_numbers field
    # call this function again after 100ms
    input_line_numbers.after(100, add_line_numbers)





# Create the main window
window = tk.Tk()
window.title("Code Analyzer")
window.attributes('-fullscreen', False)


# Set the background color
window.configure(bg="#f0f0f0")

# Create a grid of 4 input fields and one button (compile). it should be on 2 columns and 3 rows and the button should span 2 columns
#  make the input fields and button fill the entire width of the window
#  make the input fields and button fill the entire height of the window
window.columnconfigure(0, weight=1)
window.columnconfigure(1, weight=1)
window.rowconfigure(0, weight=1)
window.rowconfigure(1, weight=1)
window.rowconfigure(2, weight=1)

# Create the input field
 #this frame should have a label and a text field and line numbers on the left side
input_frame = tk.Frame(master=window, relief=tk.RAISED, borderwidth=1)
input_frame.grid(row=0, column=0, sticky="nsew")


input_frame.columnconfigure(0, weight=1)
input_frame.columnconfigure(1, weight=1)
input_frame.rowconfigure(0, weight=1)
input_frame.rowconfigure(1, weight=1)

input_label = tk.Label(master=input_frame, text="Input")
input_label.grid(row=0, column=0, sticky="nsew")
input_text = tk.Text(master=input_frame)
input_text.grid(row=1, column=1, sticky="nsew")

#input_line_numbers is not editable and it uses add_line_numbers function to add line numbers
input_line_numbers = tk.Label(master=input_frame, width=5)
input_line_numbers.grid(row=1, column=0, sticky="nsew")
input_line_numbers.after(100, add_line_numbers)

#make the text field and line numbers fill the entire height of the window
input_text.grid(row=1, column=1, sticky="nsew")
input_line_numbers.grid(row=1, column=0, sticky="nsew")
#center the text in the input_line_numbers field to the top
input_line_numbers.configure(anchor="n")
#call the add_line_numbers function after 100ms

input_line_numbers.after(100, add_line_numbers)



# Create the output quadruples field
    #this frame should have a label and a text field

output_quadruples_frame = tk.Frame(master=window, relief=tk.RAISED, borderwidth=1)
output_quadruples_frame.grid(row=0, column=1, sticky="nsew")
output_quadruples_frame.columnconfigure(0, weight=1)
output_quadruples_frame.rowconfigure(0, weight=1)
output_quadruples_frame.rowconfigure(1, weight=1)

output_quadruples_label = tk.Label(master=output_quadruples_frame, text="Output Quadruples")
output_quadruples_label.grid(row=0, column=0, sticky="nsew")

output_quadruples_text = tk.Text(master=output_quadruples_frame)
output_quadruples_text.grid(row=1, column=0, sticky="nsew")

# Create the symbol table field

symbol_table_frame = tk.Frame(master=window, relief=tk.RAISED, borderwidth=1)
symbol_table_frame.grid(row=1, column=0, sticky="nsew")
symbol_table_frame.columnconfigure(0, weight=1)
symbol_table_frame.rowconfigure(0, weight=1)

symbol_table_label = tk.Label(master=symbol_table_frame, text="Symbol Table")
symbol_table_label.grid(row=0, column=0, sticky="nsew")

symbol_table_text = tk.Text(master=symbol_table_frame)
symbol_table_text.grid(row=1, column=0, sticky="nsew")

# Create the error field

error_frame = tk.Frame(master=window, relief=tk.RAISED, borderwidth=1)
error_frame.grid(row=1, column=1, sticky="nsew")
error_frame.columnconfigure(0, weight=1)
error_frame.rowconfigure(0, weight=1)

error_label = tk.Label(master=error_frame, text="Errors")
error_label.grid(row=0, column=0, sticky="nsew")

error_text = tk.Text(master=error_frame)
error_text.grid(row=1, column=0, sticky="nsew")

# Create the compile button, make it colored and make it span 2 columns
compile_button = tk.Button(master=window, text="Compile", command=compile_code, bg="#00ff00", fg="#000000", width=20)
#center the button

compile_button.grid(row=2, column=0, columnspan=2, sticky="nsew", padx=500, pady=10)














# Start the GUI event loop
window.mainloop()