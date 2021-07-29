#include <iostream>
#include <time.h>
#include <algorithm>
//timing things
#include <chrono>
using std::chrono::system_clock;
using std::chrono::steady_clock;
using std::chrono::duration_cast;
using std::chrono::seconds;
using std::chrono::milliseconds;

template <typename Func> long long TimeFunc(Func f);
template <class T> void bubbleSort(T* arr, int SIZE);
template <class T> void selectionInsertionSort(T* arr, int size);

int main()
{
    srand((unsigned)time(nullptr));
 
    int* arr1 = new int[100000];
    int* arr2 = new int[100000];
    int* arr3 = new int[100000];

    //fill the arrays with 10K numbers between 0-499
    for (int i = 0; i < 100000; i++) {
        arr1[i] = arr2[i] = arr3[i] = rand() % 1000;
    }

    //going to compare with my bubble sort from QUESTION 4 and std::sort built in sort
    auto selInsSortmilliseconds = TimeFunc([&]() { selectionInsertionSort(arr1, 100000); });
    auto bubbleSortmilliseconds = TimeFunc([&]() {bubbleSort(arr2, 100000); });
    auto sortmilliseconds = TimeFunc([&]() {std::sort(arr3, arr3 + 100000); });

    std::cout << "SelectionInsertion multisort: " << selInsSortmilliseconds << "ms\n";
    std::cout << "Bubblesort: " << bubbleSortmilliseconds << "ms\n";
    std::cout << "Alg. library sort: " << sortmilliseconds << "ms\n";


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
//this will sort the first 95% of the array via selection sort, and then rest via insertion sort
void selectionInsertionSort(T* arr, int size) {

    //this part does the selection sort, doing it for the majority as requires fewer swaps overall
    //iterates from start array to position of element just before the position that ends the 95% range
    for (int i = 0; i < (int)size * 0.95; i++) {
        //sets a minIndex to i, this is the element we are trying to sort currently
        int minIndex = i;
        //iterate from directly after that element to the end of the subset of the array
        for (int j = i + 1; j < (int)size * 0.95; j++) {
            //if the element at the minIndex is larger than element at j, make minIndex j
            if (arr[minIndex] > arr[j])
                minIndex = j;
        }
        //if minIndex changed, swap them, so that new smallest is at position i
        if (minIndex != i)
            std::swap(arr[minIndex], arr[i]);
    }

    //does insertion sort for the rest as a) it works better in mostly sorted lists and b) it works better the smaller the list is
    //this is largely just copied from QUESTION 4
    for (int i = (int)size * 0.95; i < size; i++) {
        //starts inner loop at index currently unsorted element is at
        for (int j = i; j != 0; j--) {
            //if current array element is less than prior element
            if (arr[j] < arr[j - 1])
                //swap them to move the smaller element to the right
                std::swap(arr[j], arr[j - 1]);
        }
    }   
}

//BUBBLE SORT FROM Q4 FOR COMPARISONS
template <class T>
void bubbleSort(T* arr, int SIZE) {

    //checks if any sorts have occured in an iteration
    bool sortedFlag = false;

    //iterates through the array up to the amount of elements it contains (to ensure every element gets sorted)
    for (int i = 0; i < SIZE; i++) {
        //sets flag to false
        sortedFlag = false;
        //sets j to be start of unsorted part of array, then iterates through unsorted part to sort it, and stops when it would reach sorted part
        for (int j = 0; j < SIZE - 1 - i; j++) {
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
