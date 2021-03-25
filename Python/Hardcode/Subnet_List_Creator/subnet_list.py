#Generates a list of IP's to scan. School project.

# holds the maximum bounds of the network specifications
class NetworkParameters:
    lower_bound_address = 127  # address below network address
    upper_bound_address = 255  # highest possible address (broadcast)
    valid_addresses = upper_bound_address - lower_bound_address  # number of valid addresses
    usable_addresses = valid_addresses - 2  # number of usable addreses


# class that holds the more intricate specifications of the network
class NetworkDetails:
    network = '10.110.16.'  # string value of network portion of address
    cidr_prefix = '/25'  # not (currently) in use, but can be used to re-format output
    network_address = NetworkParameters.lower_bound_address + 1  # network address
    broadcast_address = NetworkParameters.upper_bound_address  # broadcast address
    first_host = network_address + 1  # first usable host
    last_host = broadcast_address - 1  # last usable host

    # defining the list which will store the range of IP's to scan
    def __init__(self):
        self.scanned_address_range = []

    # function to append to the list of addresses
    def add_new_address(self, new_address):
        # pass to format_new_address to add network portion
        formatted_address = self.format_new_address(new_address)
        # append newly formatted address
        self.scanned_address_range.append(formatted_address)

    # function to combine the host and network portion together
    def format_new_address(self, new_address):
        formatted_address = f"{self.network}{new_address}"
        return formatted_address


# prints the final results!
def display_address_results(address_range):
    print(f"Subnet Network Address: {address_range.network}{address_range.network_address}")
    print(f"Subnet First Address: {address_range.network}{address_range.first_host}")
    print(f"Subnet Last Address: {address_range.network}{address_range.last_host}")
    print(f"Subnet Broadcast Address: {address_range.network}{address_range.broadcast_address}")
    print("Range of IP Addresses to be scanned: ")
    column_count = 0  # flag value to keep the output a little prettier
    for address in address_range.scanned_address_range:
        if column_count == 10:  # maximum # of addreses per row
            print("")  # empty print to newline
            column_count = 0
        else:
            # print until there is a new print statement
            print(f'{address}, ', end='')
            column_count += 1


def main():
    # local variable for utilizing scanned_address_range list/methods associated
    address_range = NetworkDetails()

    # simply increments count, passes the value of count into add_new_address method
    # to format and store.
    for count in range(address_range.first_host, address_range.broadcast_address):
        address_range.add_new_address(count)
        count += 1
    # pass to display the final results
    display_address_results(address_range)


# start of program
if __name__ == "__main__":
    main()
