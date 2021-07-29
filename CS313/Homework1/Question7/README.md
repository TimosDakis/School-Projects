# Problem (Question 7):
- Compare a similar operation on a large scale between three standard c++ containers

# Comparing:
- Comparing insertion to end of a vector, forward list, and set

# Hypothesis:
Forward list should have fastest insertion to end, as its dynamic and not continuous in memory, so it never needs to resize, and can keep adding to end in constant time. Vector should be a bit slower, because while it can access the end directly, like list, it suffers from the need to resize at times, which will make it slightly slower. Set should be slowest, as it needs to sort as it inserts, so will need to do a number of comparisons before it can finally insert at the end, so it should effectively be linear time insertion.

# Results:
- Test done by inserting numbers 0-999999 in order into each container
    - In order to ensure it can be considered an “insertion to end” of set

Result was that list insertion was fastest, with vector slightly slower, and set insertion slightly slower than both
- These results largely align to my hypothesis, though the set was far faster than I expected, being very close to list and vector insertion
    - I suppose it is optimized for insertion to end like this, or just insertion in general, so it is faster than O(n)
