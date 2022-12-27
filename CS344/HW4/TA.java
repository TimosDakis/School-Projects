import java.io.*;

public class TA extends Thread {
	
	int id;
	
	// to read Objects
	private ObjectInputStream oisTBtoTA;

	// to read raw bytes
	private InputStream isTBtoTA;
	private InputStream isTDtoTA;
	
	public TA(int id, ObjectInputStream oisTBtoTA, InputStream isTBtoTA, InputStream isTDtoTA) {
		this.id = id;
		this.oisTBtoTA = oisTBtoTA;
		this.isTBtoTA = isTBtoTA;
		this.isTDtoTA = isTDtoTA;
	} // end constructor
	
	public void run() {
		System.out.println("TA beginning execution, id = " + id);
		
		try {
			oisTBtoTA = new ObjectInputStream(isTBtoTA);
			Message m = (Message) oisTBtoTA.readObject();
			System.out.println("TA with id = " + id + " has received message containing num = " + m.num + " sent by TB with id = " + m.id);
			
            int msg = (int) isTDtoTA.read();
            System.out.println( "TA reads: " + msg + " from TD" );
		} // end try
		catch(Exception e) {
			System.out.println(e);
		} // end catch
		
	} // end run method

} // end TA class