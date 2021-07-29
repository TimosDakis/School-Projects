# Problem (Question 13):
- Make a function that fills two doubly linked lists, one with workers and the other with their jobs, then show how to shift the job list backward when needed (so worker 4 gets job 3, etc., after first shift back)

# Design Overview and Approach:
- To fill the lists, for each list inserted worker x or job x, then when printing printed them both so workers are aligned with the correct job
- To simulate shifting job list back by one, I just delete the last node and append a node to the front of the list with its data
    - This really shifts the list forward, but simulates turning it backwards due to how it aligns all workers and jobs in the end, since the end of the list was moved to the front, which shifts everything back, as it effectively shifts workers to previous job
