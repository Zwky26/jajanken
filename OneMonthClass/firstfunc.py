#practice problem. Given string, return string that is
#reveresed and upper case

def upper_and_reverse(input):
    result = ""
    for letter in input:
        result = letter.upper() + result
    return result

print(upper_and_reverse("banana")) #expected return ANANAB

#OR can slice backwards

def upper_and_reverse_better(input):
    return input[::-1].upper()

print(upper_and_reverse_better("banana"))
