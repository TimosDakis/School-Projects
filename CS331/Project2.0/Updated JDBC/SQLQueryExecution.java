import java.awt.Dimension;
import java.awt.GridLayout;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;
import java.util.regex.Pattern;
import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.DefaultTableModel;
import java.util.Vector;

public class SQLQueryExecution {

	/* Adapted from:
	 * https://www.youtube.com/playlist?list=PLEAQNNR8IlB4R7NfqBY1frapYo97L6fOQ
	 * by luv2code
	 */
	public static void main(String[] args) {
		
		String allSQLStatements[] = null;
		
		String connectionUrl = MakeConnectionURLWithGUI();
		
		//obtains all SQL statements split by GOs
		try {
			allSQLStatements = GetSQLCode(GetSQLFileGUI());
		} catch (IOException e) {
			e.printStackTrace();
		}
		

		try {
			//create the connection to the database
			Connection myConn = DriverManager.getConnection(connectionUrl);
			Statement myStmt = myConn.createStatement();
			
			//loop through and execute all SQL statements found
			for(int i = 0; i < allSQLStatements.length; i++) { 
				if(myStmt.execute(allSQLStatements[i])) {
					ResultSet myRs = myStmt.getResultSet();
					PrintResult(myRs);
					myRs.close();
					while(myStmt.getMoreResults()) {
						myRs = myStmt.getResultSet();
						PrintResult(myRs);
						myRs.close();
					}
				}
			}
			myStmt.close();
			myConn.close();
		}
		// Handle any errors that may have occurred here
		catch (SQLException exc) {
			exc.printStackTrace();
		}		
	}

	/***
	 * 
	 * @param result - The results of a given SQL statement to output
	 * @throws SQLException 
	 */
	private static void PrintResult(ResultSet result) throws SQLException {
		
		ResultSetMetaData resultMetaData = result.getMetaData();
		int tableWidth = (1+ resultMetaData.getColumnCount()) * 100;
		
		//makes table then adjusts its slightly
		JTable table = new JTable(buildTableModel(result));
		table.setPreferredScrollableViewportSize(new Dimension(tableWidth, 300));
		
		table.setAutoResizeMode(JTable.AUTO_RESIZE_ALL_COLUMNS);
		table.getColumnModel().getColumn(0).setPreferredWidth(20);
		
		//output table
		JOptionPane.showMessageDialog(null, new JScrollPane(table));
	}
	
	/* Adapted from:
	 * https://stackoverflow.com/questions/10620448/most-simple-code-to-populate-jtable-from-resultset
	 * by Paul Vargas
	*/
	/***
	 * 
	 * @param rs - the result set to output
	 * @return - table model to create a table from
	 * @throws SQLException
	 */
	public static DefaultTableModel buildTableModel(ResultSet rs) throws SQLException {

	    ResultSetMetaData metaData = rs.getMetaData();

	    // names of columns
	    Vector<String> columnNames = new Vector<String>();
	    int columnCount = metaData.getColumnCount();
	    columnNames.add("");
	    for (int column = 1; column <= columnCount; column++) {
	        columnNames.add(metaData.getColumnName(column));
	    }

	    // data of the table
	    int rowNumber = 1;
	    Vector<Vector<Object>> data = new Vector<Vector<Object>>();
	    while (rs.next()) {
	        Vector<Object> vector = new Vector<Object>();
	        vector.add(rowNumber);
	        rowNumber++;
	        for (int columnIndex = 1; columnIndex <= columnCount; columnIndex++) {
	        	//if the data is NULL, add NULL as string into cell (adding it normally results in a blank cell)
	        	if(rs.getObject(columnIndex) == null) {
	        		vector.add("NULL");
	        	}
	        	else {
	        		vector.add(rs.getObject(columnIndex));
	        		}
	        }
	        data.add(vector);
	    }

	    return new DefaultTableModel(data, columnNames);
	    }

	
	/***
	 * @return The derived connection URL based on user inputs
	 */
	/* Code adapted from
	 * https://stackoverflow.com/questions/41904362/multiple-joptionpane-input-dialogs/41904856
	 * by Frakool
	 */
	private static String MakeConnectionURLWithGUI() {
		
		//Create GUI to get inputs
		JPanel inputPanel = new JPanel(new GridLayout(5, 2));
		//Default values here - change them if you want to change the default value for the inputs
		JTextField serverField = new JTextField("localhost");
		JTextField portField = new JTextField("13001");
		JTextField databaseField = new JTextField("TSQLV4");
		JTextField userField = new JTextField("sa");
		JTextField passwordField = new JTextField("PH@123456789");
		
		inputPanel.add(new JLabel("Input server name"));
		inputPanel.add(serverField);
		inputPanel.add(new JLabel("Input port number"));
		inputPanel.add(portField);
		inputPanel.add(new JLabel("Input database name"));
		inputPanel.add(databaseField);
		inputPanel.add(new JLabel("Input username"));
		inputPanel.add(userField);
		inputPanel.add(new JLabel("Input password"));
		inputPanel.add(passwordField);
		
		//Make user confirm if they input something or not
		int option = JOptionPane.showConfirmDialog(null, inputPanel, "Fill in to connect to your database", JOptionPane.YES_NO_OPTION, JOptionPane.INFORMATION_MESSAGE);
		
		//if did not confirm inputs, terminate
		if (option != JOptionPane.YES_OPTION) {
			System.out.println("Terminating as user did not specify inputs");
			System.exit(0);
		}
		
		//return the connection url
		return 	"jdbc:sqlserver://" + serverField.getText() + ":" + portField.getText() + ";"
				+ "database=" + databaseField.getText() + ";"
				+ "user=" + userField.getText() + ";"
				+ "password=" + passwordField.getText() + ";"
				+ "encrypt=true;"
				+ "trustServerCertificate=true;"
				+ "hostNameInCertificate=*.database.windows.net;"
				+ "loginTimeout=30;";
	}
	
	/***
	 * @return The file path to the inputed SQL file
	 */
	// Code adapted from: https://docs.oracle.com/javase/8/docs/api/javax/swing/JFileChooser.html
	private static String GetSQLFileGUI() {
	    JFileChooser chooser = new JFileChooser();
	    FileNameExtensionFilter filter = new FileNameExtensionFilter(
	        "SQL Files", "sql");
	    chooser.setFileFilter(filter);
	    int returnVal = chooser.showOpenDialog(null);
	    if(returnVal != JFileChooser.APPROVE_OPTION) {
	       System.out.println("Terminating as user did not specify a file");
	       System.exit(0);
	    }
		
		return chooser.getSelectedFile().getAbsolutePath();
	}
	
	/***
	 * @param filename
	 * @return All SQL statements that were batched together separated by GOs
	 * @throws IOException
	 */
	private static String[] GetSQLCode(String filename) throws IOException {
		String sqlCode = "";
		
		FileReader sqlFile = new FileReader(filename);
		BufferedReader buffer = new BufferedReader(sqlFile);
		
		String line;
		while((line = buffer.readLine()) != null) {
			sqlCode += line += "\n";
		}
		
		buffer.close();
		
		/* Adapted from:
		 * https://stackoverflow.com/questions/10734824/how-can-i-support-the-sql-go-statement-in-a-java-jtds-application
		 * by Tim Abell
		 */
		Pattern batchSplitter = Pattern.compile("^GO", Pattern.MULTILINE);
		String[] splitSQL = batchSplitter.split(sqlCode);
		
		return splitSQL;
	}

}
