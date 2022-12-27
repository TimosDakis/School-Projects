import java.io.*;
import java.util.Random;

public class TB extends Thread {
	
	int id;
	
	// to write Objects
	private ObjectOutputStream oosTBtoTA;

	// to write raw bytes
	private OutputStream osTBtoTA;
	private OutputStream osTBtoTC;
	private OutputStream osTBtoTD;
	
	public TB(int id, ObjectOutputStream oosTBtoTA, OutputStream osTBtoTA, OutputStream osTBtoTC,
			OutputStream osTBtoTD) {
		this.id = id;
		this.oosTBtoTA = oosTBtoTA;
		this.osTBtoTA = osTBtoTA;
		this.osTBtoTC = osTBtoTC;
		this.osTBtoTD = osTBtoTD;
	} // end constructor

	public void run() {
		System.out.println("TB beginning execution, id = " + id);
		
		try {
			Random rand = new Random();
			
			oosTBtoTA = new ObjectOutputStream(osTBtoTA);
			oosTBtoTA.writeObject(new Message(rand.nextInt(300), id));
			
			osTBtoTC.write(rand.nextInt(300));
			
			osTBtoTD.write(rand.nextInt(300));
		} // end try
		catch(Exception e) {
			System.out.println(e);
		} // end catch
		
	} // end run method

} // end TB class
