# Problem (Question 4):
-	Implement a bubble sort and insertion sort for 1D arrays and linked lists

# Results:
-	When sorting the same exact elements in same relative positions of these data structures, time take from fastest to slowest was: array insertion > array bubble > linked bubble > linked insertion

# Design Overview and Approach:
- Took a pretty standard approach for the array versions of the sorts, bubble sort attempts to sort each pair element in the unsorted portion, exits early if no sorts occurred. Insertion sort takes first element in unsorted portion of array, and compares it to all elements before it in the sorted portion, if its smaller than any element before it, swaps
- For linked list implementation sorts, I tried to follow a similar logic but in the context of linked lists
- For linked bubble sort:
    - Set up a flag to check if any sort has occurred, if not exits early
    - To perform sort itself, set up two nodes: a current node, and one which trails it
    - To ensure it is fully sorted, attempts to execute entire sort the equivalent of length times (as that is how many elements there are)
        - Each time this occurs, resets flag to false, then sets up current node to element chained after first, and trailing node to first node
    - After this, iterates through unsorted portion of list (or until current node becomes null, this is largely to deal with case of there being 1 element)
        - When the current node is smaller than the node before it, swaps the data of the nodes, and sets flag to true
    - Repeats until sort is over
- For linked insertion:
    - To perform sort, set up a current and trailing node
    - To ensure it is fully sorted, execute entire sort the equivalent of length times
    - At start, sets current and trailing to second and first nodes respectively
    - Then it iterates through list until current node becomes node to be sorted
    - Then if said current node is smaller than the node before it, it deletes the node to reinsert, and then iterates through the sorted portion of list until it reaches the first node which contains data larger than the node we are trying to insert
        - When found, insert before that node
    - Repeats until sort is over

# Problems that occurred:
- An issue occurred when trying to sort an item that had been sorted earlier in linked insertion (it would delete this earlier item instead of unsorted item before insertion), deeper analysis revealed an issue with the way the delete function of the linked list was implemented, it searched for the first location of given data to delete, and then deleted it
    - To fix this issue, had to implement a new delete function that works based off a provided relative position/index to delete a specific node
