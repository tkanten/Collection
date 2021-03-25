import listgen
import crawly


def main():
    need_list = input("hello, need a list? (Y/N): ")
    if need_list.upper() == "Y":
        r_val = int(input("length of combo?: "))
        listgen.new_string(r_val)
        print("generation complete!")

    start_crawl = input("ready to crawl? (Y/N): ")
    if start_crawl.upper() == "Y":
        crawly.startup()


if __name__ == "__main__":
    main()
