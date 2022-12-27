import java.io.IOException;
import java.net.ServerSocket;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Random;

public class MainServer {

	// relative time start
	public static long time = System.currentTimeMillis();
	
	// to find random numbers
	public static Random rand = new Random();
	
	// set default values to variables
	public static int numStudents = 20;
	public static int numHouses = 4;
	public static int numGroups = 5;
	
	// data structures to keep track of things between threads
	public static Queue<Object> studentsWaitsForTeacherCandy = new LinkedList<Object>(); // queue of notification objects
	public static Queue<Integer> studentIds = new LinkedList<Integer>(); // queue of student ids
	public static Object studentGroupsWaitForHouses[]; // array of notification objects
	public static boolean studentGroupCalledInRound[]; // tracks what groups were picked and served by a house
	public static int totalStudentsInGroup[]; // tracks how many students are in a group
	public static int currentStudentsInGroup[]; // tracks current number of students in a group
	public static Object houseWaitsForStudentsToPickCandy[]; // array of notification objects
	public static int amountOfStudentsThatPickedCandyInGroup[]; // tracks number of students that picked candy in a group
	public static int amountOfStudentsThatTotaledCandyInGroup[]; // tracks number of students that added their candy to their group's total
	public static int groupTotalCandyCount[]; // tracks total amount of candy in a group
	public static int groupAverageCandyCount[][]; // tracks average number of candy in a group, and which group that average belongs to
	
	// notification objects used only for ME
	public static Object mutexForTotalStudentsInGroup = new Object();
	public static Object mutexForPickingGroupToServe = new Object();
	public static Object mutexForCandyPickingInGroup = new Object();
	public static Object mutexForNumGroupsServed = new Object();
	
	// other notification objects also used for waiting on
	public static Object teacherWaitsForStudents = new Object();
	public static Object studentWaitsForLecture = new Object();
	public static Object houseWaitsForStudentsToGroup = new Object();
	public static Object studentWaitsForAverages = new Object();
	public static Object studentWaitsForTurnInOrder = new Object();
	
	// counters
	public static int numStudentsWaitingForLecture = 0;
	public static int numStudentsWaitingForHouse = 0;
	public static int numHousesWaitingForStudents = 0;
	public static int numGroupsPicked = 0;
	public static int numGroupsServed = 0;
	public static int numStudentsThatTotaledCandy = 0;
	public static int numOfCurrentGroupThatLeft = 0;
	public static int indexOfAvgCandyArray = 0;
	
	// other variables
	public static int maxNumberOfPairingsPerRound;
	
	public static void main(String[] args) throws IOException {
		
		// determine how many houses can serve a group per round at most
		maxNumberOfPairingsPerRound = (numHouses > numGroups) ? numGroups : numHouses;
		
		// initialize all data structures
		
		studentGroupsWaitForHouses = new Object[numGroups];
		houseWaitsForStudentsToPickCandy = new Object[numGroups];
		groupAverageCandyCount = new int[numGroups][2];
		for(int i = 0; i < numGroups; i++) {
			studentGroupsWaitForHouses[i] = new Object();
			houseWaitsForStudentsToPickCandy[i] = new Object();
			// set average to -1 by default, so if no students chose that group it gets sorted to end and does not affect exit order
			groupAverageCandyCount[i][0] = -1;
		}
		
		studentGroupCalledInRound = new boolean[numGroups];
		totalStudentsInGroup = new int[numGroups];
		currentStudentsInGroup = new int[numGroups];
		amountOfStudentsThatPickedCandyInGroup = new int[numGroups];
		amountOfStudentsThatTotaledCandyInGroup = new int[numGroups];
		groupTotalCandyCount = new int[numGroups];
		
		
		// dealing with server-client stuff
		int portNumber = 3000;
		int totalHelpersNeeded = 1 + numHouses + numStudents;
		
		System.out.println("Server start");
		
		// make a server socket. Keep it open until all server-helpers and clients are paired
		try(ServerSocket serverSocket = new ServerSocket(portNumber)){
			for(int i = 0; i < totalHelpersNeeded; i++) {
				System.out.println("Waiting for a client to send request");
				// create a new helper thread when a client sends a request
				new SubServerThread(serverSocket.accept()).start();
				System.out.println("Client request accepted");
			} // end for
		} // end try
		catch (IOException e) {
			System.err.println("Cannot listen to port " + portNumber);
			e.printStackTrace();
		} // end catch
		System.out.println("Server closing as all server-helper and client connections established");
	} // end main method
	
	// resets all counter and tracking variables used each round between students and houses
	public static void resetRoundTrackersAndCounters() {
		 numHousesWaitingForStudents = 0;
		 numStudentsWaitingForHouse = 0;
		 numGroupsPicked = 0;
		 numGroupsServed = 0;
		 studentGroupCalledInRound = new boolean[numGroups];
	} // end resetRoundTrackersAndCounters method
} // end MainServer class
