
print("Hello world!")

def add(a, b):
    """Returns the sum of a and b."""
    return a + b

def subtract(a, b):
    """Returns the difference of a and b."""
    return a - b

def multiply(a, b):
    """Returns the product of a and b."""
    return a * b

def divide(a, b):
    """Returns the quotient of a and b."""
    if b == 0:
        raise ValueError("Cannot divide by zero.")
    return a / b


def main():
    x = 10
    y = 5
    print(f"Adding {x} and {y}: {add(x, y)}")
    print(f"Subtracting {y} from {x}: {subtract(x, y)}")
    print(f"Multiplying {x} and {y}: {multiply(x, y)}")
    print(f"Dividing {x} by {y}: {divide(x, y)}")

# This is a simple Python script that demonstrates basic arithmetic operations.
if __name__ == "__main__":
    main()
