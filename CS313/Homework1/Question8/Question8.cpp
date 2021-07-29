#include <iostream>
#include <vector>
#include <time.h>
#include <set>

template <class T>
class findSums {

private:
    int arrSize;
    T* arr;
    T sum;
    std::set<std::vector<T>> solutions;
    std::vector<T> currSubset;

public:
    //constructor
    findSums(int arrSize, T sum) : sum(sum){
        if (arrSize < 0) {
            std::cout << "arrSize cannot be negative, input new value: \n";
            std::cin >> arrSize;
        }
        //creates new array of size arrSize and fill with random numbers
        this->arrSize = arrSize;
        arr = new T[arrSize];
        fillWithRandomNums();
    }
private:
    void fillWithRandomNums() {
        srand(time(nullptr));
        for (int i = 0; i < arrSize; i++) {
            //casts random number to T then adds it to array
            arr[i] = (T)(rand() % 1000 / 10.0);
        }


    }
public:
    //find all subsets that add up to wanted sum from a provided element to begin from (ignores any elements before it)
    void findAllCombos(int startPos) {

        //loop from starting position and iterate to end (this loops from starting position to end of array, but makes sure that if you have {1,2} you will not get an {1,1} subset during recursive calls)
        for (int pos = startPos; pos < arrSize; pos++) {

            //pushed back element at this position onto the current subset
            currSubset.push_back(arr[pos]);

            //if the sum of the subset is the wanted sum, push the vector onto the solution set
            if (checkSum())
                solutions.insert(currSubset);

            //call the function again, but increase current position by 1, so you start the next function at the next element (this avoids potential duping, or errors for making subsets that shouldnt exist)
            findAllCombos(pos + 1);

            //remove last element in the subset, to start creating/adding to a new/different subset
            currSubset.pop_back();
        }
            

    }

private:
    //checks if a given vector (i.e., subset) is equal to the desired sum
    bool checkSum() {
    
        //iterator and sum to store value
        typename std::vector<T>::const_iterator it;
        T sum = (T)0;

        //iterates through entire vector
        for (it = currSubset.begin(); it != currSubset.end(); it++) {
            sum += *it;
        }
        
        if (this->sum == sum)
            //return true if the calculated sum if equal to desired sum, else false
            return (this->sum == sum);

    }
public:
    void printSolutions() {
    
        typename std::set<std::vector<T>>::const_iterator it;
        std::vector<T> printVec;

        if (solutions.empty())
            std::cout << "NO SOLUTIONS FOUND\n";

        else {
            std::cout << "SOLUTIONS:\n";
            for (it = solutions.begin(); it != solutions.end(); ++it) {
                printVec = *it;
                std::cout << "{ ";
                for (int i = 0; i < printVec.size(); i++)
                    std::cout << printVec[i] << " ";
                std::cout << "}\n";

            }
        }

    }


};

int main()
{
    //creates variables of the given size that look for the given target. Then calls a function that finds all subsets that give said target
    findSums<int> sums(15, 500);
    sums.findAllCombos(0);
    
    findSums<double> dblSums(15, 500.5);
    dblSums.findAllCombos(0);

    //prints the solutions
    sums.printSolutions();
    dblSums.printSolutions();
}
