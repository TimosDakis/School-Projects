

public class Voters extends Thread{
    //this keeps track of the Voter's numeric ID
    private int threadID;
    //this keeps track of the thread Voter will join to exit in order
    private Voters threadToJoin;
    
    //constructor
    public Voters(int threadID) {
        setName("Voter #" + threadID);
        this.threadID = threadID;
        threadToJoin = this;
        msg("has arrived");
    }
    @Override
    public void run() {
        //sleep to simulate arrival to voting location
        msg("is on their way to voting location");
        try {
            sleep(500 + Main.random.nextInt(501));
        } catch (InterruptedException e) {
        }
        //System.out.println(getName() + " has arrived at voting location");
        //implementing ME over accessing and adding to voterHasArrived queue
        while(true) {
            if(!Main.idCheckMEFlag.getAndSet(true)) {
                Main.voterHasArrived.add(threadID);
                Main.idCheckMEFlag.set(false);
                break;
            }
        }
        msg("is waiting to get ID checked");
        //Busy waits while thread ID has not been checked has not been checked
        while(!Main.idChecked[threadID - 1]) {
            Thread.yield();
        }
        msg("ID has been checked");
        msg("is looking for shortest queue to enter");
        //keep looping until get onto kiosk waiting queue
        while(true) {
            //ME over kiosk waiting queue (need to ensure goes on shortest queue)
            if(!Main.shortestKioskQueueMEFlag.getAndSet(true)) {
                int min = Main.kioskQueues[0].size();
                int minIndex = 0;
                for(int i = 1; i < Main.kioskQueues.length; i++) {
                    if(Main.kioskQueues[i].size() < min) {
                        min = Main.kioskQueues[i].size();
                        minIndex = i;
                    }
                }
                Main.kioskQueues[minIndex].add(this);
                Main.shortestKioskQueueMEFlag.set(false);
                msg("is entering kiosk queue #" + minIndex);
                break;
            }
        }
        
        //simulates waiting until done at kiosk
        try {
            //if this thread was already interrupted by kiosk_helper before sleeping
            //i.e., kiosk worker immediately starts helping before they need to wait at kiosk
            if(isInterrupted()) {
                //interrupt it so it can go to catch statement
                this.interrupt();
            }
            //else sleep to start simulation
            sleep(2147483640);
        } catch (InterruptedException e) {
            //when interrupted head to kiosk
            msg("is done at kiosk");
        }
        
        //simulates rushing to the scanning machines
        msg("rushing to scanning machines");
        setPriority(10);
        try {
            sleep(Main.random.nextInt(500));
        } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        setPriority(NORM_PRIORITY);
        
        //ME over entering the scanning machine
        if(!Main.enterSMMEFlag.getAndSet(true)) {
            Thread.yield();
        }
        msg("is waiting to use scanning machine");
        //add to queue for waiting for SM (simulates a line at scanning machines)
        Main.queueForSM.add(this);
        //add to queue to exit (as they will exit together in a group)
        Main.queueToExit.add(this);
        Main.enterSMMEFlag.set(false);
        //BW while waiting to use SM
        while(!Main.waitingForSM[threadID-1]) {
            Thread.yield(); //doing ; or ;; did not work, eventually got stuck on a thread because JVM did not go to another
        }
        
        //simulates being nervous heading to scanning machine
        msg("is heading to scanning machine");
        Thread.yield();
        Thread.yield();
        
        //simulate scanning ballot
        msg("is scanning ballot");
        try {
            sleep(Main.random.nextInt(500));
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        //notify that the machine is now free by increasing counter
        msg("has scanning machine");
        Main.freeScanMachines.incrementAndGet();
        
        //checks if the voter with largest ID from its group that went to the scanning machines is alive
        if(threadToJoin.isAlive() && threadToJoin.threadID != this.threadID) {
            try {
                //if its alive join with it
                threadToJoin.join();
            } catch (InterruptedException e) {
            }
        }
        
        msg("has left");
        
        if(Main.votersLeft.decrementAndGet() <= 0) {
            msg( "is the final voter to leave");
            Main.votersRemainFlag = false;
        }
        
    }
    
    //getter
    public int getID() {
        return threadID;
    }
    
    //setter
    public void setJoinThread(Voters v) {
        threadToJoin = v;
    }
    
    public void msg(String m) {
        System.out.println("["+(System.currentTimeMillis()-Main.time)+"] "+getName()+": "+m);
        }

}
