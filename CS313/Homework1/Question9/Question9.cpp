#include <iostream>
#include <vector>
#include <time.h>
#include <list>
//timing things
#include <chrono>
using std::chrono::system_clock;
using std::chrono::steady_clock;
using std::chrono::duration_cast;
using std::chrono::seconds;
using std::chrono::milliseconds;
using std::chrono::microseconds;

template <typename Func> long long TimeFuncMilli(Func f);
template <typename Func> long long TimeFuncMicro(Func f);
void createAllBitstrings(std::vector<std::vector<int>>& bitStringStorage, int currBitStringSize, int n);
void createRandomArraySequence(int* arrToRandomize, int t);
void checkArrayUntildeBruijn(int* sequence, const std::vector<std::vector<int>> subStringsToFind, int k, int t);
void mutateArray(int* arrToMutate, int t);
void createRandomListSequence(std::list<int>& listToRandomize, int t);
void checkListUntildeBruijn(std::list<int>& sequence, const std::vector<std::vector<int>> subStringsToFind, int k, int t);
void mutateList(std::list<int>& listToRandomize);

int main()
{
    srand((unsigned)time(nullptr));

    //set k1
    int k1 = 2;
    //set t1, which is size of the array/list we are trying to check is sequence = 2^k in length
    int t1 = (int)pow(2, k1);
    //repeat this for the other sizes
    int k2 = 3;
    int t2 = (int)pow(2, k2);
    int k3 = 4;
    int t3 = (int)pow(2, k3);
    int k4 = 5;
    int t4 = (int)pow(2, k4);
  
    //setting timer variables to test at different sizes of k
    long long kSize2Array = 0;
    long long kSize3Array = 0;
    long long kSize4Array = 0;
    long long kSize5Array = 0;
    long long kSize2List = 0;
    long long kSize3List = 0;
    long long kSize4List = 0;
    long long kSize5List = 0;

    //this will be the random array sequence we will be trying to show/make into a deBruijn sequence
    int* arraySequence;
    //this will be the random list sequence we will be trying to show/make into a deBruijn sequence
    std::list<int> listSequence;
    //this contains all the substrings of size k we need to find to determine if the sequence exists
    std::vector<std::vector<int>> substringsToFind;

    //this creates all the substrings (which are bitstrings) of size k1
    createAllBitstrings(substringsToFind, 0, k1);

    //runs each function 25 times for each size (100 times total) and tracks total time taken per size
    for (int i = 0; i < 25; i++) {
    
        //make arraySequence size t1
        arraySequence = new int[t1];

        //create some random sequence of size t1 (= 2^k1)
        createRandomArraySequence(arraySequence, t1);
        createRandomListSequence(listSequence, t1);

        kSize2Array += TimeFuncMicro([&]() {checkArrayUntildeBruijn(arraySequence, substringsToFind, k1, t1); });
        kSize2List += TimeFuncMicro([&]() {checkListUntildeBruijn(listSequence, substringsToFind, k1, t1); });

        //delete arraySequence of size t1
        delete[]arraySequence;
        //clear entire listSequence
        listSequence.clear();
    }

    //clear vector containing all bitstrings of size k1
    substringsToFind.clear();
    //this creates all the substrings (which are bitstrings) of size k2
    createAllBitstrings(substringsToFind, 0, k2);

    for (int i = 0; i < 25; i++) {

        //make arraySequence size t2
        arraySequence = new int[t2];

        //create some random sequence of size t2 (= 2^k2)
        createRandomArraySequence(arraySequence, t2);
        createRandomListSequence(listSequence, t2);
    
        kSize3Array += TimeFuncMicro([&]() {checkArrayUntildeBruijn(arraySequence, substringsToFind, k2, t2); });
        kSize3List += TimeFuncMicro([&]() {checkListUntildeBruijn(listSequence, substringsToFind, k2, t2); });

        //delete arraySequence of size t2
        delete[]arraySequence;
        //clear entire listSequence
        listSequence.clear();
    }

    //clear vector containing all bitstrings of size k2
    substringsToFind.clear();
    //this creates all the substrings (which are bitstrings) of size k3
    createAllBitstrings(substringsToFind, 0, k3);

    for (int i = 0; i < 25; i++) {
    
        //make arraySequence size t3
        arraySequence = new int[t3];

        //create some random sequence of size t3 (= 2^k3)
        createRandomArraySequence(arraySequence, t3);
        createRandomListSequence(listSequence, t3);

        kSize4Array += TimeFuncMilli([&]() {checkArrayUntildeBruijn(arraySequence, substringsToFind, k3, t3); });
        kSize4List += TimeFuncMilli([&]() {checkListUntildeBruijn(listSequence, substringsToFind, k3, t3); });

        //delete arraySequence of size t3
        delete[]arraySequence;
        //clear entire listSequence
        listSequence.clear();
    
    }

    //clear vector containing all bitstrings of size k4
    substringsToFind.clear();
    //this creates all the substrings (which are bitstrings) of size k4
    createAllBitstrings(substringsToFind, 0, k4);

    for (int i = 0; i < 25; i++) {

        //make arraySequence size t4
        arraySequence = new int[t4];

        //create some random sequence of size 4 (= 2^k4)
        createRandomArraySequence(arraySequence, t4);
        createRandomListSequence(listSequence, t4);

        kSize5Array += TimeFuncMilli([&]() {checkArrayUntildeBruijn(arraySequence, substringsToFind, k4, t4); });
        kSize5List += TimeFuncMilli([&]() {checkListUntildeBruijn(listSequence, substringsToFind, k4, t4); });

        //delete arraySequence of size t4
        delete[]arraySequence;
        //clear entire listSequence
        listSequence.clear();

    }

    std::cout << "Looking for B(2,2) sequence\nSizes: k = 2, t = 2^k = 4\nTotal time for all 25 tests using array-based sequence: " << kSize2Array << " microseconds\nAverage time: " << kSize2Array / 25 << "microseconds\n";
    std::cout << "Total time for all 25 tests using list-based sequence: " << kSize2List << " microseconds \nAverage time: " << kSize2List / 25 << " microseconds\n";
    std::cout << std::endl;
    std::cout << "Looking for B(2,3) sequence\nSizes: k = 3, t = 2^k = 8\nTotal time for all 25 tests using array-based sequence: " << kSize3Array << " microseconds\nAverage time: " << kSize3Array / 25 << " microsends\n";
    std::cout << "Total time for all 25 tests using list-based sequence: " << kSize3List << " microseconds\nAverage time: " << kSize3List / 25 << " microseconds";
    std::cout << std::endl;
    std::cout << "Looking for B(2,4) sequence\nSizes: k = 4, t = 2^k = 16\nTotal time for all 25 tests using array-based sequence: " << kSize4Array << " milliseconds\nAverage time: " << kSize4Array / 25 << " milliseconds\n";
    std::cout << "Total time for all 25 tests using list-based sequence: " << kSize4List << " milliseconds\nAverage time: " << kSize4List / 25 << " milliseconds\n";
    std::cout << std::endl;
    std::cout << "Looking for B(2,5) sequence\nSizes: k = 5, t = 2^k = 32\nTotal time for all 25 tests using array-based sequence: " << kSize5Array << " milliseconds\nAverage time: " << kSize5Array / 25 << "milliseconds\n";
    std::cout << "Total time for all 25 tests using list-based sequence: " << kSize5List <<  "milliseconds\nAverage time: " << kSize5List / 25 << " milliseconds\n";


}

//times in milliseconds
template <typename Func>
long long TimeFuncMilli(Func f)
{
    auto begin = steady_clock::now();
    f();
    auto end = steady_clock::now();

    return duration_cast<milliseconds>(end - begin).count();
}

//times in microseconds
template <typename Func>
long long TimeFuncMicro(Func f)
{
    auto begin = steady_clock::now();
    f();
    auto end = steady_clock::now();

    return duration_cast<microseconds>(end - begin).count();
}


//creates all bitstrings of size k and stores it in a vector of vectors
void createAllBitstrings(std::vector<std::vector<int>>& bitStringStorage, int currBitStringSize, int k) {

    //static variable so it remains the same throughout all recursive calls
    static std::vector<int> currBitstring;

    //Base Case: if the bit string reaches size n (size of wanted bits) then add it to the storage and return
    if (currBitStringSize == k) {
        bitStringStorage.push_back(currBitstring);
        return;
    }

    //push 0 onto the vector representing current bitstring
    currBitstring.push_back(0);
    //call function again, but increase the size of bitstring by 1
    createAllBitstrings(bitStringStorage, currBitStringSize + 1, k);
    //remove the 0
    currBitstring.pop_back();

    //push 1 onto the vector representing current bitstring
    currBitstring.push_back(1);
    //call function again, but increase the size of bitstring by 1
    createAllBitstrings(bitStringStorage, currBitStringSize + 1, k);
    //remove the 1
    currBitstring.pop_back();
}

//creates a random sequence of 0s and 1s
void createRandomArraySequence(int* arrToRandomize, int t) {
    

    //loops from beginning to end of array filling it with 0s and 1s randomly
    for (int i = 0; i < t; i++)
        arrToRandomize[i] = rand() % 2;

}

//checks sequence, if not a deBruijn mutate function, repeat until sequence found
void checkArrayUntildeBruijn(int* sequence, const std::vector<std::vector<int>> subStringsToFind, int k, int t) {

    //bool array to track which bitstrings have been found as a substring in array
    bool* checkArray;
    //a flag to show if any bitstring was found as a substring starting from a specific point in sequence
    bool foundFlag;
    //a flag to determine if there was no match found between main sequence and some corresponding element of a bitstring we are checking if it is a substring
    bool noMatchFlag;


//label to start of whole check process for restarting check from start, resetting all necessary flags too
restartCheck:
    //create a new check array of size t (which is number of bitstrings = 2^k), and it initializes all elements to false
    checkArray = new bool[t]();
    //set foundFlag to true so it gets past first check of initial loop
    foundFlag = true;
    //loops through entire sequence, used to determine new start position to start checking sequence from
    for (int startPos = 0; startPos < t; startPos++) {
        //if no substring was found in previous iteration, delete checkArray, mutate sequence, and goto start of entire check again
        if (!foundFlag) {
            mutateArray(sequence, t);
            delete[]checkArray;
            goto restartCheck;
        }
        //reset foundFlag to false
        foundFlag = false;
        //this loops through each bit string, from 0->(t-1)th bit string (so all t = 2^k of them)
        for (int bitstringNum = 0; bitstringNum < t; bitstringNum++) {
            //reset flag back to false (as no error has been found in the new bitstring yet)
            noMatchFlag = false;
            //if said bitstring has already been found, skip it and start checking if next bitstring is int sequence, also deals with extreme case
            //extreme case occurs when this loop and outer loop would be reaching its end, if there was no match found would not mutate and reset due to loop termination, so set outerloop to 1 prior to force it to mutate and reset in this condition
            if (checkArray[bitstringNum] == true) {
                //this checks if it is final iteration of this inner loop and outerloop, if true decrease startPos before continuing to ensure it mutates and resets
                if (bitstringNum + 1 == t && startPos + 1 == t)
                    startPos--;
                continue;
            }
            //iterates through each element of the bistrings to compare with k terms of main sequence starting from start position
            for (int bitstringPos = 0; bitstringPos < k; bitstringPos++) {
                /*if the bitstringPosth element of bitstringNum does not match the corresponding element of sequence, then set flag to true and break out of inner loop to get to next string
                (startPos + bitstringPos) % t will allow wrap around of main array sequence, due to ability to get greater than t in size (e.g., ((t-2) + 3)%t = (t + 1)% t = 1*/
                if (subStringsToFind[bitstringNum][bitstringPos] != sequence[(startPos + bitstringPos) % t]) {
                    noMatchFlag = true; 
                    break;
                }
            }
            //if error was found, go to next bitstring to start comparing, and deals with other place extreme case can occur
            //extreme case occurs when this loop and outer loop would be reaching its end, if there was no match found would not mutate and reset due to loop termination, so set outerloop to 1 prior to force it to mutate and reset in this condition
            if (noMatchFlag) {
                //this checks if it is final iteration of this inner loop and outerloop, if true decrease startPos before continuing to ensure it mutates and resets
                if (bitstringNum + 1 == t && startPos + 1 == t)
                    startPos--;
                continue;
            }
            //if it makes it here, means the bitstring was a substring starting at this position, so mark it as being used in checkArray, then break out of inner loop to go to next position
            checkArray[bitstringNum] = true;
            foundFlag = true;
            break;
        }

    }


}
void mutateArray(int* arrToMutate, int t) {
    //loops from start to end of array, which has size t
    for (int i = 0; i < t; i++) {
        //picks a number from 0-99, if that number is 0-4 it randomizes the element (this creates 5% chance of occurance)
        if (rand() % 100 < 5)
            //changes 0->1 and 1->0 by adding 1 to current result then getting modulo 2
            arrToMutate[i] = (arrToMutate[i] + 1) % 2;
    }

    

}
void createRandomListSequence(std::list<int>& listToRandomize, int t) {
    
    //loops from beginning to end of array filling it with 0s and 1s randomly
    for (int i = 0; i < t; i++)
        listToRandomize.push_back(rand() % 2);

}

//checks sequence, if not a deBruijn mutate function, repeat until sequence found
void checkListUntildeBruijn(std::list<int>& sequence, const std::vector<std::vector<int>> subStringsToFind, int k, int t) {

    //bool array to track which bitstrings have been found as a substring in array
    bool* checkArray;
    //a flag to show if any bitstring was found as a substring starting from a specific point in sequence
    bool foundFlag;
    //a flag to determine if there was no match found between main sequence and some corresponding element of a bitstring we are checking if it is a substring
    bool noMatchFlag;
    //iterator used for traversing list (starting at relative start position of list)
    std::list<int>::const_iterator traverseIt;
    //iterator used in checking for extreme case (which is when there is no match found when both first and second loop are in final iteration)
    std::list<int>::const_iterator extremeCaseIt;

//label to start of whole check process for restarting check from start, resetting all necessary flags too
restartCheck:
    //create a new check array of size t (which is number of bitstrings = 2^k), and it initializes all elements to false
    checkArray = new bool[t]();
    //set foundFlag to true so it gets past first check of initial loop
    foundFlag = true;

    //loops through entire sequence, used to determine new start position to start checking sequence from
    for (std::list<int>::const_iterator startPosIt = sequence.begin(); startPosIt != sequence.end(); startPosIt++) {
        //if no substring was found in previous iteration, delete checkArray, mutate sequence, and goto start of entire check again
        if (!foundFlag) {
            mutateList(sequence);
            delete[]checkArray;
            goto restartCheck;
        }
        //reset foundFlag to false
        foundFlag = false;

        for (int bitstringNum = 0; bitstringNum < t; bitstringNum++) {
            //set traverse iterator to start position iterator, effectively resetting it
            traverseIt = startPosIt;
            //reset flag back to false (as no error has been found in the new bitstring yet)
            noMatchFlag = false;
            //if said bitstring has already been found, skip it and start checking if next bitstring is int sequence, also deals with an extreme case
            //extreme case occurs when this loop and outer loop would be reaching its end, if there was no match found would not mutate and reset due to loop termination, so set outerloop to 1 prior to force it to mutate and reset in this condition
            if (checkArray[bitstringNum] == true) {
                //this makes extremeCaseIt point to element after startPosIt without affected what startPosIt points too
                extremeCaseIt = startPosIt;
                extremeCaseIt++;
                //this checks if it is final iteration of this inner loop and outerloop, if true decrease startPosIt before continuing to ensure it mutates and resets
                if (bitstringNum + 1 == t && extremeCaseIt == sequence.end())
                    startPosIt--;
                continue;
            }
            //iterates through each element of the bistrings to compare with k terms of main sequence starting from start position
            for (int bitstringPos = 0; bitstringPos < k; bitstringPos++) {
                //if traverse iterator hits end of list, make it point to start to list (effectively allowing it to wrap around)
                if (traverseIt == sequence.end()) {
                    traverseIt = sequence.begin();
                }
                //if the bitstringPosth element of bitstringNum does not match the corresponding element of sequence, then set flag to true and break out of inner loop to get to next string
                if (subStringsToFind[bitstringNum][bitstringPos] != *traverseIt) {
                    noMatchFlag = true;
                    break;
                }
                //go to next element of sequence
                traverseIt++;
            }
            //if error was found, go to next bitstring to start comparing, and deals with other place extreme case can occur
            //extreme case occurs when this loop and outer loop would be reaching its end, if there was no match found would not mutate and reset due to loop termination, so set outerloop to 1 prior to force it to mutate and reset in this condition
            if (noMatchFlag) {
                //this makes extremeCaseIt point to element after startPosIt without affected what startPosIt points too
                extremeCaseIt = startPosIt;
                extremeCaseIt++;
                //this checks if it is final iteration of this inner loop and outerloop, if true decrease startPosIt before continuing to ensure it mutates and resets
                if (bitstringNum + 1 == t && extremeCaseIt == sequence.end())
                    startPosIt--;
                continue;
            }
            //if it makes it here, means the bitstring was a substring starting at this position, so mark it as being used in checkArray, then break out of inner loop to go to next position
            checkArray[bitstringNum] = true;
            foundFlag = true;
            break;
        }


    }



}

void mutateList(std::list<int>& listToRandomize) {

    std::list<int>::iterator listIt;

    //loops from start to end of array, which has size t
    for (listIt = listToRandomize.begin(); listIt != listToRandomize.end(); listIt++) {
        //picks a number from 0-99, if that number is 0-4 it randomizes the element (this creates 5% chance of occurance)
        if (rand() % 100 < 5)
            //changes 0->1 and 1->0 by adding 1 to current result then getting modulo 2
            *listIt = (*listIt + 1) % 2;
    }

}