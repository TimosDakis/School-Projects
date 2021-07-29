# Problem (Question 10):
- Make a sort that puts all odd numbers first and even numbers after

# Design Overview and Approach:
- I took a very direct and straightforward approach:
    - Set up a current and trailing node
        - Set current to 2nd node and trailing to one before it (this is because can just skip over checking first node given it will always be in correct part of list in the end)
    - Then, iterate until end of the list is reached
        - If an odd number is found, relink it to front of the list
            - If last node of list, make trailing node the last node
            - Does this relink by using trailing node to skip over the current nodes position in list before relinking the node we are checking that contains an odd value to the start
        - If odd number not found, just go to next node
