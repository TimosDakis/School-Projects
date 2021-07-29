import java.awt.*;
import javax.swing.*;

/**
 * 
 * @date 03/05/2020
 * @author timothydakis
 * @LabSection 12a
 * 
 * @Description Creates a GUI for printing Clock objects on a Grid Layout
 *
 */

public class ClockGUI extends JFrame {
	
	
	public ClockGUI(){
		
		setSize(1000, 400);
		setLocation(250, 250);
		setTitle("Times From File and Times Sorted");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}
	
	
	/**
	 * 
	 * @param cgui the ClockGUI being printed onto
	 * @param clock an array of Clock objects
	 * @param clockSorted the same array but sorted
	 * @param totalTimes the total times, used for partially filled array
	 * 
	 * @Description Takes two Clock arrays and prints them to a GUI with a 1x2 Grid Layout
	 * 
	 */
	
	public void printClocks(ClockGUI cgui, Clock[] clock, Clock[] clockSorted, int totalTimes) {
		
		//initialize();
		
		cgui.setLayout(new GridLayout(1, 2)); //creates a 1x2 grid layout
		Container myContentPane = cgui.getContentPane();
		TextArea times = new TextArea();
		TextArea timesSorted = new TextArea();
		//makes text areas read only
		times.setEditable(false);
		timesSorted.setEditable(false);
		
		myContentPane.add(times);
		myContentPane.add(timesSorted);
		
		//adds the times to the ClockGUI one by one
		for(int i = 0; i < totalTimes; i++) {
			times.append(clock[i].toString() + "\n");
			timesSorted.append(clockSorted[i].toString() + "\n");
			
		}
		
		cgui.setVisible(true);
		
	}
	

}
