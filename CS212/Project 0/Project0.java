import javax.swing.*;

/**
 * @Date 02/11/2020
 * @author timothydakis
 * @LabSection 12a
 * 
 * @Description The program gets the user to input a string and then returns the amount of 'E's and 'e's in it.
 *
 */
public class Project0 {
    public static void main(String[] args) {
        String input;
        int lowerCaseE = 0, upperCaseE = 0;
    
        //while(true) loop is used to create an infinite loop and so the program will keep going until its broken out of
        while(true) {
        lowerCaseE = 0; //restarting counter
        upperCaseE = 0; //restarting counter
        
        input = JOptionPane.showInputDialog(null, "Enter a sentence:");
        //if statement used here to see if the stopping condition was met to break the loop
        if(input.equalsIgnoreCase("Stop")) System.exit(0);    
        
        //a for loop is used as the length of the loop is known and so it iterates through the letters of the sentence
        for(int i = 0; i < input.length(); i++) {
            //if statements used to check if the string contains 'e' or 'E' in it and increase the counter if it does
            if(input.charAt(i) == 'e') lowerCaseE++;
            if(input.charAt(i) == 'E') upperCaseE++;
            }
        
        JOptionPane.showMessageDialog(null, "Number of lower case e's: " + lowerCaseE + "\nNumber of upper case e's: " + upperCaseE);
        
        }
    }
}