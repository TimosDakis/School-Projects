
public class BuySoda extends CafeteriaServiceProvided {

	public BuySoda(CafeteriaServiceProvided cafeteriaServiceProvided, int cafeteriaStock, int qty) {
		super(cafeteriaServiceProvided, cafeteriaStock, qty);
	}

	@Override
	public String orderSummary() {
		String summary = "";
		if(cafeteriaServiceProvided != null) {
			summary = cafeteriaServiceProvided.orderSummary();
		}
		return cafeteriaStock == 0 || qty > cafeteriaStock ? (summary) : (summary + "Purchased " + Integer.toString(qty) + " soda\n");
	}

	@Override
	public void doAction() {
		if(cafeteriaServiceProvided != null) {
			cafeteriaServiceProvided.doAction();
		}
		if(cafeteriaStock == 0 || qty > cafeteriaStock) {
			System.out.println("Soda purchase rejected");
		}
		else {
			System.out.println("Soda purchase authorized");
		}
	}

}
