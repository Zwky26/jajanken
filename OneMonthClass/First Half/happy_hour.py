import random

bars = ["Shoolbred's",
        "The Wren",
        "The Scratcher",
        "ACME",
        "Blind Barber"]

people = ["Mattan",
          "Chris",
          "that person you forgot to text back",
          "Kanye West",
          "Samuel L. Jackson",
          "the boys"]

random_bar = random.choice(bars)
random_person = random.sample(people, k=2)

print(f"How about you go to {random_bar} with {random_person[0]} and {random_person[1]}?")
