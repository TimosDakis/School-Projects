import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;

public class CustomerIdTest {
    @Test
    public void testGetNextCustomerId() {
        CustomerId customerId = new CustomerId();
        Assertions.assertEquals(1, customerId.getNextCustomerId());
        Assertions.assertEquals(2, customerId.getNextCustomerId());
    }

    @Test
    public void testUniqueCustomerIds() {
        CustomerId customerId1 = new CustomerId();
        CustomerId customerId2 = new CustomerId();
        Assertions.assertNotEquals(customerId1.getNextCustomerId(), customerId2.getNextCustomerId());
    }
}
