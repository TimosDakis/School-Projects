# Problem (Question 3)
(Design) and test an operation of an array-based, and a link-based stack over millions of operations

# Outcome:
Tested deletion (popping), both types were constant time; however, it was still technically faster with an array-based, which makes since given it still takes fewer operations to perform deletion in it even if they are both constant time.

# Design Overview and Approach
- Implemented the standard things expect: pop, push, copy, initialize, and so on, as well as a swap function
- For array-based made the top of the stack always point to the first empty position in the array, so it is full when it is equal to the max size (and empty when 0)
    - For linked-based there is not max size, but to tell if it is empty it is when the pointer to the top node is null, and so is empty
-	To build the array-based, just kept adding after the stack top, then increasing that stack top value, and to delete just reduced the value that corresponds to the top of the stack
    -	To build linked-based, essentially built it going backwards so the top of the stack was always at the front of the list, and the end of the list points to null. 
        -	To delete just created a temp node, and shifted top forward (down) by one, then deleted the temporary node
- For swaps, just made values of things and pointers of the stacks point to the other stack
