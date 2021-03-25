from selenium import webdriver
import requests
import os
from time import sleep as pause


def startup():
    web_links = get_list()
    crawl(web_links)


def get_list():
    print("hello! grabbing your file data...")
    with open("list.txt", "r") as file:
        unclean_data = file.readlines()
    clean_data = []
    for item in unclean_data:
        clean_data.append(item.rstrip())
    print("file data loaded!")
    return clean_data


def crawl(web_link):
    print("getting path for browser driver...")
    DRIVER_PATH = '/home/tkanten/PyPersonal/Chrome_Driver/chromedriver'
    driver = webdriver.Chrome(executable_path=DRIVER_PATH)
    print("crawling!\n\n")
    file_num = 1

    link_count = len(web_link)

    os.chdir("Photos")
    for link in web_link:

        print(f"Downloading {link}, saving as image{file_num}\n[{file_num}/{link_count} accessed]\n\n")
        driver.get(link)
        img = driver.find_element_by_xpath("/html/body/div[3]/div/img")
        src = img.get_attribute('src')
        img = requests.get(src)
        with open(f"image{file_num}.png", 'wb') as writer:
            writer.write(img.content)
        pause(0.5)
        file_num += 1

    driver.close()
    print("crawling complete! how the fuck did you get this far?")
