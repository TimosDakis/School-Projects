#include <iostream>
#include <algorithm>
#include <cassert>


//arrayBasedStack FROM QUESTION 3
template <class dataType>
class arrayBasedStack {

private:
    //pointer variable that will point to array holding data, set to nullptr by default
    dataType* stack = nullptr;
    //variables to store max size of stack, and to refer to top of stack
    int maxStackSize, stackTop;

public:
    //constructor, defaults to size of 50
    arrayBasedStack(int maxStackSize = 50) {
        //validity check to ensure only non-negative values can be passed for size
        if (maxStackSize < 0) {
            std::cout << "ERROR: Stack size cannot be less than 0\n";
            std::cout << "Input new size: ";
            std::cin >> maxStackSize;
            //if invalid type inputted, clear internally to show there is no error
            std::cin.clear();
            //clear rest of the line to ensure no errors occur if multiple values inputted at the cin 
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        }

        //move the maxSize into the objects variable
        this->maxStackSize = maxStackSize;
        //create the array that will hold the data
        stack = new dataType[maxStackSize];

        //initialize the stack
        initialize();
    } //end constructor

    //copy constructor
    arrayBasedStack(const arrayBasedStack& other) {
        //calls copyStack to copy information from other stack
        copyStack(other);
    }

    //move constructor
    arrayBasedStack(arrayBasedStack&& other) noexcept {

        //copies over the variables
        this->maxStackSize = other.maxStackSize;
        this->stackTop = other.stackTop;

        //changes the pointers so current stack points to data, and other stack points to nullptr for safety
        stack = other.stack;
        other.stack = nullptr;

    } //end move constructor

    //assignment operator
    arrayBasedStack& operator=(const arrayBasedStack& other) {

        //only execute if not same object
        if (this != &other)
            //copy other stack over wanted range
            copyStack(other);

        return *this;
    } //end operator=

    arrayBasedStack& operator=(arrayBasedStack&& other) noexcept {

        //deletes anything currently stored in pointer
        delete[]stack;

        //copies over the variables
        this->maxStackSize = other.maxStackSize;
        this->stackTop = other.stackTop;

        //changes the pointers so current stack points to data, and other stack points to nullptr for safety
        stack = other.stack;
        other.stack = nullptr;

        return *this;

    } //end move assignment operator

    //destructor
    ~arrayBasedStack() {
        //deletes info stored in pointer
        delete[]stack;
    } //end destructor

    //maxStackSize getter
    int getMaxStackSize() {
        return maxStackSize;
    } //end getMaxStackSize

    //initializes stack
    void initialize() {
        //sets stackTop to 0 (also means if there was anything in stack before it will now be ignored, effectively reinitializng it too)
        stackTop = 0;
    } //end initialize

    //checks if empty
    bool isEmpty() {
        //is true if stackTop is 0 which means nothing is in stack, else false
        return (stackTop == 0);
    } //end isEmpty

    //checks if full
    bool isFull() {
        //is true if stackTop is equal to maxStackSize meaning it is a full stack, else false
        return (stackTop == maxStackSize);
    }  //end isFull

    void push(const dataType& data) {

        //if stack is not full, add it then increase stackTop by 1
        if (!isFull())
            stack[stackTop++] = data;
        //else output an error message
        else
            std::cout << "ERROR: Cannot add new data into a full stack.\n";


    } //end push

    dataType peekTop() {

        //terminates if empty
        assert(!isEmpty());

        //if not empty return data stored at index that is 1 before stackTop (as stackTop will always be pointing to first empty slot)
        return stack[stackTop - 1];

    } //end peekTop

    void pop() {

        //if stack is not empty
        if (!isEmpty())
            //decrease stackTop by 1 (this ignores the old data on top, essentially "deleting" it since it can no longer be accessed, and will be potentially overwritten in future)
            stackTop--;
        //else output error messue
        else
            std::cout << "ERROR: Cannot pop off an empty stack.\n";

    } //end pop

    //copies over another stack
    void copyStack(const arrayBasedStack& other) {

        //delete whatever is info is in current stack (to avoid memory leaks)
        delete[]stack;
        //sets max size to max size of other stack
        maxStackSize = other.maxStackSize;
        //create a new dynamic array to act as stack of max stack size of other array
        stack = new dataType[maxStackSize];
        //initialize the stack
        initialize();

        //loops until it copies over all elements from other stack
        for (int i = 0; i < other.stackTop; i++, stackTop++) {
            stack[i] = other.stack[i];
        }

    } //end copyStack

    //swaps the stacks
    void swap(arrayBasedStack& otherStack) {
        //create a temp pointer to point to otherStacks array
        dataType* tempPtr = std::move(otherStack.stack);
        //then swap the arrays
        otherStack.stack = std::move(stack);
        stack = std::move(tempPtr);

        //create a temp integer to store otherStacks maxStackSize
        int tempInt = otherStack.maxStackSize;
        //then swap the maxStackSizes
        otherStack.maxStackSize = maxStackSize;
        maxStackSize = tempInt;

        //do the same for the stackTop value
        tempInt = otherStack.stackTop;
        otherStack.stackTop = stackTop;
        stackTop = tempInt;

    } //end swap


    //This printStack function satisfies 4a

    //prints stack, by default prints 5 per line
    void printStack(int numPerRow = 5) {

        //if empty says so
        if (isEmpty()) {
            std::cout << "Stack is empty.\n";
        }
        //else
        else {
            //set up a counter
            int count = 0;
            //go through stack to print things from top to bottom
            for (int i = stackTop; i != 0;) {
                std::cout << stack[--i];
                //if count reaches number per row limit, add a newline, then reset count
                if (++count == numPerRow) {
                    std::cout << std::endl;
                    count = 0;
                }
                //else just input a whitespace
                else
                    std::cout << " ";
            } //end for 
            //if count is not 0, add a new line after for loop has finished (if = 0, then new line was just done)
            if (count != 0)
                std::cout << std::endl;
        } //end else


    } //end printStack

    //4b

    void changePos(int pos, const dataType& newData) {
        //if position is outside bounds of the stack, output an error
        if (pos < 0 || pos >= stackTop) {
            std::cout << "ERROR: Cannot change a position outside the bounds of the stack.\n";
        }
        //else input the new data at that position
        else
            stack[pos] = newData;

    
    }

};

int main()
{   
    //create a test stack and fill it with numbers 1 to 10 in that order
    arrayBasedStack<int> testStack(10);
    for (int i = 1; i <= 10; i++) {
        testStack.push(i);
    }
    
    //will print the stack as: 10 9 8 7 6 5 4 3 2 1
    testStack.printStack();

    //changes the 4 with a 100
    testStack.changePos(3, 100);

    //now prints stack as: 10 9 8 7 6 5 100 3 2 1
    testStack.printStack();
}
