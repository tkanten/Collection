
#   Details: A program that parses out an ELF header file

import os


# my (simple) class
class fileAttributes:
    def __init__(self, username, date, contact_information, file_path, file_name, file_format, magic_number, endian,
                 machine, entry_point):
        self.file_path = file_path
        self.file_name = file_name
        self.file_format = file_format
        self.contact_information = contact_information
        self.username = username
        self.date = date
        self.magic_number = magic_number
        self.endian = endian
        self.machine = machine
        self.entry_point = entry_point


# storing and formatting inputted file information into object fileAttributes
def get_file_details(file):
    file.username = input("Please enter your name/username: ")
    file.contact_information = input("Please enter your contact information: ")
    file.file_path = input("Please enter the file path (including the file) to read: ")

    # parse name of file from directory
    file_find = file.file_path.rfind('/')
    file.file_name = file.file_path[(file_find + 1):]
    # store in file object
    file.file_path = file.file_path.strip(f"{file.file_name}")


# change dir to path, grabs ELF info, outputs to file, reads file and brings
# into memory, deletes file
def get_elf_info(file):
    # change directory
    os.chdir(file.file_path)
    # yes I agree, this is ugly. uses linux commands
    # to grab information for the specified file.
    # echo date, pipe to a temporary file (output.txt)
    # get ELF information, parse by fields required, pipe to same file

    command = f"echo 'Date:' `date --u` > output.txt |" \
              f" readelf {file.file_name} -h |" \
              f" grep 'Magic\|Data\|Class\|Machine\|Entry'>> output.txt"
    os.system(command)  # execute command

    # open file, grab data into variable 'data', close file, remove output.txt
    with open("output.txt", "r") as myfile:
        data = myfile.readlines()
    myfile.close()
    os.system("rm output.txt")

    # clean up the information extracted from output.txt
    data = clean_elf_info(data)

    # return data to main
    return data


# cleans up the list, allows for easier manipulation of data
def clean_elf_info(data):
    clean_data = []  # create empty list
    for field in data:  # strip large whitespaces, split each section into a list
        clean_data.append(field.strip().split())

    # return the (better looking) data
    return clean_data


def sort_elf_attributes(data, file):
    # sort through data to pull out required information
    for sublist in data:
        for details in sublist:
            if details.__contains__('Date'):
                # pass to join_list function, leaves out first list item
                file.date = join_list(sublist[1:])

            elif details.__contains__('Class'):
                # grab class info, strip ELF, add 'bit'
                file.file_format = sublist[1].strip('ELF') + ' bit'

            elif details.__contains__('Magic'):
                # pass all but first line item to little_bit_endian() to manipulate
                file.magic_number = little_to_big_endian(sublist[1:])

            elif details.__contains__('Data'):
                # if data is big/little endian, store respective string into obj file
                if sublist.__contains__('big'):
                    file.endian = sublist[sublist.index('big')]
                else:
                    file.endian = sublist[sublist.index('little')]

            elif details.__contains__('Machine'):
                # join machine name together, store in file
                file.machine = join_list(sublist[1:])

            elif details.__contains__('0x'):
                # find entry point via '0x', store in file
                file.entry_point = details
    del data  # remove 'data' list once operation complete


# simply creates a single string out of a list
def join_list(function_input):
    output = " "
    return output.join(function_input)


# I think my conversion logic is incorrect for this section..
def little_to_big_endian(function_input):
    function_input.reverse()  # reverse list
    output = []  # create empty list
    for item in function_input:  # remove 00's
        if item != '00':
            output.append(item)

    output = join_list(output)  # join list together as a string
    return f"0x{output.replace(' ', '')}"  # return with no whitespace + '0x'


# Print the final results
def print_elf_attributes(file):
    print(f"{'Report generated by':<20}: {file.username}")
    print(f"{'Contact':<20}: {file.contact_information}")
    print(f"{'Date/Time':<20}: {file.date}")
    print(f"\t{'File':<18}: {file.file_name}")
    print(f"\t{'Magic':<18}: {file.magic_number}")
    print(f"\t{'Format':<18}: {file.file_format}")
    print(f"\t{'Endian':<18}: {file.endian}")
    print(f"\t{'Machine':<18}: {file.machine}")
    print(f"\t{'Entry Point':<18}: {file.entry_point}")


def main():
    # creating file object for storing formatted data
    file = fileAttributes(None, None, None, None, None, None, None, None, None, None)

    # grab input for file location, username, contact info
    get_file_details(file)
    # grab ELF header file information
    data = get_elf_info(file)
    # sort attributes discovered into 'file'
    sort_elf_attributes(data, file)
    # print final results
    print_elf_attributes(file)


if __name__ == "__main__":
    main()

