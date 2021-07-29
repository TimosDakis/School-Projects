# Problem (Question 12):
- Design a doubly linked list and implement insertion and deletion, where insertion inputs appointments at the correct time, and if not possible the closest free time that works

# Design Overview and Approach:
- So basically, what I did for this is set up 10 sentinel nodes that keep track of the start and end of each of the work days. Each day gets 2 nodes, one to keep track of start of the day and one to keep track of the day
    - This was done to ensure all appointments stayed within the time boundary, but also allow the ability to track day differences and insert in correct relative positions
- Insertion the breaks down into four cases, with three modules
    - The cases are: insertion at wanted time; not wanted time but same day; not wanted time but different day; cannot fit in schedule
- The first module is attempting to insert at the desired spot
    - To do this first set up a node that iterates until it reaches the start of the correct day, then store this node somewhere else for future modules if first fails
    - After that, iterate through the entire day and check if the slot is open by seeing if wanted time fits between end of current node and end of next node
        - if it does insert and exit function, if no slot is open continue to 2nd module
- The second module is attempt to insert on the same day, at the closest available spot
    - First figure out where conflict occurs, and store that in a separate node to reuse later in 3rd module, if this fails
    - After create two temporary nodes, one which will look forward in the day to see if it can insert something, and one which will look earlier in the day to see if it can insert something
        - Also create a node which will point to the location in list we will insert the new appointment time before or after, if found
    - Then first check looking forward, starting at conflict node and going to end of day
        - If a spot is found, store that location in a node for later use
        - If not (reaches end), delete the temporary node
    - After, repeat the same process, but go in reverse ending at start of the day
    - After this, if a location for insertion is found in both points, closest is determined based on original start time of appointment. If it was in first half of the work day, will insert it backward, otherwise forward and exits function
        - If only one point found, default to that and exit function
        - If no point found, continue to third module
- The third module is attempt to insert on different day, at closest available spot
    - Set up two counters to track wait time, one for each direction
    - Also set up the temporary nodes again for looking forward and backward
    - After, looks forward for closest time starting from conflict, increasing wait time as it goes on. Stops looking once it reaches conflict node again
    - Then repeats looking backwards
    - If one insertion point found in each direction, insert at point with least wait time
        - If only one insertion point found, insert there and exit function
        - If no insertion point found, becomes case 4: no space for appointment
- Deletion was done fairly simply, you input the appointment number you want to delete, and it iterates until it reaches it to delete

# Problems:
- The first major issue I had was trying to figure out how to insert things in a sorted fashion, and to determine which is closest insertion point if it cannot insert where wanted
    - This is what the 10 sentinel nodes serve to fix. It ensure all appoints of the same day are sorted in their section of the list in the correct order, making it easy to determine where to insert things, and where closest insertion points would be
- The next issue I had was trying to check if the start and end times of appointments would fit the boundary created by two other appointments (e.g., if you had an appointment between 9:00-9:30 and another at 10:00-10:30, how to determine if a 9:30-10:30 appointment fits in between)
    - The solution for this was some somewhat complicated if statements, due to the way I implemented start and end times of appointments, since I track the hours and minutes separately
    - So essentially to determine if it is in the boundary I first check the hours to see if its within that boundary, though if the hours are the same I look specifically at minutes to see if it fits within the boundaries
