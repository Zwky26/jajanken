#! python3
# addbullets.py - From Ch.1 of the
#  Automate textbook. Gets whatever is in clipboard, adjusts it, and adds it back to clipboard

import pyperclip

text = pyperclip.paste()
lines = text.split('\n')
for i in range(len(lines)):
    lines[i] = '*' + lines[i]
text = '\n'.join(lines)
pyperclip.copy(text)