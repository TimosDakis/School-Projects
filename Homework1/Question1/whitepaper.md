#Problem (Question 1):
•	Design a vector and a linked list with necessary functions and compare insertion of different element.

#Outcomes
•	Inserting random string objects generally was faster with the list, whilst insertion of random numbers and strings via move semantics generally was faster with the vectors, though still relatively comparable in both cases.
•	Inserting random string objects was relatively significantly slower in comparison to insertion via move semantics

#Design Overview and Approach
•	Aimed to mimic vector and singly forward linked list
•	When making iterators, made them in such a way you could add on a custom value to increment by, rather than just going 1 by 1 (though list iterator has to loop through things 1 by 1 to reach wanted custom value)
•	When making list, wanted to allow for custom position insertion, which was dealt with by asking the user to input a value, and then looping to said position and appending it after. Though, it requires the user to input the element before where you want the actual element to be inserted (to insert as first element, need to input -1 as input, etc., as it appends after the given position)
•	To mimic a normal vector, only allowed insertion and deletion at the end. For insertion it just tried to add to next free position, though if it cannot fit it, it calls a resize function that doubles the size and copies all data over. 
•	For deletion I implemented it in a way that simply says the object has 1 less item than it actually has, this ensures user cannot access that position of vector (due to checks on read function), and it effectively has deleted that data since the next time the user inputs something and it reaches that position it would have overridden whatever data used to be there.
•	Generally I added functions to both as I saw fit as something necessary or usual to be found in such data structures, such as overriding [] for vectors to allow for such notation to be used for reading, and ability to append directly to front and end of list for convenience of not having to input a specific position, as it may not even necessary be known.

#Problems that occurred
•	A problem occurred when printing out the entire vector, wherein it would print say -842150451, which was not inputted into it. Debugging that lead to conclusion there was an issue with the resize function, more specifically because resize calls the copy constructor to copy over values from old to new bigger vector, but the copyVector function that is used in it was faulty as an incorrect vector was passed in.
•	A problem also occurred when printing out lists, in that it entered an infinite loop when printing first element. Debugging revealed issue was in the append function, specifically when inserting at start, this being because of a coding error in which I forgot to make it iterate to the next node
