#   Details: A program that generates file details of a specified directory

import os
import pathlib
import time


# object for file attributes
class FileAttributes:
    # define object attributes
    def __init__(self, file_name, file_path, file_size, file_inode, file_modification_time):
        self.file_name = file_name
        self.file_path = file_path
        self.file_size = file_size
        self.file_inode = file_inode
        self.file_modification_time = file_modification_time


def get_file_attributes(specified_path, files):
    file_list = []  # storing file list + attributes
    for file in files:
        if os.path.isfile(file):  # check if a file before continuing
            file_list.append(FileAttributes(file,  # file name
                                            f"{specified_path}/{file}",
                                            pathlib.Path(f"{specified_path}/{file}").stat().st_size,  # size of file
                                            os.stat(
                                                f"{specified_path}/{file}").st_ino,  # file inode
                                            time.ctime(os.path.getctime(f"{specified_path}/{file}"))))  # file mod time
    return file_list  # return the list


def print_file_data(file_list):  # simple print function
    for file in file_list:
        print("=" * len(file.file_path))
        print(f"File name: {file.file_name}\n"
              f"File path: {file.file_path}\n"
              f"File Size: {file.file_size}\n"
              f"File Inode: {file.file_inode}\n"
              f"Last Mod: {file.file_modification_time}")


# continued on next page
def main():
    specified_path = input("Please enter a file path: ")  # get file path entry
    os.chdir(specified_path)  # change directory, will automatically exit if dir doesn't exist
    files = os.listdir()  # load dir contents into files
    file_list = get_file_attributes(specified_path, files)  # pass to function to get file attributes
    print_file_data(file_list)  # pass to function to print results


# program starts here
if __name__ == "__main__":
    main()
