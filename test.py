import tkinter as tk
import os
import subprocess


global lineNumber   #global variable to keep track of the line number
global currentLine 
global queue 
global errorAdded
global numErrors

def start():
    global currentLine
    currentLine=0
    global lineNumber
    lineNumber=0
    global queue
    queue = []
    global errorAdded
    errorAdded = False
    global numErrors
    numErrors = 0
    print("start")

start()

def readFiles():
    #read Quadruples from file
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

    # read the errors from the errors.txt file
    # and put it in the errors field
    with open("errors.txt", "r") as file:
        errors = file.read()
        #clear the errors field
        oldErrors = error_text.get("1.0", tk.END)
        error_text.delete("1.0", tk.END)
        error_text.insert(tk.END, errors)
        #check if an error was added and if so, increment the number of errors
        global errorAdded 
        global numErrors
        errorAdded = False

        if oldErrors != errors and errors != "":
            numErrors+=1
            errorAdded = True

    print("read files")
    #highlight the current line
    input_label.config(text="Line: "+str(currentLine))
    input_text.tag_add("highlight", str(currentLine)+".0", str(currentLine)+".end")
    input_text.tag_config("highlight", background="yellow", foreground="black")
    # remove the highlight from the currentLine-1
    if currentLine > 1:
        input_text.tag_remove("highlight", str(currentLine-1)+".0", str(currentLine-1)+".end")
    # scroll to the current line
    input_text.see(str(currentLine)+".0")



def compileAll():
    # like compileNext but for queue[lineNumber]
    
    os.system("./a.sh")
    global lineNumber
    global queue
    #loop through the queue and compile each line
    #read the files after each line and if there is an error, underline the line and continue
   
    for i in range(len(queue)):
        scanner_process=subprocess.Popen(["./scanner"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
        scanner_process.stdin.write(queue[i].encode())
        error = scanner_process.communicate()[1].decode()
        if error != "":
            #underline the line
            input_text.tag_add("underline", str(i+1)+".0", str(i+1)+".end")
            input_text.tag_config("underline", underline=True)
            #scroll to the line
            input_text.see(str(i+1)+".0")

    scanner_process.stdin.close()
    scanner_process.wait()
    readFiles()

    



def reset():
    global currentLine
 
    #remove the highlight from the currentLine
    input_text.tag_remove("highlight", str(currentLine)+".0", str(currentLine)+".end")
    currentLine=0

def compileNext():
    on_enter("<Return>")
    os.system("./a.sh")
    scanner_process=subprocess.Popen(["./scanner"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
    global currentLine
    global queue

    if currentLine < len(queue):
        scanner_process.stdin.write(queue[currentLine].encode())
        scanner_process.stdin.flush()
        currentLine+=1
        print("compile next")
    scanner_process.stdin.close()
    scanner_process.wait()
    readFiles()
    



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


def on_enter(event):
    global lineNumber
    global queue
    lineNumber+=1
    command = input_text.get("1.0", tk.END)
    queue.append(command)




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

#input code
input_label = tk.Label(master=input_frame, text="Input")
input_label.grid(row=0, column=0, sticky="nsew")
input_text = tk.Text(master=input_frame)
input_text.grid(row=1, column=1, sticky="nsew")
input_text.bind("<Return>", on_enter)


#line numbers
input_line_numbers = tk.Label(master=input_frame, width=5)
input_line_numbers.grid(row=1, column=0, sticky="nsew")
input_text.grid(row=1, column=1, sticky="nsew")
input_line_numbers.configure(anchor="n")
input_line_numbers.after(100, add_line_numbers)


#Quadruples
output_quadruples_frame = tk.Frame(master=window, relief=tk.RAISED, borderwidth=1)
output_quadruples_frame.grid(row=0, column=1, sticky="nsew")
output_quadruples_frame.columnconfigure(0, weight=1)
output_quadruples_frame.rowconfigure(0, weight=1)
output_quadruples_frame.rowconfigure(1, weight=1)

output_quadruples_label = tk.Label(master=output_quadruples_frame, text="Output Quadruples")
output_quadruples_label.grid(row=0, column=0, sticky="nsew")

output_quadruples_text = tk.Text(master=output_quadruples_frame)
output_quadruples_text.grid(row=1, column=0, sticky="nsew")

#Symbol Table
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

# Create the buttons frame (compile, previous step, next step)

buttons_frame = tk.Frame(master=window, relief=tk.RAISED, borderwidth=1)
buttons_frame.grid(row=2, column=0, columnspan=2, sticky="nsew")
buttons_frame.columnconfigure(0, weight=1)
buttons_frame.columnconfigure(1, weight=1)
buttons_frame.columnconfigure(2, weight=1)
buttons_frame.rowconfigure(0, weight=1)

compile_button = tk.Button(master=buttons_frame, text="Compile", command=compileAll)
compile_button.grid(row=0, column=0, sticky="nsew")

reset_button = tk.Button(master=buttons_frame, text="Reset", command=reset)
reset_button.grid(row=0, column=1, sticky="nsew")


next_step_button = tk.Button(master=buttons_frame, text="Next Step", command=compileNext)
next_step_button.grid(row=0, column=2, sticky="nsew")



# Start the GUI event loop
window.mainloop()
