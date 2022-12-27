import java.util.Arrays;

public class Student extends Thread {
	
	private int threadId;
	private int groupNum;
	private int numCandy = 0;
	
	public Student(int threadId) {
		this.threadId = threadId;
		setName("Student-" + threadId);
		msg("has arrived");
	}
	
	 public void msg(String m) {
		 System.out.println("["+(System.currentTimeMillis()-Main.time)+"] "+getName()+": "+m);
	 }
	 
	 @Override
	 public void run(){
		 
		 msg("commuting to school");
		 try {
			 sleep(500 + Main.rand.nextInt(500));
		 } // end try
		 catch(InterruptedException e) {
			 e.printStackTrace();
		 } // end catch
		
		 // ME over counter between students and the notification object all students wait on
		 synchronized(Main.studentWaitsForLecture) {
			 msg("entering home room");
			 
			 // ME over counter between teacher and student
			 synchronized(Main.teacherWaitsForStudents) {
				 Main.numStudentsWaitingForLecture++;
				 // if all students are now in home room, notify teacher they have all arrived arrived
				 if(Main.numStudentsWaitingForLecture == Main.numStudents) {
					 msg("telling teacher all students lined up");
					 Main.teacherWaitsForStudents.notify();
				 } // end if
			 } // end synchronized
			
			 // wait until signaled
			 msg("waiting for lecture");
			 while(true) {
				 try {
				     Main.studentWaitsForLecture.wait();
					 break;	
				 } // end try
				 catch(InterruptedException e) {	
					 continue;
				 } // end catch
			 } // end while
		 } // end synchronized
		 
		 Object objectToWaitOn = new Object();
		 
		 // ME over notification object between student and teacher
		 synchronized(objectToWaitOn) {
			 
			 // adds object that student waits on to a queue in a ME way
			 addToQueue(objectToWaitOn);
			 
			 // use notification object for ME over shared queue
			 // if all students are lined up for candy, inform teacher
			 synchronized(Main.teacherWaitsForStudents) {
				 if(Main.studentsWaitsForTeacherCandy.size() == Main.numStudents) {
					msg("tells teacher all students in line for candy");
					Main.teacherWaitsForStudents.notify();
				 } // end if
			 }
			 
			 while(true) {
				 try {
					objectToWaitOn.wait();
					break;	
				 } // end try
				 catch(InterruptedException e) {	
					 continue;
				 } // end catch
			 } // end while

		 } // end synchronized
		 
		 groupNum = 1 + Main.rand.nextInt(Main.numGroups);
		 msg("is part of group " + groupNum);
		 
		 // set up tracker to know total number of students per group
		 synchronized(Main.mutexForTotalStudentsInGroup) {
			 Main.totalStudentsInGroup[groupNum - 1]++;
		 }
		 
		 // loops until all rounds are done
		 for(int i = 0; i < Main.numHouses; i++) {
			 
			 // ME between students of same group
			 synchronized(Main.studentGroupsWaitForHouses[groupNum - 1]) {
				 
				 msg("in round " + (i+1) + "/" + Main.numHouses + " of picking candy");
				 
				 // ME between all houses and students
				 synchronized(Main.houseWaitsForStudentsToGroup){
					 
					 Main.numStudentsWaitingForHouse++;
					 
					 // if everyone is at start of current round, reset all trackers / counters and release the houses to start the round
					 if(Main.numHousesWaitingForStudents == Main.numHouses && Main.numStudentsWaitingForHouse == Main.numStudents) {
						 Main.resetRoundTrackersAndCounters();
						 Main.houseWaitsForStudentsToGroup.notifyAll();
					 } // end if
					 
				 } // end synchronized
				 
				 Main.currentStudentsInGroup[groupNum - 1]++;
				 
				 // student waits to be called by house
				 while(true) {
					 try {
						 Main.studentGroupsWaitForHouses[groupNum - 1].wait();
						 break;
					 } // end try
					 catch (InterruptedException e) {
						 continue;
					 } // end catch
				 } // end while
				 
				 // if notified but not "picked", go to next round
				 if(!Main.studentGroupCalledInRound[groupNum - 1]) {
					 msg("no free houses left, waiting for next round of candy");
					 continue;
				 } // end if
				 
			 } // end synchronized
			 
			 msg("picking candy");
			 
			 try {
				sleep(500 + Main.rand.nextInt(500));
			 } 
			 catch (InterruptedException e) {
				e.printStackTrace();
			 }
			 
			 numCandy += 1 + Main.rand.nextInt(10);
			 msg("candy picked");
			 
			 // ME over tracking how many students in a group picked candy
			 synchronized(Main.mutexForCandyPickingInGroup) {
				 Main.amountOfStudentsThatPickedCandyInGroup[groupNum - 1]++;
				 
				 // if all students in group picked candy, notify the house
				 if(Main.amountOfStudentsThatPickedCandyInGroup[groupNum - 1] == Main.totalStudentsInGroup[groupNum - 1]) {
					 Main.amountOfStudentsThatPickedCandyInGroup[groupNum - 1] = 0;
					 synchronized(Main.houseWaitsForStudentsToPickCandy[groupNum - 1]) {
						 Main.houseWaitsForStudentsToPickCandy[groupNum - 1].notify();

					 } // end synchronized
				 } // end if
				 
			 } // end synchronized
			 
		 } // end for
		 
		 msg("done collecting candy this Halloween, collected a total of " + numCandy);
		 
		 // ME over totaling and averaging the candy
		 synchronized(Main.studentWaitsForAverages) {
			 
			 // add candy to group's total
			 Main.groupTotalCandyCount[groupNum - 1] += numCandy;
			 Main.amountOfStudentsThatTotaledCandyInGroup[groupNum - 1]++;
			 
			 // if all members of group added candy to pile, figure out the average
			 if(Main.amountOfStudentsThatTotaledCandyInGroup[groupNum - 1] == Main.totalStudentsInGroup[groupNum - 1]) {
				 // if the group had 0 candy total, then average is 0, else its total candy / group size
				 Main.groupAverageCandyCount[groupNum - 1][0] = Main.groupTotalCandyCount[groupNum - 1] == 0 ? 0 : Main.groupTotalCandyCount[groupNum - 1] / Main.totalStudentsInGroup[groupNum - 1];
				 // track the group id associated with the average
				 Main.groupAverageCandyCount[groupNum - 1][1] = groupNum;
				 
				 msg("each person in group " + groupNum + " gets " + Main.groupAverageCandyCount[groupNum - 1][0] + " candy each");
			 } // end if
			 
			 Main.numStudentsThatTotaledCandy++;
			 
			 // if all members of every group averaged their candy, final student sorts average array and signals all students
			 if(Main.numStudentsThatTotaledCandy == Main.numStudents) {
				 Arrays.sort(Main.groupAverageCandyCount, (a, b) -> Integer.compare(b[0], a[0]));
				 Main.studentWaitsForAverages.notifyAll();
			 } // end if
			 else {
				 while(true) {
					 try {
						 Main.studentWaitsForAverages.wait();
						 break;
					 } // end try
					 catch (InterruptedException e) {
						 continue;
					 } // end catch
				 } // end while
			 } // end else
			 
		 } // end synchronized
		 
		 // all students block one 1 object, use condition to determine which students can exit to enforce order
		 synchronized(Main.studentWaitsForTurnInOrder) {
			 
			 while(true) {
				 // checks if student is part of group with current highest average, if true then student can leave, else blocks
				 if(groupNum == Main.groupAverageCandyCount[Main.indexOfAvgCandyArray][1]) {
					 Main.numOfCurrentGroupThatLeft++;
					 // checks if student is final student of group to leave
					 if(Main.numOfCurrentGroupThatLeft == Main.totalStudentsInGroup[groupNum - 1]) {
						 // if true, increase index to get to next highest and reset counter
						 Main.indexOfAvgCandyArray++;
						 Main.numOfCurrentGroupThatLeft = 0;
					 } // end if
					 break;
				 } // end if
				 else {
					 try {
						 Main.studentWaitsForTurnInOrder.wait();
					 } // end try
					 catch (InterruptedException e) {
						 continue;
					 } // end catch
				 } // end else
			 } // end while
			 
			 // notify all students so they can re-check if able to leave after current student goes home
			 Main.studentWaitsForTurnInOrder.notifyAll();
			 msg("my group is " + groupNum + " and I am going home now");
			
		 } // end synchronized
		 
	 } // end run method
	 
	 // adds object to queue in a ME way
	 private void addToQueue(Object o) {
		 // ME between teacher and students over shared queues
		 synchronized(Main.teacherWaitsForStudents) {
			 msg("gets in line for candy");
			 Main.studentsWaitsForTeacherCandy.add(o);
			 Main.studentIds.add(threadId);
		 } // end synchronized
	 } // end addToQueue method
	 
} // end Student class