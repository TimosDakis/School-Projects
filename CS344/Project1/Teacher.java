
public class Teacher extends Thread {

	public Teacher() {
		 setName("Teacher");
		 msg("has arrived");
	}
	
	 public void msg(String m) {
		 System.out.println("["+(System.currentTimeMillis()-Main.time)+"] "+getName()+": "+m);
	 }

	 @Override
	 public void run() {
		 
		 // Use ME to access shared count variable
		 synchronized(Main.teacherWaitsForStudents) {
			 // if students still have not arrived yet, wait until notified they arrive
			 if(Main.numStudentsWaitingForLecture < Main.numStudents) {
				msg("waiting for students");
				while(true) { 
					try {
						Main.teacherWaitsForStudents.wait();
						break;
					} // end try
					catch(InterruptedException e) {
						continue; 
					} // end catch
				} // end while
			} // end if
		 } // end synchronized
		 
		// sleep to simulate time to do lecture 
		msg("all students have arrived, beginning lecture"); 
		try {
			sleep(500 + Main.rand.nextInt(500));
		} 
		catch (InterruptedException e) {
			e.printStackTrace();
		} // end catch
		
		msg("lecture over, tell students to line up for candy");
		
		// notify all students
		synchronized(Main.studentWaitsForLecture) {
			Main.studentWaitsForLecture.notifyAll();
		}
		
		// Use ME to access shared queue of notification objects
		synchronized(Main.teacherWaitsForStudents) {
			// check if all students lined up for candy yet, if no, then wait
			if(Main.studentsWaitsForTeacherCandy.size() < Main.numStudents) {
				msg("wait for students to line up for candy");
				while(true) { 
					try { 
						Main.teacherWaitsForStudents.wait();
						break; 
					} // end try
					catch(InterruptedException e) {
						continue; 
					} // end catch
				} // end while
			} // end if
		} // end synchronized
		
		// looping until all students are handed candy
		for(int i = 0; i < Main.numStudents; i++) {
			msg("giving candy to student with id " + Main.studentIds.remove());
			synchronized(Main.studentsWaitsForTeacherCandy.peek()) {
				Main.studentsWaitsForTeacherCandy.peek().notify();
			}
			Main.studentsWaitsForTeacherCandy.remove();
		} // end for
		
		msg("goes home");
		 
	 } // end run method
	
} // end Teacher class