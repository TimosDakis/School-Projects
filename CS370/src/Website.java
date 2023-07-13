public class Website implements CafeteriaStockObserver{
    @Override
    public void notify(String product, int qty) {
        System.out.println("Website - "+qty+" "+product+" in stock");
    }
}
