#include <iostream>
#include <list>
#include <string>
#include <utility>


void fillLists(std::list<std::string>& workerList, std::list<std::string>& jobList, int numberOfWorkers);
void printLists(const std::list<std::string>& workerList, const std::list<std::string>& jobList);
void shiftBack(std::list<std::string>& jobList);

int main()
{

	//creates the lists
	std::list<std::string> workerList;
	std::list<std::string> jobList;

	//fills and then prints lists
	fillLists(workerList, jobList, 25);
	printLists(workerList, jobList);

	//shifts the list back due to complaints then prints the lists
	shiftBack(jobList);
	printLists(workerList, jobList);


}

//dilla the lists with desired amount of workers (and jobs)
void fillLists(std::list<std::string>& workerList, std::list<std::string>& jobList, int numberOfWorkers) {

	//clear lists if they were not empty
	if (!workerList.empty())
		workerList.clear();

	if (!jobList.empty())
		jobList.clear();
	
	//sets up the base strings
	std::string worker;
	std::string job;

	//fills the lists with workers and their jobs
	for (int i = 0; i < numberOfWorkers; i++) {
		//resets the base string
		worker = "Worker ";
		job = "Job ";
		//fills lists with the workers and their corresponding jobs at the same element
		workerList.push_back((worker += std::to_string(i + 1)));
		jobList.push_back((job += std::to_string(i + 1)));
	}

}

//prints list back
void printLists(const std::list<std::string>& workerList, const std::list<std::string>& jobList) {

	//checks to make sure the lists are not empty
	if (!workerList.empty() && !jobList.empty()) {
		std::list<std::string>::const_iterator workerIt;
		std::list<std::string>::const_iterator jobIt;
		for (workerIt = workerList.begin(), jobIt = jobList.begin(); workerIt != workerList.end(); workerIt++, jobIt++) {
			std::cout << *workerIt << " does: " << *jobIt << std::endl;
		}
		std::cout << std::endl;
	}
	else
		std::cout << "Lists are empty\n";

}

//turns jobList forward by 1 so workers get the previous job
void shiftBack(std::list<std::string>& jobList) {
	if (!jobList.empty()) {
		std::string temp = jobList.back();
		jobList.pop_back();
		jobList.push_front(std::move(temp));
	}
	

}
