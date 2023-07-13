public class Supplier implements CafeteriaStockObserver{
    @Override
    public void notify(String product, int qty) {
        if(qty==0){
            System.out.println("Supplier - "+qty+" "+product+" in stock -- restocking needed");
        }
    }
}
