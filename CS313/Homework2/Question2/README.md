# Problem (Question 2)
Make a prefix (stack) calculator

# Design Overview and approach
- I took a pretty direct and simple approach to this, and only implemented the basic operators (+, -, \*, /)
- Also limited the scope of operand values to the integers 0-9
- How I approached it is as follows:
    - User inputs their expression as a string in the correct notation
    - Then, the string gets read from end to beginning (right to left), and each number is pushed to a stack
      -	If a non-digit character is read, then it checks what that character is
            - If it is a whitespace, it ignores
            - If it is not a valid operator, it flags it as false and stops reading through it
            - If it’s a valid operator it performs the operation then pushes the result back into the stack
    - When the valid operator is reached, it pops and stores the top values on the stack
        - The first popped is the first operand, the second is the second (so it does non-communitive operations such as ‘-‘ correctly)
        - If only one operand is able to be popped, flag expression as false and stop reading through it
        - If division by 0 occurs, also flags as false
    - When the string is finished being read through, it goes to set the final result
        - Does this by popping at the end, if this does not make the stack empty, the expression is flagged as false and the result cannot be accessed
 
# References:
These references were largely to figure out how to understand how std::cin works properly, and to figure out analyze characters of a string:

https://stackoverflow.com/questions/5131647/why-would-we-call-cin-clear-and-cin-ignore-after-reading-input
https://stackoverflow.com/questions/25020129/cin-ignorenumeric-limitsstreamsizemax-n
https://en.cppreference.com/w/cpp/types/numeric_limits/max
http://www.cplusplus.com/reference/string/string/
http://www.cplusplus.com/reference/string/string/pop_back/
http://www.cplusplus.com/reference/string/string/back/
http://www.cplusplus.com/reference/string/string/empty/
http://www.cplusplus.com/reference/string/string/length/
https://stackoverflow.com/questions/5029840/convert-char-to-int-in-c-and-c
https://www.geeksforgeeks.org/stdstringback-in-c-with-examples/
http://www.cplusplus.com/reference/cctype/isspace/
https://www.cplusplus.com/reference/cctype/
https://en.cppreference.com/w/cpp/string/byte/isdigit
https://en.cppreference.com/w/cpp/string/byte/isspace
