import string
import itertools

"""First attempt at creating a bruteforce list. Doesn't cover all ends for permutations with replacement, and file sizes can get massive quickly.
Isn't too bad for sucking up too many resources, as it caps lists held in memory at 100,000,000 strings."""


def new_string():
    total_processed = 0

    gen_length = int(input("Starting position of generating? "))
    gen_length_upper = int(input("Ending position of generating?"))
    write_max = int(input("Maximum size to write to file (100,000,000 = about 6GB of RAM): "))

    while gen_length <= gen_length_upper:

        print(f"{'=' * 50}\nGenerating new character table")
        characters = []
        for i in range(33, 127):
            characters.append(chr(i))
        total_processed = get_strings(characters, gen_length, total_processed, write_max)
        gen_length += 1

    print(f"{'=' * 50}\nGenerating Complete!\nTotal size of file: {total_processed}")


def get_strings(character_list, gen_length, total_processed, write_max):
    combos = []
    list_count = 0
    file_specific_total = 0

    print(f"Starting generation for {gen_length} character cartesian product...\n")
    for a in itertools.product(character_list, repeat=gen_length):
        list_count += 1

        if list_count > write_max:  # modify to increase amount stored in memory before commiting file write
            total_processed += len(combos)
            file_specific_total += len(combos)
            print(f"Max stack of {write_max} strings hit! Writing to file..")
            print(f"Currently generated: {file_specific_total}\n")

            combos = file_write(combos)
            list_count = 0
        else:
            combos.append("".join(a))

    total_processed += len(combos)
    file_specific_total += len(combos)
    file_write(combos)
    print(f"File generated\nGeneration Size: {file_specific_total}/{total_processed}\n")
    return total_processed


def file_write(combos):
    with open("list.txt", "a") as file:
        for item in combos:
            file.write(f"{item}\n")
    file.close()
    combos = []
    return combos


if __name__ == "__main__":
    new_string()
