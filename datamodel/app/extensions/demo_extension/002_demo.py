import argparse


def demo(myVariable,myNumber):
    print(f"{myVariable}! My favorite number is {myNumber}")


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("-v", "--myVariable", help="my variable")
    parser.add_argument("-n", "--myNumber", help="my number")
    args = parser.parse_args()

    demo(
        args.myVariable,
        args.myNumber,
    )
