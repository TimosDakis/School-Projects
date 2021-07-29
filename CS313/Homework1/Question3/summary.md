# Problem (Question 3):
-	Design a bubble, insertion, and selection sort for nxn 2D matrices that do not force them into 1D arrays

# Design Overview and Approach:
-	For the sorts, I just took standard approaches to each:
    -	For bubble sort, compared each element to one after, and sorted when one was bigger, pushing largest to end
        -	Slight optimizations to the sort were made though: if no sort occurred in some iteration it ends prematurely given that meant it was sorted (this is the exit condition in general), likewise, it decreases range it iterates through the matrix each loop given each loop reduces the size of the unsorted portion by one
    -	For insertion sort, essentially have a sorted and unsorted portion, to sort takes element at start of unsorted portion and iterates backwards to start of matrix (which is start of sorted portion) to see where it would slot in by swapping any time it is smaller than an element before it in the sorted portion
    -	For selections sort, take an index, make that your minimum element, then compare it to the rest of the indices after it (which are all in an unsorted portion), when it finds a new minimum swap them, then repeat with the next element until fully sorted
-	To deal with need to compare elements across different rows, I determine matrix row and column indices based off relative element’s index (e.g., in a 3x3 matrix, the 9th element would be index 8 in zero-based indexing, however it is located at matrix[2][2] position, the end of the matrix)
    -	To do this, I made use of integer division and modulo, this is because in an n\*n matrix, if x is some element’s relative index and you take n, then to get the precise matrix position indices you do x/n to get the row, and x%n to get the column (e.g., 8/3 = 2, and 8%3 = 2, which gives you matrix[2][2] position)

# Problems that occurred:
-	The primary issue I had was dealing with the fact I would need to compare multiple rows at times, at first I tried a more brute force approach wherein after you reached end of a row, it compares with start of next
    -	However, that was messy, so after thinking about it some more I realized how you could make use of integer division and modulo to determine the positions of the row and columns of each element in the matrix to deal with it, as mentioned prior
