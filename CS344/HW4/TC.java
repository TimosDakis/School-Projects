import java.io.*;
import java.util.Random;

public class TC extends Thread {
	
	int id;
	
	// to write Objects
	private ObjectOutputStream oosTCtoTD;
	
	// to read Objects
	private ObjectInputStream oisTDtoTC;
	
	// to write raw bytes
	private OutputStream osTCtoTD;
	
	// to read raw bytes
	private InputStream isTBtoTC;
	private InputStream isTDtoTC;
	
	public TC(int id, ObjectOutputStream oosTCtoTD, ObjectInputStream oisTDtoTC, OutputStream osTCtoTD,
			InputStream isTBtoTC, InputStream isTDtoTC) {
		this.id = id;
		this.oosTCtoTD = oosTCtoTD;
		this.oisTDtoTC = oisTDtoTC;
		this.osTCtoTD = osTCtoTD;
		this.isTBtoTC = isTBtoTC;
		this.isTDtoTC = isTDtoTC;
	} // end constructor
	
	public void run() {
		System.out.println("TC beginning execution, id = " + id);
		
		try {
			Random rand = new Random();
			
			oosTCtoTD = new ObjectOutputStream(osTCtoTD);
			oosTCtoTD.writeObject(new Message(rand.nextInt(300), id));
			
			oisTDtoTC = new ObjectInputStream(isTDtoTC);
			Message m = (Message) oisTDtoTC.readObject();
			System.out.println("TC with id = " + id + " has received message containing num = " + m.num + " sent by TD with id = " + m.id);
			
			int msg = (int) isTBtoTC.read();
			System.out.println( "TC reads: " + msg + " from TB" );
		} // end try
		catch(Exception e) {
			System.out.println(e);
		} // end catch
		
	} // end run method

} // end TC class
