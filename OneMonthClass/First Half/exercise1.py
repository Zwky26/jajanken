# Making a random selection generator from a list. Straightforward stuff
import random

computer = ["Rock", "Paper", "Scissors"]

selected = random.choice(computer)

print(f"The computer threw: {selected}. Did you win (honor rule)? ")
