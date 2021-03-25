# Details: finds all processes located in /proc, then creates an object list.
# The object list allows for all functionality found in m4p1, as well as drilling for 'cmdline' and 'children'
# as well as 'all' methods if the user requests.

import os
import subprocess


class LinuxProcList:
    """Class for preparing a list of processes found in proc, and initalizing various parsing methods found in LinuxProcess."""
    information_drill_list = ("stat", "status", "cmdline", "children", "all")  # defines possible drill terms

    def __init__(self):
        self.process_objects = {}  # dictionary of process objects ({PID:LinuxProcess(PID)})
        self.pid_drill_request = None  # holds value of current PID to drill down on
        self.information_drill_request = None  # holds the type of drill to perform

    def set_process_objects(self):
        """Sets process_objects by creating a dictionary of processes.
        Creates format {PID : object(LinuxProcess(pid)}"""
        for pid in os.listdir("/proc"):
            if os.path.isdir(os.path.join("/proc", pid)):
                if pid.isdigit():
                    self.process_objects.update({pid: LinuxProcess(pid)})

    def get_process_objects(self):
        """Prints a list of processes found in proc. Left justifies each column by 5 spaces,
        and prints 10 columns per row."""
        column_count = 0
        for item in self.process_objects.keys():
            column_count += 1
            print(f"{item:<5}", end='  ')
            if column_count == 10:
                print('\n')
                column_count = 0
        print("\n")

    def set_pid_drill_request(self, pid):
        """Sets the current PID for information drilling"""
        self.pid_drill_request = pid

    def set_information_drill_request(self, request):
        """Sets the current drilling type"""
        self.information_drill_request = request

    def get_request_from_process(self):
        """Initalizes the request the user made for a given PID. Determines which methods to use by checking the value
        of self.information_drill_request - which is originally aquired in drill_down_information_request().
        Compares the current PID for analysis (self.pid_drill_request) against the object dictionary (self.process_objects).
        When self.information_drill_request is matched to its drill type, control is passed to methods stored in LinuxProcess(object).
        """

        if self.information_drill_request == "children":
            # get PID of current request from dict, pass to LinuxProcess.get_process_children()
            self.process_objects.get(self.pid_drill_request).get_process_children()

        elif self.information_drill_request == "all":
            # performs every method, modifies self.information_drill_request
            # execute stat methods#
            self.information_drill_request = "stat"
            self.process_objects.get(self.pid_drill_request).set_raw_information(self.information_drill_request)
            # execute status methods#
            self.information_drill_request = "status"
            self.process_objects.get(self.pid_drill_request).set_raw_information(self.information_drill_request)
            # execute cmdline methods#
            self.information_drill_request = "cmdline"
            self.process_objects.get(self.pid_drill_request).set_raw_information(self.information_drill_request)
            # execute children methods
            self.process_objects.get(self.pid_drill_request).get_process_children()

        elif self.information_drill_request == "stat" or "status" or "cmdline":
            # stat, status, cmdline all initally use LinuxProcess.set_raw_information(request) to bring file data into
            # program. further parsing occurs in LinuxProcess.set_raw_information(request)
            self.process_objects.get(self.pid_drill_request).set_raw_information(self.information_drill_request)

        print("Printing completed")
        drill_down_information_request()  # go back to (optionally) modify request type for PID


class LinuxProcess(object):
    """The process object. Contains all methods for parsing requests."""

    def __init__(self, new_pid):
        self.process_pid = new_pid  # attribute holds the process PID
        self.process_location = f"/proc/{new_pid}"  # attribute holds the directory location of process
        self.raw_information = []  # stores raw information grabbed from analyzed file
        self.search_request_type = None  # holds the requested search type, used for stat/status methods

        self.requested_output = None  # attribute that stores current requested field

        # empty dictionary for selection. is modified in self.set_raw_information() based on which
        # drill method is being used.
        self.dict_selector = {}

    def set_raw_information(self, request):
        """Currently used by stat, status, and cmdline for opening a file and getting details.
        Method parses data with slight variances based on what drill type is set.
        Parameter request is the current drill type set in LinuxProcList."""

        self.search_request_type = request  # set request to attribute in current object

        # modify split spacing based on drill type
        if self.search_request_type == 'stat':
            spacing = ' '
        elif self.search_request_type == 'status':
            spacing = '\n'
        elif self.search_request_type == 'cmdline':
            spacing = None

        # open file, read into self.raw_information and split based on drill type
        with open(f"{self.process_location}/{request}", "r") as file:
            self.raw_information = file.read().split(spacing)

        # set up dictionaries for status and stat, parses data slightly different.
        if self.search_request_type == "status":
            self.set_status_dict()
        elif self.search_request_type == "stat":
            self.set_stat_dict()

        if self.search_request_type == "cmdline":
            # cmdline will join the split self.raw_information and
            # get command line information
            self.raw_information = "".join(self.raw_information)
            self.get_cmdline()
        elif self.search_request_type == "stat" or "status":
            self.display_dict_keys()  # prompt for if you want to see drillable values found
            self.create_search_term()  # initialize individual search for drillable values

    def set_status_dict(self):
        """Creates a dictionary of fields found in status"""
        # appends given item 'i' in raw information to dict_string_list.
        # 'i' is split by the tab in given item, will take the 0'th element (name of field)
        # then removes the semicolon at the end of the string ([:-1]).
        dict_string_list = [i.split("\t")[0][:-1] for i in self.raw_information]

        # creates a dictionary with the cleaned up strings as a key, and list offset as the value
        # will be used to dynamically print what values the user deems is important.
        self.dict_selector = {dict_string_list[i]: i for i in range(0, len(dict_string_list))}

    def set_stat_dict(self):
        """Creates a pre-made dictionary of fields that are listed in /proc/[pid]/stat"""
        self.dict_selector = {
            "pid": 0,
            "comm": 1,
            "state": 2,
            "ppid": 3,
            "pgrp": 4,
            "session": 5,
            "tty_nr": 6,
            "tpgid": 7,
            "flags": 8,
            "minflt": 9,
            "cminflt": 10,
            "majflt": 11,
            "cmajflt": 12,
            "utime": 13,
            "stime": 14,
            "cuttime": 15,
            "cstime": 16,
            "priority": 17,
            "nice": 18,
            "num_threads": 19,
            "itrealvalue": 20,
            "starttime": 21,
            "vsize": 22,
            "rss": 23,
            "rsslim": 24,
            "startcode": 25,
            "endcode": 26,
            "startstack": 27,
            "kstkesp": 28,
            "kstkeip": 29,
            "signal": 30,
            "blocked": 31,
            "sigignore": 32,
            "sigcatch": 33,
            "wchan": 34,
            "nswap": 35,
            "cnswap": 36,
            "exit_signal": 37,
            "processor": 38,
            "rt_priority": 39,
            "policy": 40,
            "delayacct_blkio_ticks": 41,
            "guest_time": 42,
            "cguest_time": 43,
            "start_data": 44,
            "end_data": 45,
            "start_brk": 46,
            "arg_start": 47,
            "arg_end": 48,
            "env_start": 49,
            "env_end": 50,
            "exit_code": 51,
        }

    def display_dict_keys(self):
        """If the user wants to see the possible fields to parse from a given method, program will output
            the possible keys."""
        print("=" * 100)
        print(
            f"Please ensure you are searching for fields by the keyword highlighted in 'man proc > /{self.search_request_type}")
        show_keys = input("Would you like to display the possible fields to enter? (Y/N):\n> ")
        if show_keys.upper() == 'Y':
            print("-" * 100)
            print(f"POSSIBLE ENTRY FIELDS FOR {self.process_location.upper()}/{self.search_request_type.upper()}:")
            print("-" * 100)
            for key in self.dict_selector.keys():
                print(key)
            print("-" * 100)

    def create_search_term(self):
        """Gets search terms from user (in a loop). Compares terms to dictionary keys, continues until 'S' is
        entered. """
        while 1:
            search_term = input(f"\nEnter specific drill selection of {self.search_request_type}, 'S' to stop:\n> ")
            if search_term.upper() == 'S':
                break

            if search_term in self.dict_selector.keys():
                # if search term was found in possible selections, pass to self.get_requested_output
                self.get_requested_output(search_term)
            else:
                print("Invalid entry! Try again")

        # prompt for if the user would like to see the full output what was found in a drilled proc file
        print("\n" + ("=" * 100))
        print_dump = input(
            f"Would you like to print the full dump of {self.process_location}/{self.search_request_type}? (Y/N):\n> ")
        if print_dump.upper() == 'Y':
            self.get_full_raw_information_dump()

    def get_requested_output(self, search_term):
        """Prints requested_output of the requested search by the user"""
        self.set_requested_output(search_term)
        print(f"[REQUESTED {search_term.upper()}]:")
        print(self.requested_output)

    def set_requested_output(self, search_term):
        """Sets requested_output from the requested search by the user"""
        self.requested_output = self.raw_information[self.dict_selector.get(search_term)]

    def get_full_raw_information_dump(self):
        """Prints a full dump of a drilled proc/[PID]/[file]."""

        print("-" * 100)
        print(f"PRINTING FULL DUMP OF {self.process_location.upper()}/{self.search_request_type.upper()}:")
        print("-" * 100)
        for key in self.dict_selector:
            # stat and status have slighty different output modes, as the stat file does not have information for what
            # value is what.
            if self.search_request_type == "stat":
                # print the key, as well as value
                print(f"{key}: {self.raw_information[self.dict_selector[key]]}")
            elif self.search_request_type == "status":
                # only print the value
                print(self.raw_information[self.dict_selector[key]])
        print("=" * 100)

    def get_cmdline(self):
        """Gets the proc/[PID]/cmdline file. If the file is empty, it will notify the user of the empty state.
        If not, it will dump the information found."""
        print("=" * 100)
        if self.raw_information == "":
            # if empty, notify user
            print(f"{self.process_location.upper()}/{self.search_request_type.upper()} IS EMPTY")
        else:
            # if not empty, dump the file data
            print(f"DUMP FOR {self.process_location.upper()}/{self.search_request_type.upper()}:")
            print("-" * 100)
            print(self.raw_information)
        print("=" * 100)

    def get_process_children(self):
        """Gets the children found for the specified PID.
        Uses subprocess.Popen to execute a shell command.
        If there are no children for the PID, program will notify user."""

        command = ["ps", "--ppid", self.process_pid, "-o", "pid,cmd"]
        output = subprocess.Popen(command, stdout=subprocess.PIPE).communicate()[0]
        output = bytes.decode(output, 'utf-8')
        print("=" * 100)

        if len(output.split()) > 2:
            # if there are child processes
            print("-" * 100)
            print(f"CHILDREN FOR {self.process_location}:")
            print("-" * 100)
            print(output)
        else:
            # if there are no child processes
            print(f"{self.process_location.upper()} HAS NO CHILDREN.")

        print("="*100)

def show_process_objects():
    """Prompts user for if they would like a list of processes found.
    Requires proper input of 'y/Y' or 'n/N'. Recursively calls itself with improper input."""
    show_list = input("Display the list of processes found? Y/N:\n> ")

    if show_list.upper() == 'Y':
        process_list.get_process_objects()
    elif show_list.upper() == 'N':
        return
    else:
        print("Incorrect entry, try again.")
        show_process_objects()


def drill_down_PID():
    """Base of process drilling loop. Gets PID from user. Will recursively retry if a number is not entered.
    If entry is 'Q' is entered, it will quit.
    Modifies LinuxProcList.drill_down_information_request with inputted PID."""

    pid = input("Please enter an existing PID you want to drill down on, enter 'Q' to quit\n>")
    if pid.upper() == 'Q':
        print("Exiting..")
        return

    elif pid.isdigit() and pid in process_list.process_objects.keys():
        process_list.set_pid_drill_request(pid)  # set pid_drill_request
        drill_down_information_request()  # pass to drill_down_information to get drill type

    else:
        print("Incorrect entry, try again.\n")
        drill_down_PID()


def drill_down_information_request():
    """Originates from drill_down_PID(). Is recursively called by LinuxProcList.get_request_from_process().
    Displays the possible information drilling types, gets an input on requested type, and passes control into
    LinuxProcList.get_request_from_process().
    Quits by a user entering 'B' - which will return to drill_down_PID().
    When the user inputs an incorrect string, it will recursively call itself until a real drill request is given,
    or 'B' is entered."""

    print(f"\nThe current information available for drilling is {LinuxProcList.information_drill_list}")
    print("Please enter one type at a time, or 'B' to go back and select a different PID")
    drill_request = input(">")

    if drill_request.lower() in LinuxProcList.information_drill_list:
        process_list.information_drill_request = drill_request.lower()

        # toast message for processing request
        print(
            f"Processing request {process_list.information_drill_request.upper()} on PID /proc/{process_list.pid_drill_request}\n")

        process_list.get_request_from_process()  # pass to class to get request

    elif drill_request.upper() == 'B':  # go back to select different PID
        drill_down_PID()
    else:
        print("Incorrect entry, try again.\n")
        drill_down_information_request()  # recursive re-call


# instantiating on global scope to make access in recursive functions easier
process_list = LinuxProcList()


def main():
    """Driver code"""
    # Set list of processes, create dict object structure of processes
    process_list.set_process_objects()

    # Optionally display list of found processes
    show_process_objects()

    # Start drilling down what PID info to display. Recursive until user specifies quit
    drill_down_PID()


if __name__ == "__main__":
    main()
