import java.util.ArrayList;
import java.util.List;

public class Cafeteria {
    private int foodQty;
    private int sodaQty;
    private int coffeeQty;

    private List<CafeteriaStockObserver> cafeteriaListeners;

    public Cafeteria(int foodQty, int sodaQty, int coffeeQty){
        this.foodQty=foodQty;
        this.sodaQty=sodaQty;
        this.coffeeQty=coffeeQty;
        this.cafeteriaListeners= new ArrayList<>();
    }

    public void addListener(CafeteriaStockObserver listener){
        this.cafeteriaListeners.add(listener);
    }

    public void removeListener(CafeteriaStockObserver listener){
        this.cafeteriaListeners.remove(listener);
    }

    public int getNumOfListeners(){
        return this.cafeteriaListeners.size();
    }

    public void notifyListeners(String product, int qty){
        for(CafeteriaStockObserver listener: this.cafeteriaListeners){
            listener.notify(product,qty);
        }
    }

    //getters and setters

    public int getFoodQty() {
        return this.foodQty;
    }

    public void setFoodQty(int qty){
        this.foodQty=qty;
        notifyListeners("food",this.foodQty);
    }

    public int getSodaQty() {
        return this.sodaQty;
    }

    public void setSodaQty(int sodaQty) {
        this.sodaQty = sodaQty;
        notifyListeners("soda",this.sodaQty);

    }

    public int getCoffeeQty() {
        return this.coffeeQty;
    }

    public void setCoffeeQty(int coffeeQty) {
        this.coffeeQty = coffeeQty;
        notifyListeners("coffee",this.coffeeQty);
    }

    //buying food, soda and coffee
    public void buyFood(int qty){
        if(this.foodQty==0){
            System.out.println("Error: no Food left in stock");
            return;
        }
       if(qty > this.foodQty){
            System.out.println("Error: Not enough Food left in stock to fulfil order");
            return;
        }

       System.out.println("Successfully purchased "+qty+" units of Food");
       this.setFoodQty(this.foodQty - qty);
    }

    public void buySoda(int qty){
        if(this.sodaQty==0){
            System.out.println("Error: no Soda left in stock");
            return;
        }
        if(qty > this.sodaQty){
            System.out.println("Error: Not enough Soda left in stock to fulfil order");
            return;
        }

        System.out.println("Successfully purchased "+qty+" units of Soda");
        this.setSodaQty(this.sodaQty - qty);
    }

    public void buyCoffee(int qty){

        if(this.coffeeQty==0){
            System.out.println("Error: no Coffee currently left in stock");
            return;
        }
        if(qty > this.coffeeQty){
            System.out.println("Error: Not enough Coffee left in stock to fulfil order");
            return;
        }

        System.out.println("Successfully purchased "+qty+" units of Coffee");
        this.setCoffeeQty(this.coffeeQty - qty);

    }


}
