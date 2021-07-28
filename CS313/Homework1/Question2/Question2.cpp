#include <iostream>
#include <assert.h>
#include <time.h>
#include <algorithm>
//timing things
#include <chrono>
using std::chrono::system_clock;
using std::chrono::steady_clock;
using std::chrono::duration_cast;
using std::chrono::seconds;
using std::chrono::microseconds;


//LINKED LIST STUFF from Question 1
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
    void copyList(const Linked_List<T>& other) {
        Node<T>* current, * newNode;

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

    //LINKED BINARY SEARCH FOR QUESTION 2
    //takes a left and right value, then see if target is within that range inclusive (assumed zero-based indexing)
    bool linkedBinarySearch(int left, int right, T target) {

        if (left >= length || right >= length || left < 0 || right < 0)
            throw std::invalid_argument("Error: Left or Right are out of bounds of the list");

        //middle element
        int mid;
        Node<T>* current;
        //while right is >= than left keep looping
        //this means once right < left or left > right the loop breaks (as item is not found, as it starts overlapping to other section of list where value is not at)
        while (right >= left) {
            //set current to first node
            current = first;
            //middle element is the middle of left and right
            mid = (left + right) / 2;
            //loop until you reach middle node
            for (int i = 0; i < mid; i++)
                current = current->next;

            //if current data is target return true
            if (current->data == target)
                return true;

            //else if next node is nullptr (end of list) OR target is smaller than next node's value
            else if (current->next == nullptr || target < current->next->data)
                //set right to 1 before the mid, as the target cannot be after
                right = mid - 1;
            //otherwise set left to after mid (as target cannot be before)
            else
                left = mid + 1;
        }
        return false;
    

    
    }


};

template <typename Func> long long TimeFunc(Func f);
template <class T> bool iterativeBinarySearch(T* arr, int left, int right, T target);
template <class T> bool recursiveBinarySearch(T* arr, int left, int right, T target);


int main()
{

    srand((unsigned)time(nullptr));

    //two arrays to compare the different searches at differnt magnitutde of capacity
    int* testArray1 = new int[1000000];
    int* testArray2 = new int[10000000];

    //fill the million slots with numbers between 0-999
    for (int i = 0; i < 1000000; i++)
        testArray1[i] = rand() % 1000;

    //fill the 10 million slots with numbers between 0-9999
    for (int i = 0; i < 10000000; i++)
        testArray2[i] = rand() % 10000;

    //sorts the arrays
    std::sort(testArray1, testArray1 + 100000);
    std::sort(testArray2, testArray2 + 1000000);

    //these are lists that will be used in the linked list based binary sorts
    Linked_List<int> testList1;
    Linked_List<int> testList2;


    //fills both lists with the numbers in the sorted order
    for (int i = 0; i < 1000000; i++)
        testList1.insertLast(testArray1[i]);
    for (int i = 0; i < 10000000; i++)
        testList2.insertLast(testArray2[i]);

    //the target to be found in the first array by the searches, random number between 0-999
    int target1 = rand() % 1000;

    //the target to be found in second test array by the searches, random number between 0-9999
    int target2 = rand() % 10000;

    //set up the timing tests next

    //timing linked binary search on 1M and 10M elements
    auto LBSmicroseconds1 = TimeFunc([&]() {testList1.linkedBinarySearch(0, 99999, target1); });
    auto LBSmicroseconds2 = TimeFunc([&]() {testList2.linkedBinarySearch(0, 999999, target2);  });

    //timing iterative binary search on 1M and 10M elements
    auto IBSmicroseconds1 = TimeFunc([&]() {iterativeBinarySearch(testArray1, 0, 99999, target1); });
    auto IBSmicroseconds2 = TimeFunc([&]() {iterativeBinarySearch(testArray2, 0, 999999, target2); });



    //timing recursive binary search on 1M and 10M elements
    auto RBSmicroseconds1 = TimeFunc([&]() {recursiveBinarySearch(testArray1, 0, 99999, target1); });
    auto RBSmicroseconds2 = TimeFunc([&]() {recursiveBinarySearch(testArray2, 0, 999999, target2); });

    std::cout << "LINKED BINARY SEARCH\n" << "It took " << LBSmicroseconds1 << " microsec. to run a search for " << target1 << " when there are 1M elements\n";
    std::cout << "It took " << LBSmicroseconds2 << " microsec. to run a search for " << target2 << " when there are 10M elements\n";

    std::cout << "ITERATIVE BINARY SEARCH\n" << "It took " << IBSmicroseconds1 << " microsec. to run a search for " << target1 << " when there are 1M elements\n";
    std::cout << "It took " << IBSmicroseconds2 << " microsec. to run a search for " << target2 << " when there are 10M elements\n";

    std::cout << "RECURSIVE BINARY SEARCH\n" << "It took " << RBSmicroseconds1 << " microsec. to run a search for " << target1 << " when there are 1M elements\n";
    std::cout << "It took " << RBSmicroseconds2 << " microsec. to run a search for " << target2 << " when there are 10M elements\n";


}


//timing function
template <typename Func>
long long TimeFunc(Func f)
{
    auto begin = steady_clock::now();
    f();
    auto end = steady_clock::now();

    return duration_cast<microseconds>(end - begin).count();
}

//does an iterative binary search
template <class T> bool iterativeBinarySearch(T* arr, int left, int right, T target) {

    //mid value
    int mid;

    //Loop while right >= left, if not break out because now you would start double counting sides (meaning item was not found)
    while (right >= left) {

        //set mid between right and left
        mid = (right + left) / 2;

        //if the element located at the mid index is the target, return true
        if (arr[mid] == target)
            return true;

        //else if the target if greater than this element return left = mid + 1, as it would not be in the lower half of the array
        else if (target > arr[mid])
            left = mid + 1;

        //otherwise set right to mid - 1, since target is smaller than the right half of the array
        else 
            right = mid - 1;
    }

    //return false if nothing is found
    return false;

}

//does a recursive binary search
template <class T> bool recursiveBinarySearch(T* arr, int left, int right, T target) {

    //set mid index to the middle
    int mid = (right + left) / 2;

    //if element at mid index is target return true
    if (arr[mid] == target)
        return true;

    //if left is greater than right return false, as this means no item could be found and it will stall to overlap
    if (left > right)
        return false;

    //if target is less than the mid element
    if (target < arr[mid])
        //call function again, but set right to 1 before mid, since everything on the other half would be larger than it
        return recursiveBinarySearch<T>(arr, left, mid-1, target);
    //else if target is greater than mid element
    else if (target > arr[mid])
        //call function again, but set left to 1 after mid, since everything on other half would be smaller than it
        return recursiveBinarySearch<T>(arr, mid+1, right, target);

}