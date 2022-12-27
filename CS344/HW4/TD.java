import java.io.*;
import java.util.Random;

public class TD extends Thread {
	
	int id;
	
	// to write Objects
	private ObjectOutputStream oosTDtoTC;
	
	// to read Objects
	private ObjectInputStream oisTCtoTD;

	// to write raw bytes
	private OutputStream osTDtoTA;
	private OutputStream osTDtoTC;
	
	// to read raw bytes
	private InputStream isTBtoTD;
	private InputStream isTCtoTD;
	
	public TD(int id, ObjectOutputStream oosTDtoTC, ObjectInputStream oisTCtoTD, OutputStream osTDtoTA,
			OutputStream osTDtoTC, InputStream isTBtoTD, InputStream isTCtoTD) {
		this.id = id;
		this.oosTDtoTC = oosTDtoTC;
		this.oisTCtoTD = oisTCtoTD;
		this.osTDtoTA = osTDtoTA;
		this.osTDtoTC = osTDtoTC;
		this.isTBtoTD = isTBtoTD;
		this.isTCtoTD = isTCtoTD;
	} // end constructor
	
	public void run() {
		System.out.println("TD beginning execution, id = " + id);
		
		try {
			Random rand = new Random();
			
			oosTDtoTC = new ObjectOutputStream(osTDtoTC);
			oosTDtoTC.writeObject(new Message(rand.nextInt(300), id));
			
			osTDtoTA.write(rand.nextInt(300));
			
			oisTCtoTD = new ObjectInputStream(isTCtoTD);
			Message m = (Message) oisTCtoTD.readObject();
			System.out.println("TD with id = " + id + " has received message containing num = " + m.num + " sent by TC with id = " + m.id);
			
			int msg = (int) isTBtoTD.read();
			System.out.println( "TD reads: " + msg + " from TB" );
		} // end try
		catch(Exception e) {
			System.out.println(e);
		} // end catch
		
	} // end run method

} // end TD class