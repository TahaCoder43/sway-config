#!/usr/bin/env python

from tkinter import Tk, ttk, StringVar

root = Tk()
time_to_set_var = StringVar()
time_to_set = ""
timeInput = ttk.Entry(
    root,
    textvariable=time_to_set_var,
)


def on_enter(event):
    global time_to_set
    time_to_set = time_to_set_var.get()
    root.destroy()


timeInput.pack()
root.bind("<Enter>", on_enter)
# frm = ttk.Frame(root, padding=10)
# frm.grid()
# ttk.Label(frm, text="Hello World!").grid(column=0, row=0)
# ttk.Button(frm, text="Quit", command=root.destroy).grid(column=1, row=0)

root.mainloop()

print(time_to_set)
