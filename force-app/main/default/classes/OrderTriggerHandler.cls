/**
 * Handles the Trigger on Order
 */
public with sharing class OrderTriggerHandler {
    OrderTriggerHelper helper = new OrderTriggerHelper();

    public void beforeInsert(List<Order> newOrderList) {
        helper.assignPrimaryContact(newOrderList);
    }
}
