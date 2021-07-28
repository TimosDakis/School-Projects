#include <iostream>
#include <utility>
#include <time.h>
#include <assert.h>
//timing things
#include <chrono>
using std::chrono::system_clock;
using std::chrono::steady_clock;
using std::chrono::duration_cast;
using std::chrono::seconds;
using std::chrono::milliseconds;

//LINKED LIST STUFF
template <class T>
struct Node {
    T data;
    Node<T>* next;
};

template<class T>
class List_Iterator {
private:
    Node<T>* current;

public:
    //constructor, by default will set current to nullptr
    List_Iterator(Node<T>* ptr = nullptr) : current(ptr) {}

    //operator* overload
    T& operator*() {
        //returns current's data
        return current->data;
    }

    //operator++ overload
    List_Iterator operator++() {
        //goes to next node then returns the iterator
        current = current->next;
        return *this;
    }

    List_Iterator operator+ (int jump) {
        //loop through jump amount of times
        for (int i = 0; i < jump; i++) {
            //if current is nullptr through an out of range exception because the wanted position is out of bounds
            if (current == nullptr)
                throw std::out_of_range("Inserted value is out of the list boundary");
            //else make current the next node
            current = current->next;
        }
        return *this;
    }

    //operator== and operator!= overloads
    bool operator==(const List_Iterator& other) const {
        //returns true if same addresses
        return (current == other.current);
    }
    bool operator!=(const List_Iterator& other) const {
        //returns true if addresses not the same 
        return (current != other.current);
    }
};

template<class T>
class Linked_List {
private:
    int length;
    Node<T>* first, * last;

public:
    //default constructor
    Linked_List() {
        //sets first and last to both point to nullptr, and length to 0
        first = last = nullptr;
        length = 0;
    }

    //copy constructor
    Linked_List(const Linked_List<T>& otherList) {
        //set first to nullptr then call copyList
        first = nullptr;
        copyList(otherList);
    }

    //move constructor
    Linked_List(Linked_List<T>&& otherList) noexcept {
        //if other list is not empty, set the first, last, and length to other list's versions so it now points to that list
        if (otherList.first != nullptr) {
            first = otherList.first;
            last = otherList.last;
            length = otherList.length;
            otherList.first = otherList.last = nullptr;
        }
    }

    //operator= overload
    Linked_List& operator=(const Linked_List<T>& otherList) {
        //if the lists are not the same, copy it via copyList
        if (this != &otherList) {
            copyList(otherList);
        }
        return *this;
    }

    //move assignment operator
    Linked_List& operator=(Linked_List<T>&& otherList) noexcept {
        //delete contents of current length
        deleteList();
        //if other list is not empty, set the first, last, and length to other list's versions so it now points to that list
        if (otherList.first != nullptr) {
            first = otherList.first;
            last = otherList.last;
            length = otherList.length;
            otherList.first = otherList.last = nullptr;
        }
        return *this;
    }


    //appends new node with T data after given pos
    void appendTo(T data, int pos) {
        //checks if position is greater than size of the array, or less than 1 less than first position
        if (pos > length || pos < -1) {
            //if true outputs error message and returns
            std::cout << "Invalid position given\n";
            return;
        }

        Node<T>* newNode = new Node<T>;
        newNode->data = data;
        Node<T>* current = first;

        //this is the case for inserting to first pos
        if (pos == -1) {
            //make newNode link to first
            newNode->next = first;
            //set newNode to be first
            first = newNode;
            //increase length
            length++;
            //if the list empty, then make last newNode too
            if (last == nullptr)
                last = newNode;
            return;
        }

        //this is case for inserting after last pos (and getting new last as a result)
        else if (pos == length) {
            //link newNode to nullptr as it will be new end
            newNode->next = nullptr;

            //if list is empty set both first and last to newNode
            if (first == nullptr)
                first = last = newNode;

            //otherwise chain last to newNode then set newNode to be last
            else {
                last->next = newNode;
                last = newNode;
            }
            length++;
            return;
        }
        else {
            for (int i = 0; i < pos; i++)
                //just an error check to ensure current does not become nullptr, it should not ever though
                if (current->next != nullptr)
                    //set current to next thing in list
                    current = current->next;
        }
        //when it has reached correct position, will insert newNode between current and nextNode to get into (pos+1)th position in list
        newNode->next = current->next;
        current->next = newNode;
        length++;
    }

    //to insert at first or last just calls appendTo function at correct pos value
    void insertFirst(T data) {
        appendTo(data, -1);
    }

    void insertLast(T data) {
        appendTo(data, length);
    }

    //retrieves data at pos (reads data at that index)
    T dataAt(int pos) {
        //if pos is out of bounds, displays error message then exits function
        if (pos > length || length < 0) {
            std::cout << "Invalid position entered";
            return;
        }

        //if list is empty output error message then return
        //this to cover case pos = 0, but list is empty
        if (first == nullptr) {
            std::cout << "List empty - no data to return";
            return;
        }

        Node<T>* current = first;

        //loops through list until gets to correct position
        for (int i = 0; i < pos; i++) {
            current = current->next;
        }

        //returns the data
        return current->data;
    }

    //retrieves first data in list
    T getFirst() {
        //checks if list is not empty
        assert(first != nullptr);
        return first->data;
    }
    
    //retrieves last data in list
    T getLast() {
        //checks if list is not empty
        assert(last != nullptr);
        return last->data;
    }

    void deleteItem(const T& toDelete) {
        Node<T>* current, * trailCurrent;
        bool found = false;

        //If list is empty, output error then exit function
        if (first == nullptr) {
            std::cout << "ERROR: List is empty";
            return;
        }

        //If node to be deleted is the first node
        if (first->data == toDelete) {

            //make current first node
            current = first;
            //set first node to second node
            first = first->next;
            //decrease length
            length--;

            //if first was only node, and now list is empty, sent last to nullptr
            if (first == nullptr)
                last = nullptr;

            //delete the node
            delete current;
        }

        else {
            //set traiCurrent to first, and current to 2nd node
            trailCurrent = first;
            current = first->next;

            //loops while current is not nullptr and the item has not been found
            while (current != nullptr && !found) {
                //if current's data does not much object to be deleted, go to next respective nodes
                if (current->data != toDelete) {
                    trailCurrent = current;
                    current = current->next;
                }
                //if found, set found to true to break out of loop
                else
                    found = true;
            }

            //if found
            if (found) {

                //set trailCurrent to link to the node after current
                trailCurrent->next = current->next;
                //decrease length
                length--;

                //if the object is located in the last node of list, set last to be the node before
                if (last == current)
                    last = trailCurrent;

                delete current;
            }
            else
                std::cout << "Item was not in list";

        }
    }

    //deletes entire list
    void deleteList() {
        Node<T>* temp;

        //loops while first node is not nullptr
        while (first != nullptr) {
            //set temp to the current first
            temp = first;
            //set first to node after first
            first = first->next;
            //delete temp
            delete temp;
        }
        //set last to nullptr too
        last = nullptr;
        length = 0;
    }

    //destructor
    ~Linked_List() {
        deleteList();
    }

    //returns iterator to start of the list
    List_Iterator<T> begin() {
        List_Iterator<T> start(first);
        return start;
    }

    //returns iterator to end of the list
    List_Iterator<T> end() {
        List_Iterator<T> end(last);
        return end;
    }

    //returns true if list is empty
    bool isEmpty() {
        return (first == nullptr);
    }

    //returns size of list
    int getLength() {
        return length;
    }

    //copies list
    void copyList(const Linked_List<T> & other) {
        Node<T>* current, *newNode;

        //if list is not empty, delete it
        if (first != nullptr) {
            deleteList();
        }

        //if other list is empty, just set first and last to nullptr
        if (other.first == nullptr) {
            first = last = nullptr;
            length = 0;
        }
        else {
            //set current to the other list's first, likewise make the lengths the same
            current = other.first;
            length = other.length;

            //create a new node to store at first and copy over data
            first = new Node<T>;
            first->data = current->data;
            //set it to link to nullptr, then set last to the node too
            first->next = nullptr;
            last = first;

            current = current->next;

            while (current != nullptr) {
                //create a new node with the correct data from other list
                newNode = new Node<T>;
                newNode->data = current->data;
                //link it to nullptr
                newNode->next = nullptr;

                //add it to end of list, then set newNode to be last node
                last->next = newNode;
                last = newNode;

                //go to next node of other list
                current = current->next;
            }
        
        }

    
    }

    //searches to see if object is in list
    bool searchFor(const T& toFind) {

        //checks if the object is in either first or last node
        if (first->data == toFind || last->data == toFind) {
            return true;
        }
        else {
            Node<T>* current = first->next;
            //loop until end, return true if item found
            while (current != nullptr) {
                if (current->data == toFind)
                    return true;
                else
                    current = current->next;
            }
            
        }
        //item not found
        return false;
      
    }

    void printList() {
        Node<T>* current = first;
        int counter = 0;
        while (current != nullptr) {
            std::cout << current->data << " ";
            current = current->next;
            counter++;
            if (counter == 5) {
                std::cout << std::endl;
                counter = 0;
            }
        }
    }
    

};

//VECTOR STUFF
template <class T>
class Vector_Iterator {
private:
    //pointer to current locaion within vector;
    T* currLoc;

public:
    //Constructor, defaults to nullpt
    Vector_Iterator(T* arr = nullptr) : currLoc(arr)  { }

    //operator++ overload
    Vector_Iterator operator++() {
        if (currLoc != nullptr)
            //if currLoc is initialized, make it go to next point in memory
            currLoc += 1;
        return *this;
    }

    //operator + override
    Vector_Iterator operator + (int jump) {
        //set iterator to the jumpth element ahead
        currLoc += jump;
        return *this;
    }

    //operator* overload
    T& operator*() {
        return *currLoc;
    }

    //operator== overload
    bool operator==(const Vector_Iterator & other) {
        //return true if the addresses are equal
        return (currLoc == other.currLoc);
    }

    //operator!= overload
    bool operator!=(const Vector_Iterator& other) {
        //return true if the addresses are equal
        return (currLoc != other.currLoc);
    }
};

template <class T>
class Vector {

private:
    T* arr = nullptr;
    int totalCapacity, totalElements;

public:
    //constructor
    Vector(int totalCapacity = 10) {
        //checks if capacity is invalid
        if (totalCapacity < 0) {
            //if invalid output error and make user resubmit
            std::cout << "Cannot have a negative capacity, input a new one: ";
            std::cin >> totalCapacity;
        }
        this->totalCapacity = totalCapacity;
        //create an array of size totalCapacity and set totalElements to 0
        arr = new T[totalCapacity];
        totalElements = 0;
    }

    //copy constructor
    Vector(const Vector& otherVec) {
        //calls copyVector
        copyVector(otherVec);
    }
    //move constructor
    Vector(Vector&& otherVec) noexcept {
        //move the data over
        this->totalElements = otherVec.totalElements;
        this->totalCapacity = otherVec.totalCapacity;
        //move the array over
        arr = otherVec.arr;
        //set otherVec's array to nullptr
        otherVec.arr = nullptr;
    
    }

    //operator= overload
    Vector& operator=(const Vector& otherVec) {
        //if vectors are not the same, copy it over
        if (this != &otherVec)
            copyVector(otherVec);
        return *this;
    }
    
    //move assignment operator
    Vector& operator=(Vector&& otherVec) noexcept {
        //make sure to clear anything array currently points to
        delete[]arr;
        //move data over
        this->totalElements = otherVec.totalElements;
        this->totalCapacity = otherVec.totalCapacity;
        //sets array to other array
        arr = otherVec.arr;
        //sets other array to nullptr
        otherVec.arr = nullptr;
        
        return *this;
    }

    //destructor
    ~Vector() {
        delete[]arr;
    }


    //returns an iterator to start of the vector
    Vector_Iterator<T> begin() {
        //if Vector is empty throw an exception
        if (totalElements == 0)
            throw std::out_of_range("Vector has no elements");
        Vector_Iterator<T> start(arr);
        return start;
    }

    //returns an iterator to the end of the vector
    Vector_Iterator<T> end() {
        //if Vector is empty throw an exception
        if (totalElements == 0)
            throw std::out_of_range("Vector has no elements");
        //else returns end
        Vector_Iterator<T> last(arr + totalElements-1);
        
        return last;
    }

    //returns number of elements in vector
    int size() {
        return totalElements;
    }

    //returns total capacity of vector
    int getCapacity() {
        return totalCapacity;
    }

    //changes capacity
    void resize(int size) {
        if (size < 0) {
            std::cout << "ERROR: Cannot have negative capacity\n";
        }

        //if new capacity is smaller than total elements in vector
        if (size < totalElements) {
            //set totalElements to new capacity, effectively shrinking the vector and deleting extra elements
            totalElements = size;
        }
        //change capacity to new size
        totalCapacity = size;
        //create a temp vector then copy all current values to it
        Vector<T> temp(*this);
        //then assign temp to current vector
        *this = std::move(temp);
        //this updates capacity of vector to correct capacity

    }
    

    //copies other vector
    void copyVector(const Vector& other) {
        //sets capacity and elements to other vector's
        totalCapacity = other.totalCapacity;
        totalElements = other.totalElements;
        //clear the vector
        clearVector();
        //if the other vector has elements, transfer them
        if (other.totalElements != 0) {
            for (int i = 0; i < totalElements; i++) {
                arr[i] = other.arr[i];
            }
        }
    }

    //swaps vectors
    void swapVectors(Vector& other) {
        //creates a temp vector and moves current vector into it
        Vector<T> temp(std::move(*this));
        //sets other vector to this vector
        *this = std::move(other);
        //sets temp (containing this vector) into other
        other = std::move(temp);
    }

    //this will clear the entire vector
    void clearVector() {
        //deletes the current array then creates a new one
        delete[]arr;
        arr = new T[totalCapacity];
    
    }

    void isEmpty() {
        return (totalElements == 0);
    }

    //shrinks capacity to match number of elements;
    void shrinkToFit() {
        //calls resize to recreate the vector with new shrunk capacity
        resize(totalElements);
    }

    //returns data at certain position (starts at 0)
    T dataAt(int pos) {

        if (pos >= totalElements || pos < 0) {
            throw std::out_of_range("The input position is out of bounds");
        }
        //returns the data in the posth slot
        return *(arr + pos);
    }

    //overloading []
    T operator[](int pos){
        //calls dataAt and returns correct object
        return dataAt(pos);
    }


    //returns data at start of vector
    T frontData() {
        //throws exception if there are no elements
        if (totalElements != 0)
            throw std::out_of_range("Vector is empty.");
        return *arr;
    }

    //returns data at end of vector
    T endData() {
        //throws exception if there are no elements
        if (totalElements == 0)
            throw std::out_of_range("Vector is empty.");
        return *(arr + totalElements - 1);
    }

    //pushes data onto the end of the vector
    void push_back(T data) {
        //if adding a new element will put it over capacity, resize the vector to be twice as big
        if (totalElements + 1 > totalCapacity)
            resize(totalCapacity * 2);

        //adds the data to the end then increases element count
        *(arr + totalElements++) = data;
    
    }

    //deletes element at end of the vector
    void pop_back() {
        //checks if vector, if it is output error
        if (totalElements == 0) {
            std::cout << "Cannot pop_back an empty vector";
        }
        //otherwise decrease totalElements size, effectively "popping" the back off the vector
        else 
            totalElements--;
    
    }

    void print() {
        int newLineCounter = 0;
        for (int i = 0; i < totalElements; i++) {
            std::cout << "i: " << i << " value: " << arr[i] << " ";
            if (++newLineCounter == 5) {
                std::cout << std::endl;
                newLineCounter = 0;
            }
        }
    
    }

};

template <typename Func> long long TimeFunc(Func f);
template <class T> void fillVector(Vector<T>& vec, T* arr, int size);
template <class T> void fillList(Linked_List<T>& list, T* arr, int size);

int main()
{

    int const SIZE = 10000;
    srand((unsigned)time(nullptr));
    //inserting with random numbers
    Linked_List<int> list1;
    Vector<int> vec1;
    //filling an array w/ random numbers
    int randNumber[SIZE];
    for (int i = 0; i < SIZE; i++) {
        randNumber[i] = rand() % 10000;
    }

    //inserting random strings
    Linked_List<std::string> list2;
    Vector<std::string> vec2;
    //filling an array w/ random strings of up to size 10
    std::string randString[SIZE] = {};
    std::string randString2[SIZE] = {};
    for (int i = 0; i < SIZE; i++) {
        //random string will be at most 10 long
        for (int j = 0; j < 10; j++) {
            randString[i] += (char)(rand() % 128);
        }
        //add to the second array
        randString2[i] = randString[i];
    }
    Linked_List<std::string> list3;
    Vector<std::string> vec3;

    //Timing random number insertion
    auto vectormilliseconds1 = TimeFunc([&]() {fillVector<int>(vec1, randNumber, SIZE); });
    auto listmilliseconds1 = TimeFunc([&]() {fillList<int>(list1, randNumber, SIZE); });

    std::cout << "RANDOM NUMBER INSERTION\nVector time: " << vectormilliseconds1 << "\nList time: " << listmilliseconds1 << std::endl;

    //Timing random string insertion
    auto vectormilliseconds2 = TimeFunc([&]() {fillVector<std::string>(vec2, randString, SIZE); });
    auto listmilliseconds2 = TimeFunc([&]() {fillList<std::string>(list2, randString2, SIZE); });

    std::cout << "RANDOM STRING INSERTION\nVector time: " << vectormilliseconds2 << "\nList time: " << listmilliseconds2 << std::endl;

    //Timing random string insertion w/ move semantics
    auto vectormilliseconds3 = TimeFunc([&]() {fillVector<std::string>(vec3, std::move(randString), SIZE); });
    auto listmilliseconds3 = TimeFunc([&]() {fillList<std::string>(list3, std::move(randString2), SIZE); });

    std::cout << "RANDOM STRING INSERTION w/ MOVE SEMANTICS\nVector time: " << vectormilliseconds1 << "\nList time: " << listmilliseconds1 << std::endl;

    
}

template <typename Func>
long long TimeFunc(Func f)
{
    auto begin = steady_clock::now();
    f();
    auto end = steady_clock::now();

    return duration_cast<milliseconds>(end - begin).count();
}

//fills the vector with the given array
template <class T>
void fillVector(Vector<T>& vec, T* arr, int size) {
    for (int i = 0; i < size; i++) {
        vec.push_back(arr[i]);
    }
}

//fills the list with the given array
template <class T> 
void fillList(Linked_List<T>& list, T* arr, int size) {
    for (int i = 0; i < size; i++) {
        list.insertLast(arr[i]);
    }
}

