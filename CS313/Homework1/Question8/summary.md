# Problem (Question 8):
- Design a templated class that generates random numbers and then finds all the subsets that add up to a provided sum

# Design Overview and Approach:
- My idea began with generating the random numbers into an array
- After that, to find all subsets that add up to the wanted sum, I generated each subset and checked if the sum of that subset is the target
    - If it is, store it in the set that contains the solutions
        - A set is used here to minimize the amount of duplicate solutions
    - If not, ignore and go to next subset
- Overall, I took a pretty brute force approach to the problem, as I compare each subset individually to see if adds up to the sum or not

# Problems that occurred:
- My largest issue came from the fact that I could not think of how to generate all the subsets, I had several ideas but could not think of how to properly implement it
    - So, I did some research, and found: https://www.geeksforgeeks.org/backtracking-to-find-all-subsets/
        - This showcases how to generate the subsets via recursion and backtracking
    - So, because of this, I could figure out how to apply this idea of recursion and backtracking to find the subsets that contain the sum
        - Each subset generated would be checked, if it was the sum it would be stored, otherwise it was ignored
