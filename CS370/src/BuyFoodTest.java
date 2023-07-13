import static org.junit.jupiter.api.Assertions.*;

class BuyFoodTest {
	
	Cafeteria caf = new Cafeteria(10, 10, 10);

	@org.junit.jupiter.api.Test
	void itemInOrderSummaryTest() {
		// tests condition where the transaction succeeds and gets added to summary
		assertTrue(new BuyFood(null, caf.getFoodQty(), 10).orderSummary().equalsIgnoreCase("Purchased 10 food\n"));
	}
	
	@org.junit.jupiter.api.Test
	void emptyOrderSummaryTest() {
		// tests condition where the transaction fails and does not get added to summary
		assertTrue(new BuyFood(null, caf.getFoodQty(), 11).orderSummary().length() == 0);
	}

}
