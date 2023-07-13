
public class Main {
	public static void main(String[] args) {
		// create cafeteria
		Cafeteria cafeteria = new Cafeteria(9, 2, 20);
		
		cafeteria.addListener(new Website());
		cafeteria.addListener(new SmartphoneApp());
		cafeteria.addListener(new Supplier());
		System.out.println("There are " + cafeteria.getNumOfListeners() + " listeners");
		System.out.println("---------------------");
		
		// customer 1's order
		int customer1 = new CustomerId().getNextCustomerId();
		CafeteriaServiceProvided customer1Details = new BuyFood(null, cafeteria.getFoodQty(), 2);
		cafeteria.buyFood(2);
		customer1Details = new BuySoda(customer1Details, cafeteria.getSodaQty(), 200);
		cafeteria.buySoda(200);
		customer1Details = new BuySoda(customer1Details, cafeteria.getSodaQty(), 2);
		cafeteria.buySoda(2);
		customer1Details = new BuySoda(customer1Details, cafeteria.getSodaQty(), 2);
		cafeteria.buySoda(2);
		System.out.println("---------------------");
		System.out.println("Customer " + customer1 + " details:");
		customer1Details.doAction();
		System.out.println("---------------------");
		System.out.println("Customer " + customer1 + " order summary:");
		System.out.println(customer1Details.orderSummary().trim());
		
		System.out.println("---------------------");
		
		// customer 2's order
		int customer2 = new CustomerId().getNextCustomerId();
		CafeteriaServiceProvided customer2Details = new BuyFood(null, cafeteria.getFoodQty(), 8);
		cafeteria.buyFood(8);
		customer2Details = new BuyCoffee(customer2Details, cafeteria.getCoffeeQty(), 3);
		cafeteria.buyCoffee(3);
		System.out.println("---------------------");
		System.out.println("Customer " + customer2 + " details:");
		customer2Details.doAction();
		System.out.println("---------------------");
		System.out.println("Customer " + customer2 + " order summary:");
		System.out.println(customer2Details.orderSummary().trim());
		
	}
}
