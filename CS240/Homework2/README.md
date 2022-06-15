# Homework 2
Write a MIPS assembly language program that accomplishes the following tasks:
1) The program will prompt the user to enter an integer k between 1 and 10.
2) If the entered k is out of range just have the program exit.
3) Depending on the k value implement the following cases:

**Case 1:** if 1 <= k < 5
1) Have n (n>= 0) be prompted from the user.
2) compute Func(n):
    if (n = 0 or n = 1) then Func(n) = 20
    else Func(n) = 5\*Func(n-2) + n;
3) Display a result_message together with the numeric value of the result.
4) Repeat (meaning prompt the user for n)
  
**Case 2**: if 5 <= k <= 10
1) Display a joke.

Your program should be well documented with comments.

Your console output should include helpful prompts for the user.
