# Problem (Question 2):
-	Implement and compare recursive, iterative, and linked-list-based binary searches on cases of 1 million random numbers and 10 million random numbers

# Outcome:
-	On the same sorted dataset looking for the same number recursive binary search was slightly faster than iterative; however, linked list was substantially slower in comparison to either of them

# Design Overview and Approach:
-	For all searches it takes a left and right value to search in, inclusive, assuming zero-based indexing. It then calculates a middle index based off that
-	Then it checks if element at that middle index is the target, if it is search finishes. If target smaller, set right to 1 before mid and start searching between that new left and right range, likewise if target is bigger, set left to 1 after mid and start searching between that new left and right range
-	To determine that nothing is found, checks when left index becomes larger than right index, because when that occurs the search would start double counting sides (it overlaps, meaning no item was found)
-	For linked-based search had 4 cases to consider: 
    -	if item was found (finishes)
    -	if next element is greater (or does not exist due to being at right end of list) then decrease right so it is 1 before mid
    -	if next element is smaller (or does not exist due to being at left end of list) then increase left so it is 1 after mid
        - Due to having no ability to check previous nodes due to being a singly linked list, this was implemented to occur if the above case was false
    -	If no item is found 
-	To implement link-based took an iterative approach, as that made most sense, and essentially had a while loop that continued infinitely until no item was found, determined by left becoming larger than right
    -	Each iteration, looped through the entire list until reached node that middle index referred to, then compared to see if it exists, if not then if next node was greater or did not exist, and if not then just assumed element was smaller
        -	If it was found, returned true, otherwise updated the left or right values then started a new iteration, and repeat until found or not found
 
