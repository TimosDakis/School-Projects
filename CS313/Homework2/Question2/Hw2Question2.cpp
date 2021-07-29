#include <iostream>
#include <string>
#include <ctype.h>
#include <algorithm>
#include<limits>


template <class dataType>
class PrefixCalcStack {
private:
    dataType* stack;
    int stackTop = 0, maxStackSize = 0;

public:
    PrefixCalcStack(int size) {
        while (size < 0) {
            std::cout << "ERROR: Stack size cannot be less than 0\n";
            std::cout << "Input new size: ";
            std::cin >> size;
            //if invalid type inputted, clear internally to show there is no error
            std::cin.clear();
            //clear rest of the line to ensure no errors occur if multiple values inputted at the cin 
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        }
        
        maxStackSize = size;
        stack = new dataType[size];

    }

    void pushBack(const dataType & item) {
        if (isFull())
            std::cout << "Cannot insert as stack is full.\n";
        else
            stack[stackTop++] = std::move(item);
    }
    void popBack() {
        if (isEmpty())
            std::cout << "Cannot remove items from an empty stack.\n";
        else
            stackTop--;
    }

    dataType peekTop() {
        if (isEmpty())
            std::cout << "Cannot peek top from an empty stack.\n";
        else
            //return stackTop - 1, as top element is actually the element before where stackTop points (as started from stackTop = 0 = empty state, but store first item in 0)
            return stack[stackTop-1];
    }

    bool isFull() { return(stackTop == maxStackSize); }
    bool isEmpty() { return (stackTop == 0); }

};


class PrefixCalc {

private:
    std::string expression = "";
    bool validExpression = true;
    double result;

public:
    //constructor, takes in expression to calculate
    PrefixCalc(std::string expression) : expression(std::move(expression)) {
        //make a stack of a size equivalent to length of string expression (realistically can be smaller, but this is a safe value to use as it should be impossible to get bigger)
        PrefixCalcStack<double> stack(this->expression.size());

        //begin evaluating the expression
        evaluateExpression(stack);

    }

private:
    void evaluateExpression(PrefixCalcStack<double> & stack) {

        //if there is no expression to begin with
        if (expression.empty()) {
            //output error message then exit function, also flag it is not a valid expression
            std::cout << "Invalid: No expression inputted.\n";
            validExpression = false;
            return;
        }

        //this is keeping track of current character we will be looking at
        char currentChar;

        //while the expression string is not empty and the expression is still valid
        while (!expression.empty() && validExpression) {
            //set character to last character of string
            currentChar = expression.back();
            //if the character is some whitespace, skip over it
            if (isspace(currentChar)) {
                expression.pop_back();
                continue;
            }

            else if (isdigit(currentChar)) {
                //pushes the number into stack after converting it to its value equivalent
                stack.pushBack((double)currentChar - '0');
            }
            else
                checkOperation(stack, currentChar);

            //remove last character of string
            expression.pop_back();
        }

    invalidExpression:
        //if the expression is not valid at any point, output error then exit function
        if (!validExpression) {
            std::cout << "Error: expression was not valid.\n";
            return;
        }

        result = stack.peekTop();
        stack.popBack();
        //if stack is not empty after getting result, jump back to the code that outputs expression is not valid error (this because if it was result stack should be empty)
        if (!stack.isEmpty()) {
            validExpression = false;
            goto invalidExpression;
        }

        
    
    
    }
    void checkOperation(PrefixCalcStack<double> & stack, char currentChar) {
    
        //checks if the current character is a valid operator
        if (currentChar == '+' || currentChar == '/' || currentChar == '-' || currentChar == '*')
            //if it is, attempt to execute the operation
            doOperation(stack, currentChar);
        else
            //if it is not, it is not a valid expression so set to false
            validExpression = false;

    }
    void doOperation(PrefixCalcStack<double>& stack, char currentChar) {
    
        //if stack is empty, expression is not valid so set to false then return (as cannot perform operation of no operands)
        if (stack.isEmpty()) {
            validExpression = false;
            return;
        }

        //make op1 value at top of stack, then pop it off stack
        double op1 = stack.peekTop();
        stack.popBack();
        
        //if stack is empty, expression is not valid so set to false then return (as cannot perform pre-set operations if only one operand)
        if (stack.isEmpty()) {
            validExpression = false;
            return;
        }

        //make op2 value at top of stack, then pop it off stack
        double op2 = stack.peekTop();
        stack.popBack();    

        //enter switch statement to perform operation
        switch (currentChar) {
        case '+':
            stack.pushBack(op1 + op2);
            break;

        case '-':
            stack.pushBack(op1 - op2);
            break;
        
        case '*':
            stack.pushBack(op1 * op2);
            break;

        case '/':
            //if division by 0, expression not valid so set to false then return (as cannot divide by 0)
            if (op2 == 0) {
                validExpression = false;
                return;
            }
            stack.pushBack(op1 / op2);
        }
    }

public:
    void printResult() {
    
        //if the expression was valid, it will print the result otherwise refuses to print result
        if (validExpression) {
            std::cout << "The result of your expression is: " << result << std::endl;
        }
        else
            std::cout << "Cannot print a result from an invalid expression. \n";
    };

    double getResult() {
        
        //if expression was valid, returns the result otherwise will print a statement refusing to do so
        if (validExpression)
            return result;
        else
            std::cout << "Cannot return a result from an invalid expression.\n";
    
    }

};



int main()
{
    //this will cause an error as it has no expression at all
    PrefixCalc exp1("");
    exp1.printResult();

    //This does 1 + 2
    PrefixCalc exp2("+1 2");
    //it will print out 3
    exp2.printResult();

    //this is (1/2)/0, which will cause an error due to divison by 0
    PrefixCalc exp3("//120");
    exp3.printResult();

    //this is going to be a valid expression
    PrefixCalc exp4("*2/+21*34");
    exp4.printResult();

    //this will cause an error as there will be >1 element left in stack at the end when it is trying to pass the result in
    PrefixCalc exp5("1+23");
    exp5.printResult();

    //this will cause an error due to "x" making it an invalid expression
    PrefixCalc exp6("1x0+10");
    exp6.printResult();

    //this is doing 4/2 + 8/4
    PrefixCalc exp7("+/42/84");
    exp7.printResult();

    //this is doing ((2+1) * 3) - 9
    PrefixCalc exp8("-*+2139");
    exp8.printResult();

    //this is doing (9+1) * (2+0)
    PrefixCalc exp9("*+91 + 20");
    exp9.printResult();

    //this is doing (2+3)*4
    PrefixCalc exp10("*+234");
    exp9.printResult();

    //this is doing 2*(3+4)
    PrefixCalc exp11("*2+34");
    exp11.printResult();

}
