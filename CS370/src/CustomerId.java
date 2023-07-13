public class CustomerId {
    static private int customerId = 0;

    public int getNextCustomerId(){
        return ++customerId;
    }
}
