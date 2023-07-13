import static org.junit.jupiter.api.Assertions.*;

class CafeteriaTest {

    @org.junit.jupiter.api.Test
    public void testGetters() {
        //setting values
        int foodQty=10;
        int sodaQty=20;
        int coffeeQty=30;

        //cafeteria object
        Cafeteria cafeteria = new Cafeteria(foodQty,sodaQty,coffeeQty);

        //checking if getters return the same value as passed into the constructor
        assertEquals(foodQty,cafeteria.getFoodQty());
        assertEquals(sodaQty,cafeteria.getSodaQty());
        assertEquals(coffeeQty,cafeteria.getCoffeeQty());

    }

    @org.junit.jupiter.api.Test
    public void testNumOfListeners(){
        //creating cafeteria object
        Cafeteria cafeteria = new Cafeteria(10,20,30);

        //creating listeners
        SmartphoneApp app = new SmartphoneApp();
        Website website = new Website();

        //adding listeners
        cafeteria.addListener(app);
        cafeteria.addListener(website);

        //checking if the number of listeners returns correct number
        assertEquals(2,cafeteria.getNumOfListeners());
    }



}