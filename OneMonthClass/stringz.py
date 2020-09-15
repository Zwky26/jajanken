#some quick examples for strings in Python3

#escapes
print("Escape characters \n")

string1 = "Robin Sparkle\'s big hit, \"Let\'s Go to the Mall\"\n"

print(string1)

#multi lines

print("Multi-line \n")

string_para = """This is a haiku
A pretty bad one I'd say
It's snowing on Mt\n"""

print(string_para)

#formatting, inputting

print("Formatting Strings \n")

name = "J Jonah Jameson"

print(f"\"I want those pictures on my desk this instance\", says {name}.\n")

print("Truncating decimals \n")

print(f"25.01234 goes to {25.01234:.2f}")
