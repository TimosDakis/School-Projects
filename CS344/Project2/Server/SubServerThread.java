import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class SubServerThread extends Thread {
	
	private static final String TEACHER = "Teacher";
	private static final String STUDENT = "Student";
	private static final String HOUSE = "House";
	private Object threadObj;
	private String threadType;
	private int threadId;
	Socket socket = null;
	
	SubServerThread(Socket socket){
		this.socket = socket;
	} // end constructor
	
	public void run() {
		try( 
			// set up input and output streams
			PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
			BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
		) {
			// tell helper connection established
			out.println("Connection established with helper thread");
			String inputLine;
			// read first input read to determine thread type
			threadType = in.readLine();
			
			// depending on thread type, create an object of that type. Also helper's name
			if(threadType.equalsIgnoreCase(HOUSE)) {
				threadId = Integer.parseInt(in.readLine());
				setName(threadType + "-" + threadId + "-Helper");
				threadObj = new House(threadId);
				System.out.println(getName() + " linked to " + ((House) threadObj).getName());
			} // end if
			else if(threadType.equalsIgnoreCase(STUDENT)) {
				threadId = Integer.parseInt(in.readLine());
				setName(threadType + "-" + threadId + "-Helper");
				threadObj = new Student(threadId);
				System.out.println(getName() + " linked to " + ((Student) threadObj).getName());
			} // end else if
			else if(threadType.equalsIgnoreCase(TEACHER)){
				setName(threadType + "-Helper");
				threadObj = new Teacher();
				System.out.println(getName() + " linked to " + ((Teacher) threadObj).getName());
			} // end else if
			
			int methodNumber = 0;
			
			// loop while getting inputs
			while((inputLine = in.readLine()) != null) {
				// parse last character of string for method number (works as no client needs >= 11 methods)
				methodNumber = Integer.parseInt(inputLine.substring(inputLine.length()-1));
				// run the method
				runMethod(methodNumber);
				// inform client method has finished executing
				out.println(getName() + " has finished method " + methodNumber);
				// print to console that method finished executing
				System.out.println(getName() + " has finished method " + methodNumber);
			} // end while
			
			// close socket
			System.out.println(getName() + " has finished its execution");
			socket.close();
		} // end try
		catch(IOException e) {
			e.printStackTrace();
		} // end catch
		
	} // end run method

	private void runMethod(int methodNumber) {
		// depending on methodNumber and threadType, execute a method on earlier created object 
		if(threadType.equalsIgnoreCase(HOUSE)) {
			switch(methodNumber) {
				case 0:
					((House) threadObj).getsReadyToGiveOutCandy();
					break;
				case 1:
					((House) threadObj).giveCandyToStudents();	
					break;
				case 2:
					((House) threadObj).goToBed();
					break;
			} // end switch
		} // end if
		else if(threadType.equalsIgnoreCase(STUDENT)) {
			switch(methodNumber) {
				case 0:
					((Student) threadObj).commuteToSchool();
					break;
				case 1:
					((Student) threadObj).lineUpForLecture();
					break;
				case 2:
					((Student) threadObj).lineUpForTeachersCandy();
					break;
				case 3:
					((Student) threadObj).pickAGroup();
					break;
				case 4:
					((Student) threadObj).getCandyFromHouses();
					break;
				case 5:
					((Student) threadObj).averageCandyInGroup();
					break;
				case 6:
					((Student) threadObj).goHome();
					break;
			} // end switch
		} // end if
		else if(threadType.equalsIgnoreCase(TEACHER)){
			switch(methodNumber) {
				case 0:
					((Teacher) threadObj).waitForStudentsToArrive();
					break;
				case 1:
					((Teacher) threadObj).lectureStudents();
					break;
				case 2:
					((Teacher) threadObj).waitForStudentsToLineUp();
					break;
				case 3:
					((Teacher) threadObj).giveStudentsCandy();
					break;
			} // end switch
		} // end if
	} // end runMethod method
} // end SubServerThread class
