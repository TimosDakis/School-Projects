
public class ClientManager {
	
	private static final int NUM_HOUSES = 4;
	private static final int NUM_STUDENTS = 20;
	private static final int PORT = 3000;
	private static final String ADDRESS = "localhost";
	
	public static void main(String[] args) {
		
		// starts all client threads
		
		new TeacherClient(ADDRESS, PORT).start();
		
		for(int i = 0; i < NUM_HOUSES; i++) {
			new HouseClient(i+1, ADDRESS, PORT).start();
		} // end for
		
		for(int i = 0; i < NUM_STUDENTS; i++) {
			new StudentClient(i+1, ADDRESS, PORT).start();
		} // end for
	} // end main method
} // end ClientManager class
