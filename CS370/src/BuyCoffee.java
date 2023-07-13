
public class BuyCoffee extends CafeteriaServiceProvided {

	public BuyCoffee(CafeteriaServiceProvided cafeteriaServiceProvided, int cafeteriaStock, int qty) {
		super(cafeteriaServiceProvided, cafeteriaStock, qty);
	}

	@Override
	public String orderSummary() {
		String summary = "";
		if(cafeteriaServiceProvided != null) {
			summary = cafeteriaServiceProvided.orderSummary();
		}
		return cafeteriaStock == 0 || qty > cafeteriaStock ? (summary) : (summary + "Purchased " + Integer.toString(qty) + " coffee\n");
	}

	@Override
	public void doAction() {
		if(cafeteriaServiceProvided != null) {
			cafeteriaServiceProvided.doAction();
		}
		if(cafeteriaStock == 0 || qty > cafeteriaStock) {
			System.out.println("Coffee purchase rejected");
		}
		else {
			System.out.println("Coffee purchase authorized");
		}
	}
	
}
