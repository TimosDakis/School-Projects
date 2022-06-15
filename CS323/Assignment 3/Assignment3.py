# Assignment 3 (Pattern Matching Algorithms)
# CSCI 323
# Timothy Dakis
# Websites used: https://www.geeksforgeeks.org

import random
import time
from lorem_text import lorem
import pandas as pd
import matplotlib.pyplot as plt


def random_text(m):
    # returns a random string of m characters
    return lorem.words(m).upper().replace(" ", "")[:m]


def random_pattern(n, text):
    # print("length of pattern", n)
    if len(text) < n:
        print("Error: pattern length should be less than text length")
    else:
        idx = random.randint(0, len(text) - n)
        return text[idx:idx+n], idx


def python_search(pattern, text):
    return text.find(pattern)


# https://www.geeksforgeeks.org/naive-algorithm-for-pattern-searching/
def brute_force_search(pattern, text):
    n = len(pattern)
    m = len(text)

    # A loop to slide pat[] one by one */
    for i in range(m - n + 1):
        j = 0

        # For current index i, check for pattern match */
        while j < n:
            if text[i + j] != pattern[j]:
                break
            j += 1

        if j == n:
            return i


# https://www.geeksforgeeks.org/kmp-algorithm-for-pattern-searching/
def kmp_search(pattern, text):
    n = len(pattern)
    m = len(text)

    # create lps[] that will hold the longest prefix suffix
    # values for pattern
    lps = [0] * n
    j = 0  # index for pat[]

    # Preprocess the pattern (calculate lps[] array)
    compute_lps_array(pattern, n, lps)

    i = 0  # index for txt[]
    while i < m:
        if pattern[j] == text[i]:
            i += 1
            j += 1

        if j == n:
            return str(i - j)
            j = lps[j - 1]

        # mismatch after j matches
        elif i < m and pattern[j] != text[i]:
            # Do not match lps[0..lps[j-1]] characters,
            # they will match anyway
            if j != 0:
                j = lps[j - 1]
            else:
                i += 1


def compute_lps_array(pat, n, lps):
    longest = 0  # length of the previous longest prefix suffix

    lps[0]  # lps[0] is always 0
    i = 1

    # the loop calculates lps[i] for i = 1 to M-1
    while i < n:
        if pat[i] == pat[longest]:
            longest += 1
            lps[i] = longest
            i += 1
        else:
            # This is tricky. Consider the example.
            # AAACAAAA and i = 7. The idea is similar to search step.
            if longest != 0:
                longest = lps[longest - 1]

                # Also, note that we do not increment i here
            else:
                lps[i] = 0
                i += 1


# https://www.geeksforgeeks.org/rabin-karp-algorithm-for-pattern-searching/
def karp_search(pattern, text):
    q = 10000019  # just some arbitrarily large prime number
    d = 256  # alphabet size
    n = len(pattern)
    m = len(text)
    i = 0
    j = 0
    p = 0  # hash value for pattern
    t = 0  # hash value for txt
    h = 1
    # The value of h would be "pow(d, M-1)%q"
    for i in range(n - 1):
        h = (h * d) % q
    # Calculate the hash value of pattern and first window of text
    for i in range(n):
        p = (d * p + ord(pattern[i])) % q
        t = (d * t + ord(text[i])) % q
    # Slide the pattern over text one by one
    for i in range(m - n + 1):
        # Check the hash values of current window of text and pattern if the hash values match then only check
        # for characters on by one
        if p == t:
            # Check for characters one by one
            for j in range(n):
                if text[i + j] != pattern[j]:
                    break
                else:
                    j += 1

            # if p == t and pat[0...M-1] = txt[i, i+1, ...i+M-1]
            if j == n:
                return str(i)
        # Calculate hash value for next window of text: Remove leading digit, add trailing digit
        if i < m - n:
            t = (d * (t - ord(text[i]) * h) + ord(text[i + n])) % q

            # We might get negative values of t, converting it to positive
            if t < 0:
                t = t + q


def plot_times_line_graph(dict_sorts):
    for sorts in dict_sorts:
        x = dict_sorts[sorts].keys()
        y = dict_sorts[sorts].values()
        plt.plot(x, y, label=sorts)
    plt.legend()
    plt.title("Run Time of Pattern Matching Algorithms")
    plt.xlabel("Length of Text")
    plt.ylabel("Time for 1 Trial On Average (sec)")
    plt.savefig("pat_match_graph_line.png")
    plt.show()


def main():
    trials = 200
    dict_pat_searches = {}
    pat_searches = [python_search, brute_force_search, kmp_search, karp_search]
    for pat_search in pat_searches:
        dict_pat_searches[pat_search.__name__] = {}
    sizes = [1000, 5000, 10000, 25000, 50000]
    for size in sizes:
        for pat_search in pat_searches:
            dict_pat_searches[pat_search.__name__][size] = 0
        for trial in range(1, trials + 1):
            text = random_text(size)
            pattern_length = size//2
            pattern, rand_pattern_start_idx = random_pattern(pattern_length, text)
            for pat_search in pat_searches:
                start_time = time.time()
                found_pattern_start_idx = pat_search(pattern, text)
                end_time = time.time()
                net_time = end_time - start_time
                # checks if found same pattern as where taken from string initially
                if int(found_pattern_start_idx) != int(rand_pattern_start_idx):
                    print("ERROR:", pat_search.__name__, "PATTERN START INDICES DO NOT MATCH")
                # add the average net time (in seconds) for that trial to the dict
                dict_pat_searches[pat_search.__name__][size] += net_time / trials

    pd.set_option('display.max_rows', 500)
    pd.set_option('display.max_columns', 500)
    pd.set_option('display.width', 1000)
    df = pd.DataFrame.from_dict(dict_pat_searches).T
    print(df)
    plot_times_line_graph(dict_pat_searches)


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()
