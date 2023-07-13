public class SmartphoneApp implements CafeteriaStockObserver {
    @Override
    public void notify(String product, int qty) {
        System.out.println("Smartphone app - "+qty+" "+product+" in stock");
    }
}
