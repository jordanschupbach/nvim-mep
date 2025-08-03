"""Python script to generate a random array and calculate its mean."""

import numpy as np

np.random.seed(42)  # For reproducibility


def generate_random_array(size):
    """Generates a random array of given size."""
    return np.random.rand(size)


def calculate_mean(array):
    """Calculates the mean of the given array."""
    return np.mean(array)


def main():
    """Main function to demonstrate random array generation and mean calculation."""
    size = 10  # Size of the random array
    random_array = generate_random_array(size)
    print("Random Array:", random_array)
    mean_value = calculate_mean(random_array)
    print("Mean Value:", mean_value)


if __name__ == "__main__":
    main()
