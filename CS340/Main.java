import java.util.LinkedList;
import java.util.Queue;
import java.util.Random;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

public class Main {
    //relative time start
    static long time = System.currentTimeMillis();
    
    //to find random numbers in different threads
    static Random random = new Random();
    
    //default values of variables
    static int num_voters = 20;
    static int num_ID_checkers = 3;
    static int num_k = 3;
    static int num_sm = 4;

    //various data structures for keeping track of things between threads
    static Queue<Integer> voterHasArrived = new LinkedList<Integer>(); //keeps track of order that voters arrive
    static volatile Queue<Voters>[] kioskQueues; //keeps track of how many voters are queued at each kiosk
    static boolean[] waitingForSM; //keeps track of which voters still need to go to the scanning machine
    static volatile Queue<Voters> queueForSM = new LinkedList<Voters>();; //keeps track of order voters arrive at scanning machine (SM)
    static volatile Queue<Voters> queueToExit = new LinkedList<Voters>(); //keeps track of order voters arrive at SM (to group them for exiting)
    static volatile boolean[] idChecked; //keeps track of which voters still need to have id checked
    
    //a flag to keep track if voters still exist
    static volatile boolean votersRemainFlag = true;
    
    //Counters
    static AtomicInteger freeScanMachines;
    static AtomicInteger votersNeedingIDChecked;
    static AtomicInteger votersLeft;
    
    //Flags for Mutual Exclusion
    static AtomicBoolean idCheckMEFlag = new AtomicBoolean();
    static AtomicBoolean enterSMMEFlag = new AtomicBoolean();
    static AtomicBoolean shortestKioskQueueMEFlag = new AtomicBoolean();
    
    @SuppressWarnings("unchecked")
    public static void main(String args[]) {
        
        //if given a command line input for num of voters
        if(args.length > 0) {
            //try to set it
            try {
                num_voters = Integer.parseInt(args[0]);
            }
            //if first arg was not a number, terminate because invalid input
            catch (NumberFormatException e){
                System.err.println("Error: Non-integer input detected");
                System.exit(1);
            }
        }
        //if input was negative for voters, also print an error
        if(num_voters <= 0) {
            System.err.println("Error: Non-positive integer input detected");
            System.exit(1);
        }
        
        //setting up the counters
        votersLeft = new AtomicInteger(num_voters);
        freeScanMachines = new AtomicInteger(num_sm);
        votersNeedingIDChecked = new AtomicInteger(Main.num_voters);
        
        //setting up remaining data structures
        idChecked = new boolean[num_voters];
        waitingForSM = new boolean[num_voters];
        //setting up an array of queues
        kioskQueues = new Queue[num_k];
        //initializing each queue in the array of queues
        for(int i = 0; i < num_k; i++) {
            kioskQueues[i] = new LinkedList<Voters>();
        }

        
        //starting all the threads
        
        //starting all voter threads
        for(int i = 1; i <= num_voters; i++) {
            Voters voter = new Voters(i);
            voter.start();
        }

        //starting all ID_checker threads
        for(int i = 1; i <= num_ID_checkers; i++) {
            ID_checkers idChecker = new ID_checkers(i);
            idChecker.start();
        }

        //start the kiosk_Helper thread
        Kiosk_helper kioskHelper = new Kiosk_helper();
        kioskHelper.start();
        
        //start the scanning_Helper thread
        Scanning_helper scanningHelper = new Scanning_helper();
        scanningHelper.start();
	}
    
    
}
