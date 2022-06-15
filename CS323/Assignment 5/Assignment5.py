# Assignment 5 (Approximation Algorithms (BPP)
# CSCI 323
# Timothy Dakis
# Websites used: https://www.geeksforgeeks.org

from os import listdir
from os.path import isfile, join
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


def parse_data(file_name):
    with open(file_name, 'r') as file:
        data = []
        lines = file.readlines()
        for line in lines:
            data.append(int(line))
    return data


def optimal_answer(weight, bin_capacity):
    return sum(weight) // bin_capacity


# geeksforgeeks.org/bin-packing-problem-minimize-number-of-used-bins/
def next_fit(weight, bin_capacity):
    res = 0
    rem = bin_capacity
    for _ in range(len(weight)):
        if rem >= weight[_]:
            rem = rem - weight[_]
        else:
            res += 1
            rem = bin_capacity - weight[_]
    return res


# geeksforgeeks.org/bin-packing-problem-minimize-number-of-used-bins/
def first_fit(weight, bin_capacity):
    # Initialize result (Count of bins)
    res = 0
    n = len(weight)
    # Create an array to store remaining space in bins there can be at most n bins
    bin_rem = [0] * n

    # Place items one by one
    for i in range(n):
        # Find the first bin that can accommodate weight[i]
        j = 0
        while j < res:
            if bin_rem[j] >= weight[i]:
                bin_rem[j] = bin_rem[j] - weight[i]
                break
            j += 1

        # If no bin could accommodate weight[i]
        if j == res:
            bin_rem[res] = bin_capacity - weight[i]
            res = res + 1
    return res


# geeksforgeeks.org/bin-packing-problem-minimize-number-of-used-bins/
def best_fit(weight, bin_capacity):
    # Initialize result (Count of bins)
    res = 0
    n = len(weight)

    # Create an array to store remaining space in bins, there can be at most n bins
    bin_rem = [0] * n

    # Place items one by one
    for i in range(n):

        # Find the first bin that can accommodate weight[i]
        j = 0

        # Initialize minimum space left and index of best bin
        min_space = bin_capacity + 1
        bi = 0

        for j in range(res):
            if bin_rem[j] >= weight[i] and bin_rem[j] - weight[i] < min_space:
                bi = j
                min_space = bin_rem[j] - weight[i]

        # If no bin could accommodate weight[i], create a new bin
        if min_space == bin_capacity + 1:
            bin_rem[res] = bin_capacity - weight[i]
            res += 1
        else:  # Assign the item to best bin
            bin_rem[bi] -= weight[i]
    return res


# geeksforgeeks.org/bin-packing-problem-minimize-number-of-used-bins/
def first_fit_dec(weight, bin_capacity):
    return first_fit(sorted(weight, reverse=True), bin_capacity)


# geeksforgeeks.org/bin-packing-problem-minimize-number-of-used-bins/
def best_fit_dec(weight, bin_capacity):
    return best_fit(sorted(weight, reverse=True), bin_capacity)


# adapted from https://www.geeksforgeeks.org/bar-plot-in-matplotlib/
def plot_times_bar_graph(dict_approx_results):

    # set width of bar
    bar_width = 0.12
    fig = plt.subplots(figsize=(12, 8))

    optimal = [dict_approx_results["Optimal Answer"][0]]
    online_nf = [dict_approx_results["Online NF"][0]]
    online_ff = [dict_approx_results["Online FF"][0]]
    online_bf = [dict_approx_results["Online BF"][0]]
    offline_ffd = [dict_approx_results["Offline FFD"][0]]
    offline_bfd = [dict_approx_results["Offline BFD"][0]]
    total_trials = len(dict_approx_results["Trial No."])

    for i in range(10, total_trials + 1, 10):
        optimal.append(dict_approx_results["Optimal Answer"][i-1])
        online_nf.append(dict_approx_results["Online NF"][i-1])
        online_ff.append(dict_approx_results["Online FF"][i-1])
        online_bf.append(dict_approx_results["Online BF"][i-1])
        offline_ffd.append(dict_approx_results["Offline FFD"][i-1])
        offline_bfd.append(dict_approx_results["Offline BFD"][i-1])

    br1 = np.arange(len(optimal))
    br2 = [x + bar_width for x in br1]
    br3 = [x + bar_width for x in br2]
    br4 = [x + bar_width for x in br3]
    br5 = [x + bar_width for x in br4]
    br6 = [x + bar_width for x in br5]

    # Make the plot
    plt.bar(br1, optimal, color='r', width=bar_width,
            edgecolor='grey', label='Optimal Answer')
    plt.bar(br2, online_nf, color='g', width=bar_width,
            edgecolor='grey', label='Online NF')
    plt.bar(br3, online_ff, color='b', width=bar_width,
            edgecolor='grey', label='Online FF')
    plt.bar(br4, online_bf, color='m', width=bar_width,
            edgecolor='grey', label='Online BF')
    plt.bar(br5, offline_ffd, color='y', width=bar_width,
            edgecolor='grey', label='Offline FFD')
    plt.bar(br6, offline_bfd, color='k', width=bar_width,
            edgecolor='grey', label='Offline BFD')

    plt.xticks([r + bar_width+0.18 for r in range(len(optimal))], [str(i) for i in range(1, total_trials + 1) if i == 1
                                                                   or i % 10 == 0])

    plt.legend()
    plt.title("BBP Approximation Algorithms Results")
    plt.xlabel("Trial Number")
    plt.ylabel("Number of Bins")
    plt.savefig("bbp_approx_bar.png")
    plt.show()


def main():
    dict_approx_results = {"Trial No.": [],
                           "File Name": [],
                           "Items": [],
                           "Optimal Answer": [],
                           "Online NF": [],
                           "Online FF": [],
                           "Online BF": [],
                           "Offline FFD": [],
                           "Offline BFD": []
                           }
    count = 1
    mypath = "C:\\Users\\timos\\PycharmProjects\\Assignment5\\BPPData\\"
    files = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    for file in files:
        data = parse_data(mypath+file)
        dict_approx_results["Trial No."].append(count)
        dict_approx_results["File Name"].append(file)
        dict_approx_results["Items"].append(len(data))
        dict_approx_results["Optimal Answer"].append(optimal_answer(data, 100))
        dict_approx_results["Online NF"].append(next_fit(data, 100))
        dict_approx_results["Online FF"].append(first_fit(data, 100))
        dict_approx_results["Online BF"].append(best_fit_dec(data, 100))
        dict_approx_results["Offline FFD"].append(first_fit_dec(data, 100))
        dict_approx_results["Offline BFD"].append(best_fit_dec(data, 100))
        count += 1

    pd.set_option('display.max_rows', 500)
    pd.set_option('display.max_columns', 500)
    pd.set_option('display.width', 1000)
    df = pd.DataFrame.from_dict(dict_approx_results)
    print(df)
    plot_times_bar_graph(dict_approx_results)


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()
