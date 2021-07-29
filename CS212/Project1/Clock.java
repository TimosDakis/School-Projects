
/**
 * 
 * @date 03/05/2020
 * @author timothydakis
 * @LabSection 12a
 * 
 * @Description this class is solely for creating Clock objects and contains a toString method for printing
 * 
 */

public class Clock {
	
	private int hour, minute, sec;
	
	//3 argument constructor for creating a Clock
	Clock(int h, int m, int s){
		
		hour = h;
		minute = m;
		sec = s;
		
	}
	
	//sets hour
	public void setHour(int h) {
		hour = h;
	}
	
	//gets hour
	public int getHour() {
		return hour;
	}
	
	//sets minutes
	public void setMinute(int m) {
		minute = m;
	}
	
	//gets minutes
	public int getMinute() {
		return minute;
	}
	
	//set seconds
	public void setSec(int s) {
		sec = s;
	}
	
	//gets seconds
	public int getSec() {
		return sec;
	}
	
	
	/**
	 * 
	 * @Description Takes a Clock object and converts each part of it individually to a string then concatenates it into a full time of XX:XX:XX format
	 * 
	 */
	
	//overrides toString from Object to print Clocks
	public String toString() {
		//converts hour, minute and sec individually to strings and splits them with colons
		String stringHour, stringMinute, stringSecond;
		
		
		//this just ensures that the string is always double digit for each section of the time
		if(hour < 10) stringHour = "0" + Integer.toString(hour); //if hour is single digit, add a 0 to it as a string
		else stringHour = Integer.toString(hour);
		
		if(minute < 10) stringMinute = "0" + Integer.toString(minute); //if minute is single digit, add a 0 to it as a string
		else stringMinute = Integer.toString(minute);
		
		if(sec < 10) stringSecond = "0" + Integer.toString(sec); //if second is single digit, add a 0 to it as a string
		else stringSecond = Integer.toString(sec);
		
		//return (Integer.toString(hour) + ":" + Integer.toString(minute) + ":" + Integer.toString(sec));
		return(stringHour + ":" + stringMinute + ":" + stringSecond);
	}
}
