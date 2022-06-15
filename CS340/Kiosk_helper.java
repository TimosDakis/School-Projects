
public class Kiosk_helper extends Thread {

    //counter for total variables (only 1 kiosk_helper so NOT shared)
    private int totalVoters = Main.num_voters;
    
    //constructor
    public Kiosk_helper() {
        setName("Kiosk Helper");
        msg("has arrived");
    }
    
    @Override
    public void run() {
        while(totalVoters > 0){
            msg("is checking if anyone is waiting to use any kiosk");
            for(int i = 0; i < Main.num_k; i++) {
                if(Main.kioskQueues[i].size() != 0) {
                    msg("is helping a Voter fill ballot");
                    //if there is a person in the kiosk queue, sleep to simulate dealing with them while they fill ballot
                    try {
                        sleep(Main.random.nextInt(1000));
                    } catch (InterruptedException e) {
                       e.printStackTrace(); 
                    }
                    finally {
                    msg("Finished helping " + Main.kioskQueues[i].peek().getName() + " fill ballot");
                    Main.kioskQueues[i].remove().interrupt();
                    totalVoters--;
                    }
                }
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
