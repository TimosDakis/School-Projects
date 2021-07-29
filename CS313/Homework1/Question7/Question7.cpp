#include <iostream>
#include <vector>
#include <list>
#include <set>
#include <time.h>
//timing things
#include <chrono>
using std::chrono::system_clock;
using std::chrono::steady_clock;
using std::chrono::duration_cast;
using std::chrono::seconds;
using std::chrono::milliseconds;

template <typename Func> long long TimeFunc(Func f);

int main()
{

	srand((unsigned)time(nullptr));

	//making the containers
	std::vector<int> vec;
	std::list<int> list;
	std::set<int> set;

	//timing insertion of 1M elements to the end:

	long long vectorInsertionMilliseconds = 0;
	long long listInsertionMilliseconds = 0;
	long long setInsertionMilliseconds = 0;

	for (int i = 0; i < 1000000; i++) {
		vectorInsertionMilliseconds += TimeFunc([&]() {vec.push_back(i);});
		listInsertionMilliseconds += TimeFunc([&]() {list.push_back(i); });
		setInsertionMilliseconds += TimeFunc([&]() {set.insert(i); });
	}

	std::cout << "VECTOR\n" << vectorInsertionMilliseconds << " ms to insert 1M elements\n";
	std::cout << "LIST\n" << listInsertionMilliseconds << " ms to insert 1M elements\n";
	std::cout << "SET\n" << setInsertionMilliseconds << " ms to insert 1M elements\n";



}

template <typename Func>
long long TimeFunc(Func f)
{
	auto begin = steady_clock::now();
	f();
	auto end = steady_clock::now();

	return duration_cast<milliseconds>(end - begin).count();
}