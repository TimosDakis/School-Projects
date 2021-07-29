#include <iostream>
#include <algorithm>
#include <cassert>

//timing things

#include <chrono>
using std::chrono::system_clock;
using std::chrono::steady_clock;
using std::chrono::duration_cast;
using std::chrono::seconds;
using std::chrono::microseconds;

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
        delete []stack;
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
    void swap(arrayBasedStack & otherStack) {
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
    
};

//make a node struct to use
template <class dataType>
struct Node {

    //data stored in node
    dataType data;

    //used for chaining to other nodes, set to nullptr by default
    Node<dataType>* link = nullptr;
};

template <class dataType>
class linkedBasedStack {

private:

    //pointer to top of stack
    Node<dataType>* stackTop = nullptr;
    //just a counter to keep track of amount of data stored in stack
    int dataCount = 0;

public:
    //constructor, just here so we have a default one
    linkedBasedStack() {

    } //end construtor

    //copy constructor
    linkedBasedStack(const linkedBasedStack& other) {
    
        //passes it into copyStack to copy stuff over
        copyStack(other);
    
    } //end copy constructor

    //move constructor
    linkedBasedStack(linkedBasedStack&& other) noexcept {
    
        //copy the data count and list over
        dataCount = other.dataCount;
        stackTop = other.stackTop;
        //then set other list to point to nullptr
        other.stackTop = nullptr;

    } //end move constructor
    //operator=
    linkedBasedStack& operator=(const linkedBasedStack& other) {
    
        //if they arent the same object, copy it over then return the stack
        if (this != &other) {
            copyStack(other);
        }
        return *this;
    
    } //end operator=

    //move assignement operator
    linkedBasedStack& operator=(linkedBasedStack&& other) noexcept {
    
        //initialize the current stack so it is empty
        initialize();

        //copy the data count and list over
        dataCount = other.dataCount;
        stackTop = other.stackTop;
        //then set other list to point to nullptr
        other.stackTop = nullptr;

        return *this;
    
    } //end move assignment operator
    
                                                             
    //destructor
    ~linkedBasedStack() {
        //calls initialize, as that deletes the entire list
        initialize();
    } //end destructor

    //initialize
    void initialize() {
    
        //while the stack is not empty, pop elements off to delete it and so initialize the stack again
        while (!isEmpty())
            pop();

    } //end initialize

    //isEmpty
    bool isEmpty() {
        //it is empty if stackTop is nullptr, else not empty
        return (stackTop == nullptr);
    } //end isEmpty

    //isFull
    bool isFull() {
        //returns false since LL does not have fixed size
        return false;
    } //end isFull

    //push
    void push(const dataType& data) {
    
        //create a new node and initialize it
        Node<dataType>* newNode = new Node<dataType>;

        //store the data
        newNode->data = data;

        //make it point to the current stackTop (this will effectively put it above)
        newNode->link = stackTop;

        //set top of the stack to be this new node now
        stackTop = newNode;

        //increase data count
        dataCount++;
    
    } //end push

    //peekTop
    dataType peekTop() {
    
        //asserts that the stack cannot be empty, if empty terminate
        assert(!isEmpty());

        //return data stored at top
        return stackTop->data;


    } //end peekTop

    //pop
    void pop() {
        
        //if note empty
        if (!isEmpty()) {

            //create a temp node that takes in stackTop node
            Node<dataType>* tempNode = stackTop;
            //make the stackTop the next node
            stackTop = stackTop->link;
            //delete the node, effectively popping it off the stack
            delete tempNode;
            //decrease dataCount
            dataCount--;

        }
        else
            std::cout << "ERROR: Cannot perform pop on an empty node.\n";
    
    } //end pop

    //copyStack, copies things in correct order (A->B->C will be copied as A->B->C not C->B->A)
    void copyStack(const linkedBasedStack& other) {
    
        //if current stack is not empty, empty it by initializing it
        if (!isEmpty())
            initialize();
        
        //if other stack is empty, make stackTop nullptr to point to nothing effectively, and thus make it empty
        if (other.stackTop == nullptr)
            stackTop = nullptr;

        else {
            //set up nodes to track current node of currnet and other stack
            Node<dataType>* current, *currentOther;
            //just a node to store new data to put into current stack
            Node<dataType>* newNode;

            //initialize a new node into stackTop
            stackTop = new Node<dataType>;
            //set current to top of other stack
            currentOther = other.stackTop;
            //add data from it to the top node of current stack
            stackTop->data = currentOther->data;
            //go to next element of other stack
            currentOther = currentOther->link;
            //sets current node to what stackTop points to so it can start keeping track of position of node in list (also means stackTop remains at top while current goes down)
            current = stackTop;

            //loop while other node still has elements to copy over
            while (currentOther != nullptr) {

                //initialize a new node
                newNode = new Node <dataType>;
                //copy over data
                newNode->data = currentOther->data;
                //set the current node in stack to link to this node
                current->link = newNode;
                //make this new node the current node now
                current = newNode;
                //go to next node in other stack
                currentOther = currentOther->link;

            } //end while loop
        } // end else

    } //end copy stack

    //swap
    void swap(linkedBasedStack& other) {

        //swaps the amount of data stored in each stack
        int tempInt;
        tempInt = other.dataCount;
        other.dataCount = dataCount;
        dataCount = tempInt;

        //swaps the pointers to topNode (this will effectively swap the lists, as the stackTop chains to rest of the list)
        Node<dataType>* tempPtr;
        tempPtr = std::move(other.stackTop);
        other.stackTop = std::move(stackTop);
        stackTop = std::move(tempPtr);
    
    }

    //prints stack, by default prints 5 per line
    void printStack(int numPerRow = 5) {
        
        //if it is empty say so
        if (isEmpty())
            std::cout << "The stack is empty.\n";
        //else print stack out top to bottom
        else {
            //make a current node to traverse stack, set to stackTop at first
            Node<dataType>* current = stackTop;
            //set up a counter to track how many things have been printed in a line
            int count = 0;
            while (current != nullptr) {
                //print data
                std::cout << current->data;
                //if count has reached numPerRow input newline
                if (++count == numPerRow) {
                    std::cout << std::endl;
                    count = 0;
                }
                //else input a whitespace
                else
                    std::cout << " ";

                //go to next node
                current = current->link;

            } //end while
            //after loop ends, if count is not 0 just output a new line (if 0 means a newline was just done)
            if (count != 0)
                std::cout << std::endl;
        
        } //end else
    
    } //end printStack
};

template <typename Func>
long long TimeFunc(Func f);

int main()
{


    //create 2 stacks for testing
    arrayBasedStack<int> arrTestStack(10000000);
    linkedBasedStack<int> linkTestStack;

    //comparing speeds of popping

    //fill both stacks with 10M elements
    for (int i = 1; i <= 10000000; i++) {
        arrTestStack.push(i);
        linkTestStack.push(i);
    }

    long long arrayPopMicroseconds = 0;
    long long linkPopMicroseconds = 0;

    //emptying both stacks by popping all elements, and keeping track of total time that takes in milliseconds
    while (!arrTestStack.isEmpty())
        arrayPopMicroseconds += TimeFunc([&]() {arrTestStack.pop(); });

    while (!linkTestStack.isEmpty())
        linkPopMicroseconds += TimeFunc([&]() {linkTestStack.pop(); });

    std::cout << "===================================================================\n";
    std::cout << "It took: " << arrayPopMicroseconds << " microseconds to pop 10M elements off an array stack.\n";
    std::cout << "It took: " << linkPopMicroseconds << " microseconds to pop 10M elements off a linked stack.\n";
    std::cout << "===================================================================\n";

    
}

template <typename Func>
long long TimeFunc(Func f)
{
    auto begin = steady_clock::now();
    f();
    auto end = steady_clock::now();

    return duration_cast<microseconds>(end - begin).count();
}