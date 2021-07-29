# Problem (Question 9):
- Create a structure fills with 0s and 1s of size t, check if it is a deBruijn sequence of B(2, k), where t = 2k, and if not mutate each element at a 5% chance. Time it 100 times total

# Outcomes:
![image](https://user-images.githubusercontent.com/85649514/127443660-d26e8bd1-b682-4eb7-b1c5-7e7dc7e3f4f1.png)

# Design Overview and Approach:
- Overall approach is a brute force one
- First generate the sequence of size t for both the array and list-based sequences, and then create a vector of vectors which stores all the bitstrings of size k, and then generate all of said bitstrings
- After, for each specific index of the sequence of size t (starting at the first element), check if it contains at least one of the bitstrings of size k when looking k elements ahead of the starting index (inclusive of starting index)
    - Compare each index of the bitstring to the corresponding subsection of the random sequence to check if each element matches
        - If a bitstring is found to be a substring of the sequence, store which string it is to ignore it for the rest of the check
        - If a bitstring is found to not be a substring, go to the next bitstring that has not already been determined a substring
- If no match is found period across all bitstrings, call mutator and repeat from the start of the check
- After it successfully determines all substrings are in the sequence (when starting at different positions of the sequence), then the check is complete and you have a deBruijn sequence of B(2,k)

# Problems that occurred:
- There was a certain extreme case which lead to incorrect sequences being determined as valid sequences
    - This was caused when it was checking at the final position of the sequence to see if it contained the final bitstring, regardless of if it did or not it would terminate, instead of mutating when no bitstring was found as sequence
        - This was fixed by just adding checks for the extreme cases and forcing a mutation
- Another issue is after k > 5, it becomes very slow to compute due to the sheer amount of computations it has to do to determine if it’s a valid sequence, though I could not think of a better way to approach it other than brute force 
