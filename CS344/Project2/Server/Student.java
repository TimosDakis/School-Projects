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
		 System.out.println("["+(System.currentTimeMillis()-MainServer.time)+"] "+getName()+": "+m);
	 }
	 
	 @Override
	 public void run(){
		 commuteToSchool();
		 lineUpForLecture();
		 lineUpForTeachersCandy();
		 pickAGroup();
		 getCandyFromHouses();
		 averageCandyInGroup();
		 goHome();
	 } // end run method
	 
	 public void goHome() {
		// all students block one 1 object, use condition to determine which students can exit to enforce order
				 synchronized(MainServer.studentWaitsForTurnInOrder) {
					 
					 while(true) {
						 // checks if student is part of group with current highest average, if true then student can leave, else blocks
						 if(groupNum == MainServer.groupAverageCandyCount[MainServer.indexOfAvgCandyArray][1]) {
							 MainServer.numOfCurrentGroupThatLeft++;
							 // checks if student is final student of group to leave
							 if(MainServer.numOfCurrentGroupThatLeft == MainServer.totalStudentsInGroup[groupNum - 1]) {
								 // if true, increase index to get to next highest and reset counter
								 MainServer.indexOfAvgCandyArray++;
								 MainServer.numOfCurrentGroupThatLeft = 0;
							 } // end if
							 break;
						 } // end if
						 else {
							 try {
								 MainServer.studentWaitsForTurnInOrder.wait();
							 } // end try
							 catch (InterruptedException e) {
								 continue;
							 } // end catch
						 } // end else
					 } // end while
					 
					 // notify all students so they can re-check if able to leave after current student goes home
					 MainServer.studentWaitsForTurnInOrder.notifyAll();
					 msg("my group is " + groupNum + " and I am going home now");
					
				 } // end synchronized
	} // end goHome method

	public void averageCandyInGroup() {
		 // ME over totaling and averaging the candy
		 synchronized(MainServer.studentWaitsForAverages) {
			 
			 // add candy to group's total
			 MainServer.groupTotalCandyCount[groupNum - 1] += numCandy;
			 MainServer.amountOfStudentsThatTotaledCandyInGroup[groupNum - 1]++;
			 
			 // if all members of group added candy to pile, figure out the average
			 if(MainServer.amountOfStudentsThatTotaledCandyInGroup[groupNum - 1] == MainServer.totalStudentsInGroup[groupNum - 1]) {
				 // if the group had 0 candy total, then average is 0, else its total candy / group size
				 MainServer.groupAverageCandyCount[groupNum - 1][0] = MainServer.groupTotalCandyCount[groupNum - 1] == 0 ? 0 : MainServer.groupTotalCandyCount[groupNum - 1] / MainServer.totalStudentsInGroup[groupNum - 1];
				 // track the group id associated with the average
				 MainServer.groupAverageCandyCount[groupNum - 1][1] = groupNum;
				 
				 msg("each person in group " + groupNum + " gets " + MainServer.groupAverageCandyCount[groupNum - 1][0] + " candy each");
			 } // end if
			 
			 MainServer.numStudentsThatTotaledCandy++;
			 
			 // if all members of every group averaged their candy, final student sorts average array and signals all students
			 if(MainServer.numStudentsThatTotaledCandy == MainServer.numStudents) {
				 Arrays.sort(MainServer.groupAverageCandyCount, (a, b) -> Integer.compare(b[0], a[0]));
				 MainServer.studentWaitsForAverages.notifyAll();
			 } // end if
			 else {
				 while(true) {
					 try {
						 MainServer.studentWaitsForAverages.wait();
						 break;
					 } // end try
					 catch (InterruptedException e) {
						 continue;
					 } // end catch
				 } // end while
			 } // end else
			 
		 } // end synchronized
	} // end averageCandyInGroup method

	public void getCandyFromHouses() {
		 // loops until all rounds are done
		 for(int i = 0; i < MainServer.numHouses; i++) {
			 
			 // ME between students of same group
			 synchronized(MainServer.studentGroupsWaitForHouses[groupNum - 1]) {
				 
				 msg("in round " + (i+1) + "/" + MainServer.numHouses + " of picking candy");
				 
				 // ME between all houses and students
				 synchronized(MainServer.houseWaitsForStudentsToGroup){
					 
					 MainServer.numStudentsWaitingForHouse++;
					 
					 // if everyone is at start of current round, reset all trackers / counters and release the houses to start the round
					 if(MainServer.numHousesWaitingForStudents == MainServer.numHouses && MainServer.numStudentsWaitingForHouse == MainServer.numStudents) {
						 MainServer.resetRoundTrackersAndCounters();
						 MainServer.houseWaitsForStudentsToGroup.notifyAll();
					 } // end if
					 
				 } // end synchronized
				 
				 MainServer.currentStudentsInGroup[groupNum - 1]++;
				 
				 // student waits to be called by house
				 while(true) {
					 try {
						 MainServer.studentGroupsWaitForHouses[groupNum - 1].wait();
						 break;
					 } // end try
					 catch (InterruptedException e) {
						 continue;
					 } // end catch
				 } // end while
				 
				 // if notified but not "picked", go to next round
				 if(!MainServer.studentGroupCalledInRound[groupNum - 1]) {
					 msg("no free houses left, waiting for next round of candy");
					 continue;
				 } // end if
				 
			 } // end synchronized
			 
			 msg("picking candy");
			 
			 try {
				sleep(500 + MainServer.rand.nextInt(500));
			 } 
			 catch (InterruptedException e) {
				e.printStackTrace();
			 }
			 
			 numCandy += 1 + MainServer.rand.nextInt(10);
			 msg("candy picked");
			 
			 // ME over tracking how many students in a group picked candy
			 synchronized(MainServer.mutexForCandyPickingInGroup) {
				 MainServer.amountOfStudentsThatPickedCandyInGroup[groupNum - 1]++;
				 
				 // if all students in group picked candy, notify the house
				 if(MainServer.amountOfStudentsThatPickedCandyInGroup[groupNum - 1] == MainServer.totalStudentsInGroup[groupNum - 1]) {
					 MainServer.amountOfStudentsThatPickedCandyInGroup[groupNum - 1] = 0;
					 synchronized(MainServer.houseWaitsForStudentsToPickCandy[groupNum - 1]) {
						 MainServer.houseWaitsForStudentsToPickCandy[groupNum - 1].notify();

					 } // end synchronized
				 } // end if
				 
			 } // end synchronized
			 
		 } // end for
		 
		 msg("done collecting candy this Halloween, collected a total of " + numCandy);
	} // end getCandyFromHouses method

	public void pickAGroup() {
		 groupNum = 1 + MainServer.rand.nextInt(MainServer.numGroups);
		 msg("is part of group " + groupNum);
		 
		 // set up tracker to know total number of students per group
		 synchronized(MainServer.mutexForTotalStudentsInGroup) {
			 MainServer.totalStudentsInGroup[groupNum - 1]++;
		 }
	} // end pickAGroup()

	public void lineUpForTeachersCandy() {
		 Object objectToWaitOn = new Object();
		 
		 // ME over notification object between student and teacher
		 synchronized(objectToWaitOn) {
			 
			 // adds object that student waits on to a queue in a ME way
			 addToQueue(objectToWaitOn);
			 
			 // use notification object for ME over shared queue
			 // if all students are lined up for candy, inform teacher
			 synchronized(MainServer.teacherWaitsForStudents) {
				 if(MainServer.studentsWaitsForTeacherCandy.size() == MainServer.numStudents) {
					msg("tells teacher all students in line for candy");
					MainServer.teacherWaitsForStudents.notify();
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
		
	} // end lineUpForTeachersCandy method

	public void lineUpForLecture() {
		 // ME over counter between students and the notification object all students wait on
		 synchronized(MainServer.studentWaitsForLecture) {
			 msg("entering home room");
			 
			 // ME over counter between teacher and student
			 synchronized(MainServer.teacherWaitsForStudents) {
				 MainServer.numStudentsWaitingForLecture++;
				 // if all students are now in home room, notify teacher they have all arrived arrived
				 if(MainServer.numStudentsWaitingForLecture == MainServer.numStudents) {
					 msg("telling teacher all students lined up");
					 MainServer.teacherWaitsForStudents.notify();
				 } // end if
			 } // end synchronized
			
			 // wait until signaled
			 msg("waiting for lecture");
			 while(true) {
				 try {
				     MainServer.studentWaitsForLecture.wait();
					 break;	
				 } // end try
				 catch(InterruptedException e) {	
					 continue;
				 } // end catch
			 } // end while
		 } // end synchronized
	} // end lineUpForLecture method

	public void commuteToSchool() {
		 msg("commuting to school");
		 try {
			 sleep(500 + MainServer.rand.nextInt(500));
		 } // end try
		 catch(InterruptedException e) {
			 e.printStackTrace();
		 } // end catch
	} // end commuteToSchool method

	// adds object to queue in a ME way
	 private void addToQueue(Object o) {
		 // ME between teacher and students over shared queues
		 synchronized(MainServer.teacherWaitsForStudents) {
			 msg("gets in line for candy");
			 MainServer.studentsWaitsForTeacherCandy.add(o);
			 MainServer.studentIds.add(threadId);
		 } // end synchronized
	 } // end addToQueue method
	 
} // end Student class