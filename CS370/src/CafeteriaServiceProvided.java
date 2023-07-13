
public abstract class CafeteriaServiceProvided {
	protected CafeteriaServiceProvided cafeteriaServiceProvided;
	protected int cafeteriaStock;
	protected int qty;
	public CafeteriaServiceProvided(CafeteriaServiceProvided cafeteriaServiceProvided, int cafeteriaStock, int qty) {
		this.cafeteriaServiceProvided = cafeteriaServiceProvided;
		this.cafeteriaStock = cafeteriaStock;
		this.qty = qty;
	}
	abstract public String orderSummary();
	abstract public void doAction();
}
