import os

HOME_PATH = "/home/werkspot"


def main():
    with open(f"{HOME_PATH}/event_log.csv") as f:
        text = f.read()
        text = text.replace(';', ',')
    if not os.path.exists(f"{HOME_PATH}/data"):
        os.mkdir(f"{HOME_PATH}/data")
    with open(f"{HOME_PATH}/data/event_log.csv", "w") as f:
        f.write(text)


if __name__ == "__main__":
    main()
