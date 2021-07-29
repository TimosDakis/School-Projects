# Problem (Question 5):
- Create a multilevel sort and compare it to two other sorts
    - I decided to compare it to a bubble sort (as like my sort, it is also an O(n2) sort), as well as algorithms library sort as it is the sort I typically use

# Outcome:
- Algorithm library sort was significantly faster than my multilevel sort, and my multilevel sort was significantly faster than a bubble sort when timed sorting same data

# Design Overview and Approach:
- The idea behind my multilevel sort was to combine a selection sort and an insertion sort, where 95% of the array’s data is sorted via selection sort, and the final 5% Is done via insertion sort
    - This was to benefit from the fewer swaps required of selection sort, but also capitalize on insertion sorts efficiency when it comes to largely sorted data sets as well as small data sets
