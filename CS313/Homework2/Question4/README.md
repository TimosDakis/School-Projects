# Problem (Q4)
Design a function that lists all the elements in a stack, and design a function that lets you change a value of a given position.

# Design overview and approach
-	For listing the elements, I just took a very direct approach and just printed out the elements of the array in reverse, as that is the order they would be popped off the stack
    -	Also allowed users to input how many values they would want outputted on a line, if they input a negative value it would just default to putting everything on one line
-	For changing a value based on a given position I just have the user input the position, and then the value, and if the position is valid it directly accesses that position in the array holding the data to change its value to said new value
