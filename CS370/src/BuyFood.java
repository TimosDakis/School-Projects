
public class BuyFood extends CafeteriaServiceProvided {
	
	public BuyFood(CafeteriaServiceProvided cafeteriaServiceProvided, int cafeteriaStock, int qty) {
		super(cafeteriaServiceProvided, cafeteriaStock, qty);
	}

	@Override
	public String orderSummary() {
		String summary = "";
		if(cafeteriaServiceProvided != null) {
			summary = cafeteriaServiceProvided.orderSummary();
		}
		return cafeteriaStock == 0 || qty > cafeteriaStock ? (summary) : (summary + "Purchased " + Integer.toString(qty) + " food\n");
	}

	@Override
	public void doAction() {
		if(cafeteriaServiceProvided != null) {
			cafeteriaServiceProvided.doAction();
		}
		if(cafeteriaStock == 0 || qty > cafeteriaStock) {
			System.out.println("Food purchase rejected");
		}
		else {
			System.out.println("Food purchase authorized");
		}
	}

}
