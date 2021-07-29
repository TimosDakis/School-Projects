#include <iostream>
#include <time.h>
//timing things
#include <chrono>
using std::chrono::system_clock;
using std::chrono::steady_clock;
using std::chrono::duration_cast;
using std::chrono::seconds;
using std::chrono::milliseconds;

//LINKED LIST STUFF FROM QUESTION 1
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
        std::cout << "DELETING\n";

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

    //deletes data at a given position
    void deleteAt(int pos) {

        //if list is empty, return
        if (first == nullptr) {
            std::cout << "ERROR: LIST IS OUT OF BOUNDS\n";
            return;
        }

        //if position is out of bounds return
        if (pos >= length || pos < 0) {
            std::cout << "ERROR: POSITION IS OUT OF BOUNDS\n";
            return;
        }

        Node<T>* current, * trailCurrent;

        //if position is start of list
        if (pos == 0) {
            //set current to first
            current = first;
            //set current to node after
            first = first->next;
            //decrease length
            length--;

            //if removing first node makes list empty
            if (first == nullptr)
                //set last node to nullptr too
                last = nullptr;
            //delete node
            delete current;
        }

        else {
            current = first->next;
            trailCurrent = first;

            //loop until you get to (pos)th element to delete
            for (int i = 0; i < pos-1; i++) {
                //cycle to next nodes
                current = current->next;
                trailCurrent = trailCurrent->next;
            }

            //set node before current to link to node after current
            trailCurrent->next = current->next;

            //if current is last node, make node before last node
            if (current == last)
                last = trailCurrent;


            //delete node from heap
            delete current;
            length--;

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
        std::cout << std::endl;
    }

    //QUESTION 4 STUFF

    //bubble sort
    void bubbleSort() {

        //if list is empty, return as nothing to be sorted
        if (length == 0)
            return;

        //when true, a sort has occured
        bool sortedFlag = false;

        //sets up 2 tracking nodes
        Node <T>* current, *trailCurrent;

        //loops length amount of times to ensure it is fully sorted
        for (int i = 0; i < length; i++) {
            //sets flag to false since nothing has been sorted yet
            sortedFlag = false;
            //set trailCurrent to first node, and current to node after
            trailCurrent = first;
            current = first->next;

            //iterates through unsorted part of list, ends when it reaches sorted part or if current is nullptr
            for (int j = 0; j < length - 1 - i && current != nullptr; j--) {
                //if current node is smaller than previous node
                if (current->data < trailCurrent->data) {
                    //swap their data
                    T temp = std::move(current->data);
                    current->data = std::move(trailCurrent->data);
                    trailCurrent->data = std::move(temp);
                    //set flag to true
                    sortedFlag = true;
                }
                current = current->next;
                trailCurrent = trailCurrent->next;
            }
            //if no sorts have occured, break out (since it is sorted)
            if (!sortedFlag)
                break;
        }
        
    }
    //inerstion sort
    void insertionSort() {
    
        //if list is empty, just return since nothing to sort
        if (length == 0)
            return;

        //sets up 2 tracking nodes
        Node <T>* current, * trailCurrent;

        //loops length amount of times to ensure whole thing gets sorted, starts from 2nd node, since first node will always be in correct position
        for (int i = 1; i < length; i++) {
            //set trailCurrent to first node, and current to node after
            trailCurrent = first;
            current = first->next;

            //loop to the node that needs to be sorted currently
            for (int j = 0; j < i-1; j++) {
                trailCurrent = trailCurrent->next;
                current = current->next;
            }

            //sets the currently being sorted element's position here
            int listPos = i;
            
            //if the current node is smaller than the node before
            if ( current->data < trailCurrent->data) {
                //take the data
                T toInsert = current->data;
                //delete the current node
                deleteAt(listPos);
                //set current to first
                current = first;
                //loop until you reach position of element that has just been removed (since it has to be stored somewhere in that range)
                for (int insertPos = 0; insertPos != listPos; insertPos++) {
                    //if the data is smaller than current node
                    if (toInsert < current->data) {
                        //append the node after the element before insertPos found (this puts it at relative position of insertPos)
                        appendTo(toInsert, insertPos-1);
                        break;
                    }
                    //otherwise go to next node
                    else
                        current = current->next;
                }
            }
        }



    }



};

template <typename Func> long long TimeFunc(Func f);
template <class T> void bubbleSort(T* arr, int SIZE);
template <class T> void insertionSort(T* arr, int SIZE);

int main()
{
    srand((unsigned)time(nullptr));

    int* array = new int[1000000];
    int* array2 = new int[1000000];
    Linked_List<int> list1;
    Linked_List<int> list2;
    //fill everything with the same 1M items between 0-99999
    for (int i = 0; i < 1000000; i++) {
        array[i] = rand() % 100000;
        array2[i] = array[i];
        list1.insertLast(array[i]);
        list2.insertLast(array[i]);
    }


    //timing everything
    auto bubbleSortmilliseconds = TimeFunc([&]() { bubbleSort(array, 1000000); });
    auto insertionSortmilliseconds = TimeFunc([&]() {insertionSort(array2, 1000000); });
    auto linkedBubbleSortmilliseconds = TimeFunc([&]() {list1.bubbleSort(); });
    auto linkedInsertionSortmilliseconds = TimeFunc([&]() {list2.insertionSort(); });

    std::cout << "TEST CASE: 1M RANDOM NUMBERS\n";
    std::cout << "ARRAY SORTS\nBubble sort: " << bubbleSortmilliseconds << "ms\nInsertion Sort: " << insertionSortmilliseconds << "ms\n";
    std::cout << "--------------------------\n";
    std::cout << "LINKED LIST SORTS\nBubble sort: " << linkedBubbleSortmilliseconds << "ms\nInsertion Sort: " << linkedInsertionSortmilliseconds << "ms\n";

}

template <typename Func>
long long TimeFunc(Func f)
{
    auto begin = steady_clock::now();
    f();
    auto end = steady_clock::now();

    return duration_cast<milliseconds>(end - begin).count();
}

template <class T>
void bubbleSort(T* arr, int SIZE) {

    //checks if any sorts have occured in an iteration
    bool sortedFlag = false;

    //iterates through the array up to the amount of elements it contains (to ensure every element gets sorted)
    for (int i = 0; i < SIZE; i++) {
        //sets flag to false
        sortedFlag = false;
        //sets j to be start of unsorted part of array, then iterates through unsorted part to sort it, and stops when it would reach sorted part
        for (int j = 0; j < SIZE-1-i; j++) {
            //checks if current array element is greater than the next
            if (arr[j] > arr[j + 1]) {
                //swap the values
                std::swap(arr[j], arr[j + 1]);
                //set sortedFlag to true to show atleast 1 sort has occured
                sortedFlag = true;
            }
        }
        //if no sorts occured, break (since the array is sorted)
        if (!sortedFlag)
            break;

    }

}

template <class T>
void insertionSort(T* arr, int SIZE) {

    //iterates through the array up to size times, to ensure everything gets sorted
    for (int i = 1; i < SIZE; i++) {
        //starts inner loop at index currently unsorted element is at
        for (int j = i; j != 0; j--) {
            //if current array element is less than prior element
            if (arr[j] < arr[j - 1])
                //swap them to move the smaller element to the right
                std::swap(arr[j], arr[j - 1]);
        }

    }

}