
public class Teacher extends Thread {

	public Teacher() {
		 setName("Teacher");
		 msg("has arrived");
	}
	
	 public void msg(String m) {
		 System.out.println("["+(System.currentTimeMillis()-MainServer.time)+"] "+getName()+": "+m);
	 }

	 @Override
	 public void run() {
		 waitForStudentsToArrive();
		 lectureStudents();
		 waitForStudentsToLineUp();
		 giveStudentsCandy();
	 } // end run method

	public void giveStudentsCandy() {
		// looping until all students are handed candy
		for(int i = 0; i < MainServer.numStudents; i++) {
			msg("giving candy to student with id " + MainServer.studentIds.remove());
			synchronized(MainServer.studentsWaitsForTeacherCandy.peek()) {
				MainServer.studentsWaitsForTeacherCandy.peek().notify();
			}
			MainServer.studentsWaitsForTeacherCandy.remove();
		} // end for
		
		msg("goes home");
	} // end giveStudentsCandy method

	public void waitForStudentsToLineUp() {
		// Use ME to access shared queue of notification objects
		synchronized(MainServer.teacherWaitsForStudents) {
			// check if all students lined up for candy yet, if no, then wait
			if(MainServer.studentsWaitsForTeacherCandy.size() < MainServer.numStudents) {
				msg("wait for students to line up for candy");
				while(true) { 
					try { 
						MainServer.teacherWaitsForStudents.wait();
						break; 
					} // end try
					catch(InterruptedException e) {
						continue; 
					} // end catch
				} // end while
			} // end if
		} // end synchronized
	} // end waitForStudentsToLineUp methods

	public void lectureStudents() {
		// sleep to simulate time to do lecture 
		msg("all students have arrived, beginning lecture"); 
		try {
			sleep(500 + MainServer.rand.nextInt(500));
		} 
		catch (InterruptedException e) {
			e.printStackTrace();
		} // end catch
		
		msg("lecture over, tell students to line up for candy");
		
		// notify all students
		synchronized(MainServer.studentWaitsForLecture) {
			MainServer.studentWaitsForLecture.notifyAll();
		}
	} // end lectureStudents method

	public void waitForStudentsToArrive() {
		 // Use ME to access shared count variable
		 synchronized(MainServer.teacherWaitsForStudents) {
			 // if students still have not arrived yet, wait until notified they arrive
			 if(MainServer.numStudentsWaitingForLecture < MainServer.numStudents) {
				msg("waiting for students");
				while(true) { 
					try {
						MainServer.teacherWaitsForStudents.wait();
						break;
					} // end try
					catch(InterruptedException e) {
						continue; 
					} // end catch
				} // end while
			} // end if
		 } // end synchronized
	} // end waitForStudentsToArrive method
	
} // end Teacher class