#include <iostream>
#include <time.h>
#include <utility>

template <class T> void bubbleSort2d(T** arr, int SIZE);
template <class T> void insertionSort2d(T** arr, int SIZE);
template <class T> void selectionSort2d(T** arr, int SIZE);

int main()
{
    srand((unsigned)time(nullptr));

    //size of the n x n matrix
    const int SIZE = 5;

    //sets up an array for each sort we are comparing that can contain n pointers, it is the n rows of the n x n matrix
    int** bubbleSortMatrix = new int* [SIZE];
    int** insertionSortMatrix = new int* [SIZE];
    int** selectionSortMatrix = new int* [SIZE];

    for (int row = 0; row < SIZE; row++) {
        //fills each element of each array with an array of n elements, these create the n columns of each row of the n x n matrix
        bubbleSortMatrix[row] = new int[SIZE];
        insertionSortMatrix[row] = new int[SIZE];
        selectionSortMatrix[row] = new int[SIZE];
        for (int col = 0; col < SIZE; col++) {
            //fills each element of the matrix with a random number
            *(*(bubbleSortMatrix + row) + col) = (rand() % 100);
            //ensures each array contains same numbers in same slots initially
            selectionSortMatrix[row][col] = insertionSortMatrix[row][col] = bubbleSortMatrix[row][col];
        }
    }

    std::cout << "UNSORTED MATRIX 1\n";
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++)
            std::cout << bubbleSortMatrix[i][j] << " ";
        std::cout << std::endl;
    }

    bubbleSort2d<int>(bubbleSortMatrix, SIZE);

    std::cout << std::endl;

    std::cout << "SORTED MATRIX 1: BUBBLE SORT\n";
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++)
            std::cout << bubbleSortMatrix[i][j] << " ";
        std::cout << std::endl;
    }

    std::cout << "=================================\n";

    std::cout << "UNSORTED MATRIX 2\n";
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++)
            std::cout << insertionSortMatrix[i][j] << " ";
        std::cout << std::endl;
    }

    insertionSort2d<int>(insertionSortMatrix, SIZE);

    std::cout << std::endl;

    std::cout << "SORTED MATRIX 2: INSERTION SORT\n";
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++)
            std::cout << insertionSortMatrix[i][j] << " ";
        std::cout << std::endl;
    }


    std::cout << "=================================\n";

    std::cout << "UNSORTED MATRIX 3\n";
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++)
            std::cout << selectionSortMatrix[i][j] << " ";
        std::cout << std::endl;
    }

    selectionSort2d(selectionSortMatrix, SIZE);

    std::cout << std::endl;

    std::cout << "SORTED MATRIX 3: SELECTION SORT\n";
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++)
            std::cout << selectionSortMatrix[i][j] << " ";
        std::cout << std::endl;
    }


}

template <class T>
void bubbleSort2d(T** arr, int SIZE) {

    //this is a flag variable to keep track of if a sort has occured in an iteration through the matrix
    bool sortFlag = true;
    //this keeps track of how large the unsorted portion of matrix is (since pushes largest element to end each iteration), starts at SIZE*SIZE given thats how many elements there are
    int unsortedSize = SIZE * SIZE;
    
    //loops while sortFlag is true, if it is ever false that means no sort occured => array is sorted
    while (sortFlag) {
        //set flag to false
        sortFlag = false;

        //loops through entire unsorted portion of array to push currently largest element to end
        for (int i = 0; i < unsortedSize - 1; i++) {
            //checks if element after is smaller than current element
            // x/SIZE gives you row position, x%SIZE gives you column position
            if (arr[(i + 1) / SIZE][(i + 1) % SIZE] < arr[i / SIZE][i % SIZE]) {
                //if true, swap them then set flag to true
                std::swap(arr[(i + 1) / SIZE][(i + 1) % SIZE], arr[i / SIZE][i % SIZE]);
                sortFlag = true;
            }
        
        }

        //decreases unsortedSize, as by now 1 more element would be in the sorted section
        unsortedSize--;
    }
    
}

template <class T> void insertionSort2d(T** arr, int SIZE) {

    //this value will be used as a temp value to track where in the matrix your unsorted value is
    int trackerValue = 0;

    //Loop until you reach SIZE*SIZE (as there are SIZE*SIZE elements in the array)
    for (int i = 1; i < SIZE*SIZE; i++) {
        //set the trackerValue to i, i is relative location of the unsorted location
        trackerValue = i;
        //loop while trackerValue is not 0 (when it is 0 that guarantees the unsorted value is now sorted, even if it finishes sorting earlier
        while (trackerValue != 0) {
            //check if the position before the current position is greater than the current position
            // x/SIZE gives you row position, x%SIZE gives you column position
            if (arr[(trackerValue - 1) / SIZE][(trackerValue - 1) % SIZE] > arr[trackerValue / SIZE][trackerValue % SIZE]) {
                //if true swap them
                std::swap(arr[(trackerValue - 1) / SIZE][(trackerValue - 1) % SIZE], arr[trackerValue / SIZE][trackerValue % SIZE]);
            }
            //decrease trackerValue regardless
            trackerValue--;
        }
    }

}

template <class T> void selectionSort2d(T** arr, int SIZE) {

    //sets up an int to store the index where smallest index is, and to store index you are comparing to rest of matrix
    int minIndex = 0, startIndex = 0;

    //loops through entire matrix, sorting element by element
    for (int i = 0; i < SIZE*SIZE; i++) {
        //set both minIndex and startIndex to i, i is the position of the currently unsorted value
        int minIndex = startIndex = i;
        //loops through everything after starting index
        for (int j = i + 1; j < SIZE*SIZE; j++) {
            //if current min position is larger than the position of matrix we are currently in
            //x/SIZE gives you row position, x%SIZE gives you column position
            if (arr[minIndex / SIZE][minIndex % SIZE] > arr[j / SIZE][j % SIZE]) {
                //make minIndex this new smallest position's index
                minIndex = j;
            }
        
        }
        //if minIndex changed at all
        if (minIndex != startIndex)
            //swap the position of the values
            std::swap(arr[minIndex / SIZE][minIndex % SIZE], arr[startIndex / SIZE][startIndex % SIZE]);
    }


}
