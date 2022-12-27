
public class House extends Thread{
	
	private int lastPickedGroup = 0;
	boolean skippedRound = false;

	public House(int threadId) {
		 setName("House-" + threadId);
		 msg("has arrived");
	}
	
	 public void msg(String m) {
		 System.out.println("["+(System.currentTimeMillis()-Main.time)+"] "+getName()+": "+m);
	 }
	 
	 @Override
	 public void run() {
		 
		 // loop until all rounds done
		 for(int i = 0; i < Main.numHouses; i++) {
			 
			 msg("in round " + (i+1) + "/" + Main.numHouses + " of giving candy");
			 
			 // ME between all houses and students
			 synchronized(Main.houseWaitsForStudentsToGroup){
				 
				 Main.numHousesWaitingForStudents++;
				 
				 // if everyone is at start of current round, reset all trackers / counters and release the houses to start the round
				 if(Main.numHousesWaitingForStudents == Main.numHouses && Main.numStudentsWaitingForHouse == Main.numStudents) {
					 Main.resetRoundTrackersAndCounters();
					 Main.houseWaitsForStudentsToGroup.notifyAll();
				 } // end if
				 else {
					 while(true) {
						 try {
							 Main.houseWaitsForStudentsToGroup.wait();
							 break;
						 } // end try
						 catch (InterruptedException e) {
							 continue;
						 } // end catch
					 } // end while
				 } // end else
				 
			 } // end synchronized
			 
			 // ME over picking a group
			 synchronized(Main.mutexForPickingGroupToServe) {
				 
				 // check case of more houses than students, if all groups have been paired, then house goes to next round
				 if(Main.numGroupsPicked == Main.maxNumberOfPairingsPerRound) {
					 msg("no groups left to call on, waiting for next round of groups");
					 continue;
				 }
				 
				 Main.numGroupsPicked++;
				 boolean picked = false;
				 int loopCount = 0;
				 
				 // loop until a group is picked
				 while(!picked) {
					 // compute a possible candidate, then check if it is valid (if not picked last round and not picked by anyone else this round)
					 int groupCandidate = 1 + Main.rand.nextInt(Main.numGroups);
					 
					 /*
					  *  edge case: final house only has 1 choice of group left and that group was last group it picked
					  *  resolution: reset lastPickedGroup so it can pick group it picked last time to prevent it getting stuck forever in while loop
					  */
					 
					 loopCount++;
					 if(loopCount >= Main.numGroups * 50) {lastPickedGroup = 0;}
					 
					 if((groupCandidate != lastPickedGroup) && !Main.studentGroupCalledInRound[groupCandidate - 1]) {
						 msg("giving candy to group " + groupCandidate);
						 lastPickedGroup = groupCandidate;
						 Main.studentGroupCalledInRound[groupCandidate - 1] = true;
						 picked = true;
					 } // end if
				 } // end while
				 
				 // if group picked by house is empty, go to next round
				 if(Main.totalStudentsInGroup[lastPickedGroup - 1] == 0) {
					 // if final house, release all students still blocked to proceed to next round
					 releaseAllUnpickedGroupsIfLastHouseToServe();
					 msg("noticed no students in their group, went to wait for next round");
					 continue;
				 } // end if
				 
			 } // end synchronized
			 
			 // house notifies all students of group
			 synchronized(Main.studentGroupsWaitForHouses[lastPickedGroup - 1]) {
				 Main.currentStudentsInGroup[lastPickedGroup - 1] = 0;
				 Main.studentGroupsWaitForHouses[lastPickedGroup - 1].notifyAll();
			 } // end synchronized
			 
			 msg("waiting for students to pick candy");
			 
			 // block while students pick candy
			 synchronized(Main.houseWaitsForStudentsToPickCandy[lastPickedGroup - 1]) {
				 while(true) {
					 try {
						 Main.houseWaitsForStudentsToPickCandy[lastPickedGroup - 1].wait();
						 break;
					 } // end try
					 catch (InterruptedException e) {
						 continue;
					 } // end catch
				 } // end while
			 } // end synchronized
			 
			 // if final house, release all students still blocked to proceed to next round
			 releaseAllUnpickedGroupsIfLastHouseToServe();
			 
		 } // end for
		 
		 msg("done giving out candy this Halloween, turning lights off and going to bed");
		 
	 } // end run method
	 
	 // deals with case of all groups served but still un-picked groups (i.e. numGroups > numHouses)
	 private void releaseAllUnpickedGroupsIfLastHouseToServe() {
		 // ME over tracking num of groups served
		 synchronized(Main.mutexForNumGroupsServed) {
			 
			 Main.numGroupsServed++;
			 // if all groups served, and there are still groups not picked => more groups than houses => notify all waiting groups to go next round
			 if(Main.numGroupsServed == Main.maxNumberOfPairingsPerRound && Main.studentGroupCalledInRound.length > Main.maxNumberOfPairingsPerRound) {
				 msg("telling all students not paired with a house to get ready for next round");
				 for(int j = 0; j < Main.studentGroupCalledInRound.length; j++) {
					 if(!Main.studentGroupCalledInRound[j]) {
						 synchronized(Main.studentGroupsWaitForHouses[j]) {
							 Main.studentGroupsWaitForHouses[j].notifyAll();
						 } // end synchronized
					 } // end if
				 } // end for
			 } // end if
			 
		 } // end synchronized
	 } // end releaseAllUnpickedGroupsIfLastHouseToServe method
 
} // end House class
