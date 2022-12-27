import java.io.*;

public class PipeConnector {
	
	// declaring all pipe and object streams
	static private PipedInputStream pisTBtoTA;
	static private PipedOutputStream posTBtoTA;
	
	static private PipedInputStream pisTBtoTC;
	static private PipedOutputStream posTBtoTC;
	
	static private PipedInputStream pisTBtoTD;
	static private PipedOutputStream posTBtoTD;
	
	static private PipedInputStream pisTCtoTD;
	static private PipedOutputStream posTCtoTD;
	
	static private PipedInputStream pisTDtoTC;
	static private PipedOutputStream posTDtoTC;
	
	static private PipedInputStream pisTDtoTA;
	static private PipedOutputStream posTDtoTA;
	
	static private ObjectOutputStream oosTBtoTA;
	static private ObjectInputStream oisTBtoTA;

	static private ObjectOutputStream oosTCtoTD;
	static private ObjectInputStream oisTCtoTD;

	static private ObjectOutputStream oosTDtoTC;
	static private ObjectInputStream oisTDtoTC;
	
	private static void PipeSetup() {
		try {
			posTBtoTA = new PipedOutputStream();
			pisTBtoTA = new PipedInputStream (posTBtoTA);
			
			posTBtoTC = new PipedOutputStream();
			pisTBtoTC = new PipedInputStream (posTBtoTC);
			
			posTBtoTD = new PipedOutputStream();
			pisTBtoTD = new PipedInputStream (posTBtoTD);
			
			posTCtoTD = new PipedOutputStream();
			pisTCtoTD = new PipedInputStream (posTCtoTD);
			
			posTDtoTC = new PipedOutputStream();
			pisTDtoTC = new PipedInputStream (posTDtoTC);
			
			posTDtoTA = new PipedOutputStream();
			pisTDtoTA = new PipedInputStream (posTDtoTA);
		} // end try
		catch(Exception e) {
			System.out.println(e);
		} // end catch
		
	} // end PipeSetup method
	
	public static void main(String[] args) {
		
		PipeSetup();
		
		// create the thread objects
		try {
			int threadID = 1;
			
			System.out.println("Creating TA with id " + threadID);
			TA ta = new TA(threadID++, oisTBtoTA, pisTBtoTA, pisTDtoTA);
			
			System.out.println("Creating TB with id " + threadID);
			TB tb = new TB(threadID++, oosTBtoTA, posTBtoTA, posTBtoTC, posTBtoTD);
			
			System.out.println("Creating TC with id " + threadID);
			TC tc = new TC(threadID++, oosTCtoTD, oisTDtoTC, posTCtoTD, pisTBtoTC, pisTDtoTC);
			
			System.out.println("Creating TD with id " + threadID);
			TD td = new TD(threadID++, oosTDtoTC, oisTCtoTD, posTDtoTA, posTDtoTC, pisTBtoTD, pisTCtoTD);
			
			ta.start();
			tb.start();
			tc.start();
			td.start();
		} // end try
		catch(Exception e) {
			System.out.println(e);
		} // end catch

	} // end main method

} // end PipeConnector class
