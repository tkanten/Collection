"""
Input expectations:
- The guess file can either be a .json file with a list, or a raw file where each guess is on a separate line.

Limitations:
- it's Python, it's slow as shit for a cracker
    - to make matters worse, parallel Python is a no bueno; mouse/keyboard interaction is required
- only works on OneNote, not OneNote for Windows 10
- the section needs to be visible within the UI - if it's buried on a different page, the script will fail
"""

from time import sleep, perf_counter
import pywinauto
import json

target_path = r"C:\Program Files\Microsoft Office\root\Office16\ONENOTE.EXE"
target_book = "DevTestBook"
target_section = "secret section"
guess_file = "secrets.json"


def load_data(file_path: str) -> list:
    try:
        with open(file_path, 'r') as f:
            if file_path.endswith('.json'):
                data = json.load(f)
                if not isinstance(data, list):
                    raise Exception('Data is not a list')
            else:
                data = [line.strip() for line in f]
        print(f"Located a total of {len(data)} guesses")
        data = list(set([entry for entry in data if isinstance(entry, str)]))
        print(f"Located {len(data)} unique guesses")
        return data
    except Exception as e:
        print(f'An error occurred: {e}')


def open_protected_section_window(main_window: pywinauto.WindowSpecification) -> None:
    button_title = "<1>This section is password protected.\n\nClick here or press ENTER to unlock it."
    try:
        password_entry_button = main_window.child_window(title=button_title, control_type="Button")
        if not password_entry_button.exists():
            raise Exception("Could not find the button to open password entry menu")

        password_entry_button.click_input()
    except Exception as e:
        raise Exception("Failure with open_protected_section_window:", e)


def get_protected_section_window(main_window: pywinauto.WindowSpecification) -> pywinauto.WindowSpecification:
    try:
        return main_window.child_window(title="Protected Section",
                                        control_type="Window",
                                        found_index=0)
    except Exception as e:
        raise Exception(f"Failure while trying to get protected section window", e)


def setup_protected_section_window(main_window: pywinauto.WindowSpecification) -> pywinauto.WindowSpecification:
    # first check to see if the pop-up window is already open
    unlock_window = get_protected_section_window(main_window)

    if unlock_window.exists():
        return unlock_window
    else:
        open_protected_section_window(main_window)
        return get_protected_section_window(main_window)


def submit_attempt_to_protected_section_window(guess: str, protected_section_window: pywinauto.WindowSpecification):
    try:
        if not isinstance(guess, str):
            raise TypeError(f"Type for each guess must be of str - input was {type(guess)}")

        # print(protected_section_window.print_control_identifiers())

        # protected_section_window.Edit.type_keys(guess)
        protected_section_window.Edit.set_edit_text(guess)

        protected_section_window.OK.click()

    except Exception as e:
        raise Exception(f"{guess} - FAILED while submitting attempt to protected section window- {e}")


def setup_application(_target_path: str) -> pywinauto.Application:
    app = pywinauto.Application(backend='uia').start(_target_path)
    while not app.windows():
        sleep(0.5)

    return app


def setup_base_window(app: pywinauto.Application) -> pywinauto.WindowSpecification:
    # found_index set to 0, lower index seems to represent the highest found window in the application tree
    base_window: pywinauto.WindowSpecification = app.window(title_re=r".*OneNote",
                                                            found_index=0)  # Framework::CFrameApp

    if not base_window.exists():
        raise Exception("couldn't find the onenote window")

    # find the notebook name (via the button), validate it exists
    if not base_window.child_window(title=target_book, control_type="Button").exists():
        raise Exception(f"Appears target book '{target_book}' is not currently open. "
                        f"Open it in OneNote, then try again.")

    # find the section, validate it exists, click on it
    if not base_window.child_window(title=target_section, control_type="TabItem").exists():
        raise Exception(f"Couldn't find target section '{target_section}' - ensure properly entered")
    base_window.child_window(title=target_section, control_type="TabItem").click_input()

    return base_window


def main() -> None:
    global target_path
    global target_book
    global target_section
    global guess_file

    app = setup_application(target_path)

    base_window = setup_base_window(app)
    # base_window.dump_tree(filename="dump_tree")
    # base_window.print_control_identifiers(filename="control_identifiers")
    # sleep(1)
    # base_window.minimize()
    # sleep(1)
    # base_window.maximize()
    # try to press the "File" button" (success, testing only)
    # base_window.child_window(title="File Tab", auto_id="FileTabButton", control_type="Button").click()

    # open/get password window
    guesses = load_data(guess_file)

    # guesses = guesses[:5]

    start_perf = perf_counter()

    protected_section_window = setup_protected_section_window(base_window)
    for guess in guesses:
        submit_attempt_to_protected_section_window(guess, protected_section_window)

        # if the window doesn't exist, the protected section was unlocked
        if protected_section_window.exists():
            guess = ""
            continue
        else:
            break

    end_perf = perf_counter()

    print(f"Password found: {guess}" if guess else "No password found")

    print(f"Run time for guessing: {end_perf - start_perf}")
    app.kill()


if __name__ == "__main__":
    main()
