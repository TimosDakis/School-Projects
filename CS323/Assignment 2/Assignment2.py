# Assignment 2 (Sort Algorithms)
# CSCI 323
# Timothy Dakis
# Websites used: https://www.geeksforgeeks.org, https://rosettacode.org

import copy
import math
import random
import time
import pandas as pd
import matplotlib.pyplot as plt


def is_sorted(func, sorted_source_array, sorted_array):
    # if array not properly sorted, output error
    if sorted_array != sorted_source_array:
        print("Error:", func.__name__, "did not properly sort!")
        print(sorted_array)


def random_list(range_max, size):
    arr = [random.randint(1, range_max) for i in range(size)]
    return arr


def python_sort(to_sort):
    to_sort.sort()


# https://www.geeksforgeeks.org/bubble-sort/
def bubble_sort(to_sort):
    n = len(to_sort)
    # Traverse through all array elements
    for i in range(n):

        # Last i elements are already in place
        for j in range(0, n-i-1):

            # traverse the array from 0 to n-i-1
            # Swap if the element found is greater than the next element
            if to_sort[j] > to_sort[j+1]:
                to_sort[j], to_sort[j+1] = to_sort[j+1], to_sort[j]


# https://www.geeksforgeeks.org/selection-sort/
def selection_sort(to_sort):
    # Traverse through all array elements
    for i in range(len(to_sort)):

        # Find the minimum element in remaining unsorted array
        min_idx = i
        for j in range(i + 1, len(to_sort)):
            if to_sort[min_idx] > to_sort[j]:
                min_idx = j

        # Swap the found minimum element with the first element
        to_sort[i], to_sort[min_idx] = to_sort[min_idx], to_sort[i]


# https://www.geeksforgeeks.org/insertion-sort/
def insertion_sort(to_sort):
    # Traverse through 1 to len(to_sort)
    for i in range(1, len(to_sort)):
        key = to_sort[i]

        # Move elements of arr[0..i-1], that are greater than key, to one position ahead of their current position
        j = i-1
        while j >= 0 and key < to_sort[j]:
            to_sort[j + 1] = to_sort[j]
            j -= 1
        to_sort[j + 1] = key


# https://www.geeksforgeeks.org/cocktail-sort/
def cocktail_sort(to_sort):
    n = len(to_sort)
    swapped = True
    start = 0
    end = n - 1
    while swapped:
        # reset the swapped flag on entering the loop, because it might be true from a previous iteration.
        swapped = False
        # loop from left to right same as the bubble sort
        for i in range(start, end):
            if to_sort[i] > to_sort[i + 1]:
                to_sort[i], to_sort[i + 1] = to_sort[i + 1], to_sort[i]
                swapped = True

        # if nothing moved, then array is sorted.
        if not swapped:
            break
        # otherwise, reset the swapped flag so that it can be used in the next stage
        swapped = False
        # move the end point back by one, because item at the end is in its rightful spot
        end = end - 1
        # from right to left, doing the same comparison as in the previous stage
        for i in range(end - 1, start - 1, -1):
            if to_sort[i] > to_sort[i + 1]:
                to_sort[i], to_sort[i + 1] = to_sort[i + 1], to_sort[i]
                swapped = True
        # increase the starting point, because the last stage would have moved the next
        # smallest number to its rightful spot.
        start = start + 1


# https://www.geeksforgeeks.org/shellsort/
def shell_sort(to_sort):
    gap = len(to_sort) // 2  # initialize the gap
    while gap > 0:
        i = 0
        j = gap
        # check the array in from left to right till the last possible index of j
        while j < len(to_sort):
            if to_sort[i] > to_sort[j]:
                to_sort[i], to_sort[j] = to_sort[j], to_sort[i]
            i += 1
            j += 1
            # now, we look back from ith index to the left # we swap the values which are not in the right order.
            k = i
            while k - gap > -1:
                if to_sort[k - gap] > to_sort[k]:
                    to_sort[k - gap], to_sort[k] = to_sort[k], to_sort[k - gap]
                k -= 1
        gap //= 2


def merge_sort(to_sort):
    merge_sort_recursion(to_sort)


# https://www.geeksforgeeks.org/merge-sort/
def merge_sort_recursion(to_sort):
    if len(to_sort) > 1:
        # Finding the mid of the array
        mid = len(to_sort)//2
        # Dividing the array elements
        left = to_sort[:mid]
        # into 2 halves
        right = to_sort[mid:]
        # Sorting the first half
        merge_sort_recursion(left)
        # Sorting the second half
        merge_sort_recursion(right)

        i = j = k = 0
        # Copy data to temp arrays left[] and right[]
        while i < len(left) and j < len(right):
            if left[i] < right[j]:
                to_sort[k] = left[i]
                i += 1
            else:
                to_sort[k] = right[j]
                j += 1
            k += 1
        # Checking if any element was left
        while i < len(left):
            to_sort[k] = left[i]
            i += 1
            k += 1

        while j < len(right):
            to_sort[k] = right[j]
            j += 1
            k += 1


def quick_sort(to_sort):
    quick_sort_recursion(0, len(to_sort)-1, to_sort)


# https://www.geeksforgeeks.org/quick-sort/
def partition(start, end, array):
    # Initializing pivot's index to start
    pivot_index = start
    pivot = array[pivot_index]

    # This loop runs till start pointer crosses end pointer, and when it does we swap the
    # pivot with element on end pointer
    while start < end:
        # Increment the start pointer till it finds an element greater than  pivot
        while start < len(array) and array[start] <= pivot:
            start += 1
        # Decrement the end pointer till it finds an element less than pivot
        while array[end] > pivot:
            end -= 1

        # If start and end have not crossed each other, swap the numbers on start and end
        if start < end:
            array[start], array[end] = array[end], array[start]

    # Swap pivot element with element on end pointer. This puts pivot on its correct sorted place.
    array[end], array[pivot_index] = array[pivot_index], array[end]

    # Returning end pointer to divide the array into 2
    return end


# https://www.geeksforgeeks.org/quick-sort/
def quick_sort_recursion(start, end, to_sort):
    if start < end:
        # p is partitioning index, array[p] is at right place
        p = partition(start, end, to_sort)

        # Sort elements before partition and after partition
        quick_sort_recursion(start, p - 1, to_sort)
        quick_sort_recursion(p + 1, end, to_sort)


# https://www.geeksforgeeks.org/heap-sort/
def heapify(arr, n, i):
    largest = i  # Initialize largest as root
    l_child = 2 * i + 1     # left = 2*i + 1
    r_child = 2 * i + 2     # right = 2*i + 2

    # See if left child of root exists and is greater than root
    if l_child < n and arr[largest] < arr[l_child]:
        largest = l_child

    # See if right child of root exists and is greater than root
    if r_child < n and arr[largest] < arr[r_child]:
        largest = r_child

    # Change root, if needed
    if largest != i:
        arr[i], arr[largest] = arr[largest], arr[i]  # swap

        # Heapify the root.
        heapify(arr, n, largest)


# https://www.geeksforgeeks.org/heap-sort/
def heap_sort(to_sort):
    n = len(to_sort)

    # Build a maxheap.
    for i in range(n//2 - 1, -1, -1):
        heapify(to_sort, n, i)

    # One by one extract elements
    for i in range(n-1, 0, -1):
        to_sort[i], to_sort[0] = to_sort[0], to_sort[i]  # swap
        heapify(to_sort, i, 0)


# adapted from https://rosettacode.org/wiki/Sorting_algorithms/Counting_sort
def counting_sort(to_sort):
    # makes sure array to sort is not empty
    if len(to_sort) > 0:
        # get max and min
        max_element = max(to_sort)
        min_element = min(to_sort)
        # initialize an array of size max - min + 1 to count frequencies (doing this way limits size of array)
        count = [0 for i in range(max_element - min_element + 1)]
        # count frequencies
        for num in to_sort:
            count[num - min_element] += 1
        # loop through all digits [min, max]
        to_sort_idx = 0
        for i in range(min_element, max_element+1):
            # if there were > 0 of those digits put them in their respective sorted spot in to_sort array
            while count[i - min_element] > 0:
                to_sort[to_sort_idx] = i
                to_sort_idx += 1
                count[i - min_element] -= 1


# https://www.geeksforgeeks.org/bucket-sort-2/
def bucket_sort(to_sort):
    # if array is very small, consider it in 1 bucket and just sort it directly
    # this bucket sort algorithm did not work for n < 2 hence this check
    if len(to_sort) < 2:
        to_sort.sort()
    else:
        max_ele = max(to_sort)
        min_ele = min(to_sort)

        # number of buckets kept proportional to array size
        no_of_buckets = int(math.sqrt(len(to_sort)))

        # range(for buckets)
        bucket_range = (max_ele - min_ele) / no_of_buckets

        temp = []

        # create empty buckets
        for i in range(no_of_buckets):
            temp.append([])

        # scatter the array elements into the correct bucket
        for i in range(len(to_sort)):
            diff = (to_sort[i] - min_ele) / bucket_range - int((to_sort[i] - min_ele) / bucket_range)

            # append the boundary elements to the lower array
            if diff == 0 and to_sort[i] != min_ele:
                temp[int((to_sort[i] - min_ele) / bucket_range) - 1].append(to_sort[i])

            else:
                # if it would reach edge case of going out of upper bound, force it into final bucket
                if int((to_sort[i] - min_ele) / bucket_range) >= len(temp):
                    temp[len(temp) - 1].append(to_sort[i])
                else:
                    temp[int((to_sort[i] - min_ele) / bucket_range)].append(to_sort[i])

        # Sort each bucket individually
        for i in range(len(temp)):
            if len(temp[i]) != 0:
                temp[i].sort()

        # Gather sorted elements to the original array
        k = 0
        for lst in temp:
            if lst:
                for i in lst:
                    to_sort[k] = i
                    k = k + 1


# https://www.geeksforgeeks.org/radix-sort/
def counting_sort_for_radix(arr, exp1):
    n = len(arr)

    # The output array elements that will have sorted arr
    output = [0] * n

    # initialize count array as 0
    count = [0] * 10

    # Store count of occurrences in count[]
    for i in range(0, n):
        index = arr[i] // exp1
        count[index % 10] += 1

    # Change count[i] so that count[i] now contains actual
    # position of this digit in output array
    for i in range(1, 10):
        count[i] += count[i - 1]

    # Build the output array
    i = n - 1
    while i >= 0:
        index = arr[i] // exp1
        output[count[index % 10] - 1] = arr[i]
        count[index % 10] -= 1
        i -= 1

    # Copying the output array to arr[],
    # so that arr now contains sorted numbers
    i = 0
    for i in range(0, len(arr)):
        arr[i] = output[i]


# Method to do Radix Sort
def radix_sort(to_sort):
    # checks if array is > 0, if 0 already sorted so skip (ensures functions does not break in case len == 0)
    if len(to_sort) > 0:
        # Find the maximum number to know number of digits
        max1 = max(to_sort)
        # Do counting sort for every digit. Note that instead  of passing digit number, exp is passed. exp is 10^i
        # where i is current digit number
        exp = 1
        while max1 / exp >= 1:
            counting_sort_for_radix(to_sort, exp)
            exp *= 10


def plot_times_line_graph(dict_sorts):
    for sorts in dict_sorts:
        x = dict_sorts[sorts].keys()
        y = dict_sorts[sorts].values()
        plt.plot(x, y, label=sorts)
    plt.legend()
    plt.title("Run Time of Sort Algorithms")
    plt.xlabel("Number of Elements")
    plt.ylabel("Time for 1 Trial On Average (sec)")
    plt.savefig("sort_graph_line.png")
    plt.show()


def main():
    max_int = 10000
    trials = 1
    dict_sorts = {}
    sorts = [python_sort, bubble_sort, selection_sort, insertion_sort, cocktail_sort, shell_sort, merge_sort,
             quick_sort, heap_sort, counting_sort, bucket_sort, radix_sort]
    for sort in sorts:
        dict_sorts[sort.__name__] = {}
    sizes = [10, 100, 1000, 10000]
    for size in sizes:
        for sort in sorts:
            dict_sorts[sort.__name__][size] = 0
        for trial in range(1, trials + 1):
            unsorted_array = random_list(max_int, size)
            sorted_test_array = sorted(unsorted_array)
            for sort in sorts:
                to_sort = copy.deepcopy(unsorted_array)
                start_time = time.time()
                sort(to_sort)
                end_time = time.time()
                net_time = end_time - start_time
                # checks if array was properly sorted
                is_sorted(sort, sorted_test_array, to_sort)
                # add the average net time (in seconds) for that trial to the dict
                dict_sorts[sort.__name__][size] += net_time / trials

    pd.set_option('display.max_rows', 500)
    pd.set_option('display.max_columns', 500)
    pd.set_option('display.width', 1000)
    df = pd.DataFrame.from_dict(dict_sorts).T
    print(df)
    plot_times_line_graph(dict_sorts)


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
