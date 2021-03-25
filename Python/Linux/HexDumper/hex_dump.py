#   Details: A program that prints a hex dump of a given file, then prints the byte length
#   Super basic. Requires that hexdump is installed on your Linux machine.
import os  # shell commands
import sys  # using C like argv parameters
import subprocess  # could have gone without, wanted to test other ways to use shell commands


def main():
    subprocess.run(["hexdump", "-C", f"{argv}"])  # prints the hexdump

    os.system(f"echo 'Total Length' `wc -c < {argv}`")  # prints the file length in bytes


if __name__ == "__main__":
    argv = sys.argv[1]  # grabs command line input
    main()
