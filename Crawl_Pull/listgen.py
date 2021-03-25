import string
import itertools


def new_string(gen_length):
    characters = string.ascii_lowercase + string.digits
    characters = list(characters)
    get_strings(characters, gen_length)


def get_strings(character_list, gen_length):
    link = "https://prnt.sc/"
    combos = ["".join(a) for a in itertools.combinations_with_replacement(character_list, gen_length)]

    with open("list.txt", "w") as file:
        for item in combos:
            file.write(f"{link}{item}\n")
