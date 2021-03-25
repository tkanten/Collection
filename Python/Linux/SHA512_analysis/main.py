# Details: A program that walks a specified directory to
# find file information, prints SHA512 sum, then creates a new directory and copies found files. Renames to {hash
# sum}.extension. New folder is created above the parent directory. If the new folder already exists, program stops.
# Requires prettytable, tree.


import os
from hashlib import sha512
from prettytable import PrettyTable
from shutil import copy


class DirectoryDetails:
    def __init__(self):
        self.file_location = []  # stores file details
        self.file_extensions = set({})  # stores file extensions for creating new folder

    def add_file(self, new_file_name, file_directory):
        """Create location of file, appends file name, file path, SHA256 hash and extension to file_location"""
        new_file_path = f"{file_directory}/{new_file_name}"  # path of file
        hash_value = self.create_file_hash(new_file_path)  # get hash of file
        file_extension = self.find_extensions(new_file_name)  # get file extension for sorting in new folder
        # \/ append all that wonderful data to file_location \/
        self.file_location.append([new_file_name, new_file_path, hash_value, file_extension])

    @staticmethod  # staticmethod behaves like a regular function outside of a class, I left it nested inside the
    # class as its return
    # value is related to the object
    def create_file_hash(new_file):
        """Creates the hash for the file"""
        hash_type = sha512()  # specify hash type

        chunk_size = 268435456  # prevent large files from being completely put into memory, reads in 250MB chunks max
        with open(new_file, "rb") as file:
            read = file.read(chunk_size)  # read specified chunk size
            while len(read) > 0:  # while data is still being read
                hash_type.update(read)  # update hash value
                read = file.read(chunk_size)  # read next chunk

        return hash_type.hexdigest()  # return for storing

    def find_extensions(self, file_name):
        """Finds the extension of the file"""
        find = file_name.rfind('.')  # find period in index of file name
        self.file_extensions.add(file_name[find + 1:])  # add to file extension set
        return file_name[find + 1:]  # returns file extension of file


def print_results(directory_location, directories):
    """Print a tree of the specified directory. Then print a table with information of all files in directory."""
    # change directory to specified location, use "tree" command
    os.chdir(directory_location)
    os.system("tree")
    # set up table for printing files that were found
    result_table = PrettyTable()

    # set up column names
    result_table.field_names = ["File Name", "File Location", "SHA512 Sum", "File Extension"]
    for file in directories.file_location:
        # add row
        result_table.add_row([file[0], file[1], file[2], file[3]])
    print(result_table)  # print that pretty table


def create_folder_by_file_extension(directory_location, directories):
    """Move to parent of folder to analyze, try to create directory "Files_By_Extension".
    If directory creation failed, exit program.
    If directory creation succeeded, create sub-dirs based on extensions found."""
    # create directory for files
    os.chdir("..")  # move up one dir (to keep original directory in tact)
    try:  # attempt to create directory
        os.mkdir("Files_By_Extension")
    except OSError:  # if creation failed, exit program
        print("ERROR: Directory creation failed")
        exit(-1)
    else:  # if creation succeeded, prompt directory was created
        os.chdir("Files_By_Extension")
        for extension in directories.file_extensions:
            os.mkdir(extension)  # create sub-dirs
        print("Directory creation succeeded!")


def copy_files_and_rename(directories):
    """Copies files in source directory to new directory. Sorts files based on extension.
    Renames file to its SHA512 hash sum."""
    new_folder_path = os.getcwd()  # store pwd of new folder to copy to

    for item in directories.file_location:  # loop through file data
        new_directory = f"{new_folder_path}/{item[3]}"  # Files_By_Extension/(extension)
        copy(item[1], new_directory)  # copy source (path to file) to new directory
        # rename copied file to its hash sum.extension
        os.rename(f"{new_directory}/{item[0]}", f"{new_directory}/{item[2]}.{item[3]}")


def main():
    """driver code for program"""

    directory_location = input("Parent directory path: ")  # should always be the path of the parent folder for analysis

    directories = DirectoryDetails()  # assign variable to object
    # use os.walk to index folder being analyzed
    for current in os.walk(directory_location):
        for file in current[2]:  # where current[2] is name of file found
            directories.add_file(file, current[0])  # pass file name and directory to function

    print_results(directory_location, directories)
    create_folder_by_file_extension(directory_location, directories)

    copy_files_and_rename(directories)


if __name__ == "__main__":
    main()
