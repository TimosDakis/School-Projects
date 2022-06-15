
public class Scanning_helper extends Thread {
    //counter for total variables (only 1 scanning_helper so NOT shared)
    private int totalVoters = Main.num_voters;
    private Voters maxVoter;

    //constructor
    public Scanning_helper() {
        setName("Scanning Helper");
        msg("has arrived");
    }
    
    @Override
    public void run() {
        while(totalVoters > 0) {
            //if no-one is attempting to line up for the scanning machines, and all the machines are free, and there are people waiting to use the machines
            if(!Main.enterSMMEFlag.get() && Main.freeScanMachines.get() == Main.num_sm && Main.queueForSM.size() != 0) {
                msg("is now leading people to scanning machines");
                //iterate through current people in queue until you either get everyone currently in it, or the total number of machine's worth (whichever is smaller)
                for(int i = 0, peopleInQueue = Main.queueForSM.size(); i < peopleInQueue && i < Main.num_sm; i++) {
                    //before you start leading people, check whom has the highest ID of the people you will lead to machines
                    if(i == 0) {
                        maxVoter = Main.queueToExit.remove();
                        //iterate through all the people you are about to lead to scanning machines to find voter with highest ID
                        for(int j = 1; j < peopleInQueue && j < Main.num_sm; j++) {
                            if(Main.queueToExit.peek().getID() > maxVoter.getID()) {
                                maxVoter = Main.queueToExit.remove();
                            }
                            else {
                                Main.queueToExit.remove();
                            }
                        }
                    }
                    //decrease free machine counter
                    Main.freeScanMachines.decrementAndGet();
                    msg("leading " + Main.queueForSM.peek().getName() + " to scanning machine");

                    //if the voter with the highest ID of the group has not left yet, and it is not that voter themselves
                    if(maxVoter.isAlive() && Main.queueForSM.peek().getID() != maxVoter.getID()) {
                        //set it so this voter will plan to join the voter with higest ID in the group
                        Main.queueForSM.peek().setJoinThread(maxVoter);
                    }
                    //notify that voter thread that they are at the scanning machine
                    msg("finished leading " + Main.queueForSM.peek().getName() + " to the machine");
                    Main.waitingForSM[Main.queueForSM.remove().getID() - 1] = true;
                    totalVoters--;
                }
            }
            //if there are no voters or all machines not free, yield for other threads to run
            else {
                Thread.yield();
            }
        }
        msg("Busy Waiting until all voters leave");
        while(Main.votersRemainFlag) {
        //while BW just yield to not consume (potentially indefinite amount of) unnecessary CPU time
            Thread.yield(); //doing ; or ;; did not work, eventually got stuck on a thread because JVM did not go to another
        }
        msg("has left");
        
    }
    
    public void msg(String m) {
        System.out.println("["+(System.currentTimeMillis()-Main.time)+"] "+getName()+": "+m);
        }

}
