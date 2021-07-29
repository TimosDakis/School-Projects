import java.util.StringTokenizer;

/**
 * 
 * @Date 03/05/2020
 * @author timothydakis
 * @LabSection 12a
 *
 *@Description: The program reads from a file to store into an array of Clocks which is then sorted and both arrays are printed to a ClockGUI. Incorrect file inputs are printed to console.
 *
 *
 */


public class Project1 {
	public static void main(String[] args) {
		
		String fileName = args[0];
		int hour, min, sec; //stores values that will be used to instantiate a Clock
		
		TextFileInput in = new TextFileInput(fileName);
		
		//to store the times in an array
		Clock[] times = new Clock[40];
		Clock[] timesSorted = new Clock[40];
		
		//tracker
		int timeCounter = 0; //tracks how many times are actually in input file, used for partially filled array
		
		String time = in.readLine();
		StringTokenizer tokenTracker = new StringTokenizer(time, ":");
		
		//this loop will go on until the Clock array is full or until there are no inputs left from file
		while(timeCounter < times.length && time != null) {
			tokenTracker = new StringTokenizer(time, ":");
			//if the string does not have 3 tokens, it will print it to console
			if(tokenTracker.countTokens() != 3) {
				System.out.println(time);
			}
			
			//if the string has 3 tokens, it will convert them to ints then construct a Clock and store it in the times Clock array
			else {
				//these convert the tokens of the string into ints to construct a Clock
				hour = Integer.parseInt(tokenTracker.nextToken());
				min = Integer.parseInt(tokenTracker.nextToken());
				sec = Integer.parseInt(tokenTracker.nextToken());
				
				//instantiates a new Clock and stores in array. It then increments the timeCounter
				times[timeCounter++] = new Clock(hour, min, sec); 
			}
			time = in.readLine(); //reads next line of file
		}
		
		
		in.close(); //closes file
		
		
		for(int i = 0; i < timeCounter; i++) timesSorted[i] = times[i]; //puts times into an array to be sorted
		
		selectionSort(timesSorted, timeCounter); //Sorts array via method
		
		ClockGUI clockGui = new ClockGUI(); //instantiates and ClockGUI
		clockGui.printClocks(clockGui, times, timesSorted, timeCounter); //prints both unsorted and sorted Clock arrays to ClockGUI
		
		
	}
		
	
	/**
	 * 
	 * @param timeArray this is the array of Clocks that needs to be sorted
	 * @param length this is the amount of Clocks in the array, used as partially filled array
	 * 
	 * @Description The method sorts the array by hours
	 */
	
	//sorts by hour
	private static void selectionSort(Clock[] timeArray, int length) {
		for ( int i = 0; i < length - 1; i++ ) { 
			int indexLowest = i; 
			for ( int j = i + 1; j < length; j++ ) {
				
				//Checks if current time has a smaller hour than the current smallest time
				if ( timeArray[j].getHour() < timeArray[indexLowest].getHour()) 
					indexLowest = j;
				}
			//if they are not the same time, it will swap the two elements in the array
			if ( timeArray[indexLowest] != timeArray[i] ) { 
				Clock temp = timeArray[indexLowest];
				timeArray[indexLowest] = timeArray[i]; 
				timeArray[i] = temp; 
			}  // if
		} // for i 
	}
}

	
