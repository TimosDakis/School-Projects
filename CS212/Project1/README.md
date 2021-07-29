**Project Requirements**
# Sorting an Array of Clocks/ Displaying in a GUI/Creating a Class
Create a class called Clock to represent a Clock. It should have three private instance variables: An int
for the hours, an int for the minutes, and an int for the seconds. The class should include a threeargument constructor and get and set methods for each instance variable. Override the method toString
which should return the Clock information in the same format as the input file (See below).
Read the information about a Clock from a file that will be given to you on Blackboard, parse out the
three pieces of information for the Clock using a StringTokenizer, instantiate the Clock and store the
Clock object in two different arrays (one of these arrays will be sorted in a later step). Once the file has
been read and the arrays have been filled, sort one of the arrays by hours using Selection Sort.
Display the contents of the arrays in a GUI that has a GridLayout with one row and two columns. The
left column should display the Clocks in the order read from the file, and the right column should display
the Clocks in sorted order.

**The input file**

Each line of the input file will contain information about a Clock, with each piece of information
separated by a colon. An example of the input file would be:
12:31:19
17:23:19
If the line of the file does not have exactly three tokens, do not put it in the arrays; print it to the console.
