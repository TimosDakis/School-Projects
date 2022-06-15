public class ID_checkers extends Thread {

    // constructor
    public ID_checkers(int threadID) {
        setName("ID Checker #" + threadID);
        msg("has arrived");
    }

    @Override
    public void run() {
        // loops while there are still voters
        while(Main.votersNeedingIDChecked.get() > 0) {
            //Implements ME over votersHasArrived Queue
            if(!Main.idCheckMEFlag.getAndSet(true)) {
                //if there is a voter waiting to have ID checked
                if(Main.voterHasArrived.size() != 0) {
                    //take ID
                    int voterID = Main.voterHasArrived.remove();
                    Main.idCheckMEFlag.set(false);
                    msg("is checking ID of Voter #" + voterID);
                    // simulate time needed to check the ID
                    try {
                        sleep(Main.random.nextInt(500));
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    //notify voter that ID is checked
                    Main.idChecked[voterID - 1] = true;
                    //reduce counter of voters by 1
                    msg("has finished checkined ID of Voter #" + voterID);
                    Main.votersNeedingIDChecked.decrementAndGet();
                }
                Main.idCheckMEFlag.set(false);
            }
            //sleep to simulate waiting for people to show up before continuing
            try {
                sleep(500);
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }

        // cannot leave until all voters leave, so BW until all voters leave
        msg("is now Busy Waiting until all voters leave");
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
