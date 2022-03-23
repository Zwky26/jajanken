#fizzbizz challenge
#print out 1 through 100, replace those divisible by 3 with fizz
#those divisible by 5 with buzz
#divisible by 15 with fizzbuzz

for num in range(1,100):
    if (num % 3 == 0):
        if (num % 5 == 0):
            print("fizzbuzz")
        else:
            print("fizz")
    else:
        if (num % 5 == 0):
            print("buzz")
        else:
            print(str(num))
