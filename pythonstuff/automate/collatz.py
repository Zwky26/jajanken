from curses.ascii import isalnum, isalpha
from numpy import intp

#exercise from automate textbook ch 3

def collatz(n):
    if n % 2 == 0:
        return n // 2
    else:
        return (3 * n) + 1
try:
    number = int(input("Enter number:"))
except:
    print("Input was not an int")
while number != 1:
    print(number)
    number = collatz(number)

print(number)
