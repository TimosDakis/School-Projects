import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class StudentClient extends Thread {

	private int port;
	private String address;
	private int threadId;
	
	StudentClient(int threadId, String address, int port){
		setName("Student-" + threadId + "-Client");
		this.threadId = threadId;
		this.address = address;
		this.port = port;
	}
	
	public void run() {
		System.out.println(getName() + " attempting to connect to server");
		try(
			// set up socket and input and output streams
			Socket studentSocket = new Socket(address, port);
			PrintWriter out = new PrintWriter(studentSocket.getOutputStream(), true);
			BufferedReader in = new BufferedReader(new InputStreamReader(studentSocket.getInputStream()));
		) {
			System.out.println(getName() + " successfully connected to server");
			
			// send out thread type and then thread id to server helper
			out.println("Student");
			out.println(threadId);
			
			int methodCount = 0;
			
			// loop while still getting inputs
			while(in.readLine() != null){
				// if all methods executed break, else send method to execute to server helper
				if(methodCount <= 6) {
					System.out.println(getName() + " is requesting helper to execute method " + methodCount);
					out.println(getName() + " " + methodCount);					
				} // end if
				else break;
				methodCount++;
			} // end while
			
			System.out.println(getName() + " finished executing all methods - disconnecting from server");
		} // end try
		catch(Exception e) {	
			e.printStackTrace();	
		} // end catch
	} // end run method	
} // end StudentClient class
