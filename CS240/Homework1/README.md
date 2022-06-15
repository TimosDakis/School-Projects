# Homework 1 - Both
Document the following:

1) Name, last modified date, program name
2) What the program does (C/Java pseudocode)
3) Registers used (name of registers and what they will store)

# Homework 1 - Part 1
Write a MIPS assembly language program that will cover the following steps: 
1) Prompts the user to enter a first integer (int1) in the range [100, 250]
2) Prompts the user to enter a second integer (int 2) > -30
3) Compute: 4\*int1+ 7\*(int2 -9) // don’t use subi; don’t use muli
4) Print the value of the result together with a result message
5) Repeat

The program should enforce the rule that the two entered integers must be in the mentioned 
intervals. **If the entered integer is not in the specified range, the program prompts again 
the user to enter an integer in the specified range.**

Create a **sentinel** (sentinel value **999**) that will allow the user to exit the program.

# Homework 1 - Part 2
Write a MIPS assembly language program that accomplishes the following tasks: 
1) Prompts the user to enter 10 integer values that will represent the elements of an array.
2) Populate the array with the given values.
3) Compute and display the sum and min of these elements.
4) Traverses and display in reverse order the elements of the array on one column
