#include <iostream>

class Node {
public:
    std::string day = "";
    int startTimeHour = 0;
    int startTimeMinute = 0;
    int meetingTime = 0;
    int endTimeHour = 0;
    int endTimeMinute = 0;

    Node* next = nullptr;
    Node* prev = nullptr;


};

class DoublyLinkedList {


private:
    int apptCount;
    Node* first;
    Node* last;

public:
    DoublyLinkedList() {
        apptCount = 0;
        first = last = nullptr;
        setSentinels();

    }
private:
    //this sets up sentinal nodes to create separate sections in the list for different days
    void setSentinels() {
        //the start of the days
        Node* mondayStart = new Node, * tuesdayStart = new Node, * wednesdayStart = new Node, * thursdayStart = new Node, * fridayStart = new Node;
        //the end of the days
        Node* mondayEnd = new Node, * tuesdayEnd = new Node, * wednesdayEnd = new Node, * thursdayEnd = new Node, * fridayEnd = new Node;

        //sets the days for the starts
        mondayStart->day = "Monday";
        tuesdayStart->day = "Tuesday";
        wednesdayStart->day = "Wednesday";
        thursdayStart->day = "Thursday";
        fridayStart->day = "Friday";

        //makes the start and end times 9:00 (since that is the time each day starts)
        mondayStart->startTimeHour = 9;
        mondayStart->startTimeMinute = 0;
        mondayStart->endTimeHour = 9;
        mondayStart->endTimeMinute = 0;

        tuesdayStart->startTimeHour = 9;
        tuesdayStart->startTimeMinute = 0;
        tuesdayStart->endTimeHour = 9;
        tuesdayStart->endTimeMinute = 0;

        wednesdayStart->startTimeHour = 9;
        wednesdayStart->startTimeMinute = 0;
        wednesdayStart->endTimeHour = 9;
        wednesdayStart->endTimeMinute = 0;

        thursdayStart->startTimeHour = 9;
        thursdayStart->startTimeMinute = 0;
        thursdayStart->endTimeHour = 9;
        thursdayStart->endTimeMinute = 0;

        fridayStart->startTimeHour = 9;
        fridayStart->startTimeMinute = 0;
        fridayStart->endTimeHour = 9;
        fridayStart->endTimeMinute = 0;

        //set the days for the ends
        mondayEnd->day = "Monday";
        tuesdayEnd->day = "Tuesday";
        wednesdayEnd->day = "Wednesday";
        thursdayEnd->day = "Thursday";
        fridayEnd->day = "Friday";

        //sets the start and end times to 17:00 (since that is the time each day ends)
        mondayEnd->startTimeHour = 17;
        mondayEnd->startTimeMinute = 0;
        mondayEnd->endTimeHour = 17;
        mondayEnd->endTimeMinute = 0;

        tuesdayEnd->startTimeHour = 17;
        tuesdayEnd->startTimeMinute = 0;
        tuesdayEnd->endTimeHour = 17;
        tuesdayEnd->endTimeMinute = 0;

        wednesdayEnd->startTimeHour = 17;
        wednesdayEnd->startTimeMinute = 0;
        wednesdayEnd->endTimeHour = 17;
        wednesdayEnd->endTimeMinute = 0;

        thursdayEnd->startTimeHour = 17;
        thursdayEnd->startTimeMinute = 0;
        thursdayEnd->endTimeHour = 17;
        thursdayEnd->endTimeMinute = 0;

        fridayEnd->startTimeHour = 17;
        fridayEnd->startTimeMinute = 0;
        fridayEnd->endTimeHour = 17;
        fridayEnd->endTimeMinute = 0;

        //make the start of monday the start of the list
        first = mondayStart;
        //make the end of friday the end of the list
        last = fridayEnd;

        //connect all the nodes so you end up with:
        //(chains to fridayStart) <- mondayStart <-> mondayEnd <-> tuesdayStart <-> tuesdayEnd <->...<-> thursdayEnd <-> fridayStart <-> fridayEnd -> (chains to mondayStart)
        //      first^                                                                                             last^
        mondayStart->next = mondayEnd;
        tuesdayStart->next = tuesdayEnd;
        wednesdayStart->next = wednesdayEnd;
        thursdayStart->next = thursdayEnd;
        fridayStart->next = fridayEnd;
        mondayStart->prev = fridayEnd;
        tuesdayStart->prev = mondayEnd;
        wednesdayStart->prev = tuesdayEnd;
        thursdayStart->prev = wednesdayEnd;
        fridayStart->prev = thursdayEnd;

        mondayEnd->next = tuesdayStart;
        tuesdayEnd->next = wednesdayStart;
        wednesdayEnd->next = thursdayStart;
        thursdayEnd->next = fridayStart;
        fridayEnd->next = mondayStart;
        mondayEnd->prev = mondayStart;
        tuesdayEnd->prev = tuesdayStart;
        wednesdayEnd->prev = wednesdayStart;
        thursdayEnd->prev = thursdayStart;
        fridayEnd->prev = fridayStart;    
    
}

public:
    //inserts appointment in correct spot
    void insertAppt(std::string day, int startTimeHr, int startTimeMin, int meetingTime) {

        //data to be inputted
        Node* inputAppt = new Node;
        inputAppt->day = day;
        inputAppt->startTimeHour = startTimeHr;
        inputAppt->startTimeMinute = startTimeMin;
        inputAppt->meetingTime = meetingTime;

        //if invalid data entered, just delete the node then break out the function
        if (!dataValidityCheck(inputAppt)) {
            std::cout << "INVALID DATA INPUTTED\n";
            delete inputAppt;
            return;
        }


        //this will just be used to keep track of where we currently are in the list
        Node* current = first;

        //case 1: can insert in wanted spot
        //this takes us to the start of section of the list where the appointment should be inserted
        while (current->day != inputAppt->day) {
            current = current->next;
        }

        //this will be the "starting node" to keep track of where we start looking to insert from
        Node* startNode = current;

        //this loops whilst still looking in the same day
        while (current->day.compare(current->next->day) == 0) {
            //if wanted time can fit between the boundary created by what would be before and what would be after, it will be inserted, otherwise not inserted
            //e.g,: If you want to insert 9:30-1030 and you have end 9:30 <-> start 10:30, this appointment would fit in-between those 2 bounds

            if ((current->endTimeHour < inputAppt->startTimeHour || (current->endTimeHour == inputAppt->startTimeHour && current->endTimeMinute <= inputAppt->startTimeMinute)) && (inputAppt->endTimeHour < current->next->startTimeHour || (inputAppt->endTimeHour == current->next->startTimeHour && inputAppt->endTimeMinute <= current->next->startTimeMinute))) {
                //changes the link between the nodes:
                //input points to thing after it
                inputAppt->next = current->next;
                //current points to input
                current->next = inputAppt;
                //thing after input points to input (as its before it)
                inputAppt->next->prev = inputAppt;
                //input points to thing before it
                inputAppt->prev = current;
                apptCount++;
                //return function, as its been added
                return;
            }
            current = current->next;
        
        }

        //case 2a: cannot insert in wanted spot, but can on correct day (assigning on same day will always be closest)

        //set current to node after start of day (this will be first appointment of the day)
        current = startNode->next;

        //need to find node that is causing time conflict to find closest node from that on the same day

        //this will store that node causing the conflict
        Node* conflictNode = new Node;

        //this loops whilst still looking in the same day
        while (current->day.compare(current->next->day) == 0) {
            //this if statement checks if the starting time overlaps, checks if current start <= input start < current end
            if ((current->startTimeHour < inputAppt->startTimeHour || (current->startTimeHour == inputAppt->startTimeHour && current->startTimeMinute <= inputAppt->startTimeMinute)) && (current->endTimeHour > inputAppt->startTimeHour || (current->endTimeHour == inputAppt->startTimeHour && current->endTimeMinute > inputAppt->startTimeMinute))) {
                //make conflict node to current node
                conflictNode = current;
                //break out of loop
                break;
            }
            //this if statement checks if the end time overlaps, checks if current start < input end <= current end
            else if ((current->startTimeHour < inputAppt->endTimeHour || (current->startTimeHour == inputAppt->endTimeHour && current->startTimeMinute < inputAppt->endTimeMinute)) && (current->endTimeHour > inputAppt->endTimeHour || (current->endTimeHour == inputAppt->endTimeHour && current->endTimeMinute >= inputAppt->endTimeMinute))) {
                //make conflict node to current node
                conflictNode = current;
                //break out of loop
                break;
            }

            current = current->next;

        }
        
        //sets current node to be node where conflict occurs
        current = conflictNode;

        //create temp node that holds inputAppt to iterate forward and backwards to find insertion slot and data
        Node* tempForward, * tempBackwards;
        tempForward = new Node;
        tempBackwards = new Node;

        //sets the meetingTimes and day of the temp nodes
        tempForward->meetingTime = tempBackwards->meetingTime = inputAppt->meetingTime;
        tempForward->day = tempBackwards->day = inputAppt->day;

        //creates nodes that will store node where insertion happens before/after
        Node* insertBefore, * insertAfter;
        insertBefore = insertAfter = nullptr;

        //this loops whilst still looking in the same day going forward
        while (current->day.compare(current->next->day) == 0) {
            
            //sets the start time of appoits to end of the previous appointment
            tempForward->startTimeHour = current->endTimeHour;
            tempForward->startTimeMinute = current->endTimeMinute;
            //calcs the new end times
            calcEndTimes(tempForward);

            //makes sure that the new end time occurs before or right as next appointment should normally start
            if (tempForward->endTimeHour < current->next->startTimeHour || (tempForward->endTimeHour == current->next->startTimeHour && tempForward->endTimeMinute <= current->next->startTimeMinute)) {
                //if it fits, break out the loop as you have the point to insert it at, and set the insertAfter node to current node
                insertAfter = current;
                break;
            }
            //cycle to next node
            current = current->next;
            //if no new insertion point could be find going forward
            if (current->day.compare(current->next->day) != 0) {
                //delete temp node and set to nullptr
                delete tempForward;
                tempForward = nullptr;
            }

        }

        //reset current to start at conflict appointment
        current = conflictNode;

        //this loops whilst still looking in the same day going backword
        while (current->day.compare(current->prev->day) == 0) {
            //sets the start time of appt to end of the previous appointment
            tempBackwards->endTimeHour = current->startTimeHour;
            tempBackwards->endTimeMinute = current->startTimeMinute;
            //calcs the new end times
            calcStartTimes(tempBackwards);  

            //makes sure that the new start time occurs after or right as next appointment should normally end
            if (tempBackwards->startTimeHour > current->prev->endTimeHour || (tempBackwards->startTimeHour == current->prev->endTimeHour && tempBackwards->startTimeMinute >= current->prev->endTimeMinute)) {
                //if it fits, break out the loop as you have the point to insert it at, and insertBefore node to current
                insertBefore = current;
                break;
            }
            //cycle to next node
            current = current->prev;
            //if no new insertion point could be find going forward
            if (current->day.compare(current->prev->day) != 0) {
                //delete temp node and set to nullptr
                delete tempBackwards;
                tempBackwards = nullptr;
            }

        }

        //if a time could only be found in this direction or time normally should have been in the first half of the workday, insert tempBackward in slot where appt has been shifted too (as this always is closest)
        if ((tempBackwards == nullptr && tempForward != nullptr) || (tempBackwards != nullptr && inputAppt->startTimeHour < 13)) {
        
            //if it has to input before
            if (tempBackwards != nullptr) {
                //updates nodes insert new appt in between before it
                tempBackwards->next = insertBefore;
                tempBackwards->prev = insertBefore->prev;
                insertBefore->prev = tempBackwards;
                tempBackwards->prev->next = tempBackwards;
                apptCount++;
                //after it has been inserted, exit function
                return;
            }

            //if i has to input after
            if (tempForward != nullptr) {
                //update nodes to insert new appt in between after it
                tempForward->next = insertAfter->next;
                tempForward->prev = insertAfter;
                insertAfter->next = tempForward;
                tempForward->next->prev = tempForward;
                apptCount++;
                //after it has inserted, exit function
                return;

            }

        
        }

        //else if time normally should have been in 2nd half, insert tempForward in slot where appt has been shifted too
        else if ((tempBackwards != nullptr && tempForward == nullptr) || (tempForward != nullptr && inputAppt->startTimeHour >= 13)) {
        
            //if it has to input before
            if (tempBackwards != nullptr) {
                //updates nodes insert new appt in between before it
                tempBackwards->next = insertBefore;
                tempBackwards->prev = insertBefore->prev;
                insertBefore->prev = tempBackwards;
                tempBackwards->prev->next = tempBackwards;
                apptCount++;
                //after it has been inserted, exit function
                return;
            }

            //if i has to input after
            if (tempForward != nullptr) {
                //update nodes to insert new appt in between after it
                tempForward->next = insertAfter->next;
                tempForward->prev = insertAfter;
                insertAfter->next = tempForward;
                tempForward->next->prev = tempForward;
                apptCount++;
                //after it has inserted, exit function
                return;

            }
        
        }

        //case 2ai: check going forward to different day
        //case 2aii: check going backwards to different day

        //keeps track of total wait time going forward and backward to find closest fill in time (stores in minutes)

        //total wait time from start time to end of the day (since it was not found in the same day)
        int waitTimeNext = 17 * 60 - inputAppt->startTimeHour * 60 - inputAppt->startTimeMinute;
        //total wait time from start of teh day to start time (since it was not found in the same day
        int waitTimePrev = inputAppt->startTimeHour * 60 + inputAppt->startTimeMinute - 9*60;

        //makes new nodes and sets the meetingTimes and day of the temp nodes (since they were deleted and set to nullptr due to failing previous case)
        tempForward = new Node;
        tempBackwards = new Node;
        tempForward->meetingTime = tempBackwards->meetingTime = inputAppt->meetingTime;

        //will start searching through all the days from the conflictNode
        current = conflictNode;



        //checking for closest going forward
        while (true) {

            tempForward->day = current->day;
            tempForward->startTimeHour = current->endTimeHour;
            tempForward->startTimeMinute = current->endTimeMinute;
            //calcs the new end times
            calcEndTimes(tempForward);

            //adds 16hrs to wait time when appt first enters a new day
            if (current->day != current->prev->day) {
                waitTimeNext += 16 * 60;
            
            }
            //else adds to wait time while not in the same day (as that was all factored in earlier)
            else if (current->day != inputAppt->day) {
                //calcs (in minutes) the time waited between previous appointment end and current appointment end (as it tries to insert after current ends)
                waitTimeNext += (current->endTimeHour * 60 + current->endTimeMinute) - (current->prev->endTimeHour * 60 + current->prev->endTimeMinute);
            }

            //makes sure that the new end time occurs before or right as next appointment should normally start
            if (tempForward->endTimeHour < current->next->startTimeHour || (tempForward->endTimeHour == current->next->startTimeHour && tempForward->endTimeMinute <= current->next->startTimeMinute)) {
                //if it fits, break out the loop as you have the point to insert it at, and set the insertAfter node to current node
                insertAfter = current;
                break;
            }

            current = current->next;
            //if it completes a full iteration of the loop, break out because no slots to insert were found
            if (current == conflictNode)
                break;

        }


        //resets current to be conflictNode
        current = conflictNode;

        //checking for closest going backward
        while (true) {


            //sets the start time of appt to end of the previous appointment
            tempBackwards->day = current->day;
            tempBackwards->endTimeHour = current->startTimeHour;
            tempBackwards->endTimeMinute = current->startTimeMinute;
            //calcs the new end times
            calcStartTimes(tempBackwards);


            //adds 16hrs to wait time when appt first enters a new day
            if (current->day != current->next->day) {
                waitTimePrev += 16 * 60;

            }
            //else adds to wait time while not in the same day (as that was all factored in earlier)
            else if (current->day != inputAppt->day) {

                //calcs (in minutes) the time waited between current appointment start and next appointment start (as it tries to insert before current starts)
                waitTimePrev += (current->next->startTimeHour * 60 + current->next->startTimeMinute) - (current->startTimeHour * 60 + current->startTimeMinute);
            }

            //makes sure that the new start time occurs after or right as next appointment should normally end
            if (tempBackwards->startTimeHour > current->prev->endTimeHour || (tempBackwards->startTimeHour == current->prev->endTimeHour && tempBackwards->startTimeMinute >= current->prev->endTimeMinute)) {
                //if it fits, break out the loop as you have the point to insert it at, and insertBefore node to current
                insertBefore = current;
                //add meeting time to wait time (as it is a bit more extra time to wait for the start)
                waitTimePrev += meetingTime;
                break;
            }
            //cycle to previous node
            current = current->prev;

            //if it completes a full iteration of the loop, break out because no slots to insert were found
            if (current == conflictNode)
                break;
        }

        //if wait time to insert before is less than wait time to insert after, and a slot was actually found to insert before
        if (waitTimePrev <= waitTimeNext && insertBefore != nullptr) {
            //updates nodes insert new appt in between before it
            tempBackwards->next = insertBefore;
            tempBackwards->prev = insertBefore->prev;
            insertBefore->prev = tempBackwards;
            tempBackwards->prev->next = tempBackwards;
            apptCount++;
            //after it has been inserted, exit function
            return;
        
        }

        //else if wait time to insert after is less than wait time to insert before, and a slot was actually found to instert after
        else if (waitTimePrev > waitTimeNext && insertAfter != nullptr) {
            //update nodes to insert new appt in between after it
            tempForward->next = insertAfter->next;
            tempForward->prev = insertAfter;
            insertAfter->next = tempForward;
            tempForward->next->prev = tempForward;
            apptCount++;
            //after it has inserted, exit function
            return;
        }

        //case 3: no slot found at all
        std::cout << "No room to insert appointment.\n";
        return;
    }

    int getApptCount() {
        return apptCount;
    }

private:
    //tests the validity of all data of the node
    bool dataValidityCheck(Node* & node) {
        
        //if meeting time (in minutes) is greater than 2hrs or less than half an hour, return false
        if (node->meetingTime > 120 || node->meetingTime < 30)
            return false;

        //if the day is not Mon-Fri, then return false
        if(!(node->day.compare("Monday") == 0 || node->day.compare("Tuesday") == 0 || node->day.compare("Wednesday") == 0 || node->day.compare("Thursday") == 0 || node->day.compare("Friday") == 0))
            return false;

        //if start time is before 9:00 or after and including 17:00 return false
        if (node->startTimeHour >= 17 || node->startTimeHour < 9)
            return false;

        //if minutes are invalid
        if (node->startTimeMinute < 0 || node->startTimeMinute > 60)
            return false;

        //figures out the hour and minutes of the end time
        calcEndTimes(node);

        //if end time is after and excluding 17:00 return false
        if (node->endTimeHour > 17)
            return false;
        if (node->endTimeHour == 17 && node->endTimeMinute > 0)
            return false;

        //if all checks are passed, return true
        return true;

    }

    //figures out the end hour and minutes
    void calcEndTimes(Node* & node) {
        //set endMinutes to startTime minutes + meetingTime (which is stored in minutes)
        int endMinutes = node->startTimeMinute + node->meetingTime;

        //find how many extra hours that is
        int extraHours = endMinutes / 60;

        //remove extra hours so minutes are <60
        endMinutes = endMinutes - 60 * (endMinutes / 60);

        //sets the nodes
        node->endTimeHour = (node->startTimeHour + extraHours);
        node->endTimeMinute = endMinutes;
    
    }

    //figures out the start hour and minutes
    void calcStartTimes(Node*& node) {
    
        //set startMinutes and hours to end minute and hour
        int startMinutes = node->endTimeMinute;
        int startHours = node->endTimeHour;

        //loop while startMinutes is less than meetingTime
        while (startMinutes < node->meetingTime) {
            //if its less than, add 60 minutes
            startMinutes += 60;
            //decrease hours (as we have gone back enough minutes to change the hour)
            startHours--;
        }
        //gets the final starting minutes by subtracting the current overall minute time from the meeting time
        startMinutes -= node->meetingTime;

        //sets the start hours and minutes
        node->startTimeHour = startHours;
        node->startTimeMinute = startMinutes;
    }

    bool isEmpty() {
        return apptCount == 0;
    }



    public:

    //deletes node at given appt number (assumes one-based indexing)
    void deleteAppointment(int apptNum) {
        
        //if list is empty just do not execute function
        if (isEmpty()) {
            std::cout << "There are no appointments\n";
            return;
        }
        
        //if inputted position for deletion is out of bounds, do not execute function
        if (apptNum < 1 || apptNum > apptCount) {
            std::cout << "Out of bounds\n";
            return;
        }
        

        //starts at first appointment
        Node* current = first->next;
        //traits node before current
        Node* trailCurrent = first;

        //loops until it gets to node to delete
        while (apptNum > 1) {
            current = current->next;
            trailCurrent = trailCurrent->next;

            //ensures it will ignore sentinel nodes
            if (!(current->startTimeHour == current->endTimeHour && current->startTimeMinute == current->endTimeMinute))
                apptNum--;
        }


        //skips over the node to be deleted
        trailCurrent->next = current->next;
        current->next->prev = trailCurrent;
        //deletes the node
        delete current;
        //decreases appointments
        apptCount--;
    
    }

    void printAppointmentList() {

        Node* current = first;
        int counter = 1;

        while (current != last) {
            //makes sure it does not print the sentinel nodes
            if (!(current->startTimeHour == current->endTimeHour && current->startTimeMinute == current->endTimeMinute))
                //series of if statements that just ensures a preceding 0 is added before minute if its below 10
                if(current->startTimeMinute < 10 && current->endTimeMinute < 10)
                    std::cout << "Appt #" << counter++ << ": " << current->day << " " << current->startTimeHour << ":0" << current->startTimeMinute << "-" << current->endTimeHour << ":0" << current->endTimeMinute << std::endl;
                else if(current->startTimeMinute < 10)
                    std::cout << "Appt #" << counter++ << ": " << current->day << " " << current->startTimeHour << ":0" << current->startTimeMinute << "-" << current->endTimeHour << ":" << current->endTimeMinute << std::endl;
                else if (current->endTimeMinute < 10)
                    std::cout << "Appt #" << counter++ << ": " << current->day << " " << current->startTimeHour << ":" << current->startTimeMinute << "-" << current->endTimeHour << ":0" << current->endTimeMinute << std::endl;
                else
                    std::cout << "Appt #" << counter++ << ": " << current->day << " " << current->startTimeHour << ":" << current->startTimeMinute << "-" << current->endTimeHour << ":" << current->endTimeMinute << std::endl;
            current = current->next;
        }
        std::cout << std::endl;
        return;
    }





};


int main()
{

    DoublyLinkedList scheduleForTheWeek;

    //inserts as appt at Mon 9:00-11:00
    scheduleForTheWeek.insertAppt("Monday", 9, 0, 120);
    //inserts as appt at Tue 10:14-10:44
    scheduleForTheWeek.insertAppt("Tuesday", 10, 14, 30);
    //does not insert, as meeting time is too short
    scheduleForTheWeek.insertAppt("Monday", 9, 0, 20);
    //inserts as appt at Mon 11:00-11:30, due to conflict cause by the first appointment. Cannot insert backward as no time free either
    scheduleForTheWeek.insertAppt("Monday", 9, 30, 30);
    //inserts as appt at Mon 11:30-13:00
    scheduleForTheWeek.insertAppt("Monday", 11, 30, 90);
    //inserts as appt at Mon 13:00-15:00
    scheduleForTheWeek.insertAppt("Monday", 13, 00, 120);
    //inserts as appt at Mon 15:00-17:00, as that is closest free time available in same day
    scheduleForTheWeek.insertAppt("Monday", 12, 00, 120);
    //inserts as appt at Fri 16:30-17:00, as that is closest free time avaiable on a different day
    scheduleForTheWeek.insertAppt("Monday", 9, 0, 30);
    //inserts as appt at Tue 9:00-10:00, as that is closest free time avaiable on a different day
    scheduleForTheWeek.insertAppt("Monday", 16, 0, 60);
    //deletes the 5th appointment (in one-based indexing), which in this case is the Mon 15:00-17:00 appt
    scheduleForTheWeek.deleteAppointment(5);


    std::cout << scheduleForTheWeek.getApptCount() << std::endl;
    scheduleForTheWeek.printAppointmentList();

    

}