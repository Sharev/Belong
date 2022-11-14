trigger OrderTrigger on Order (before insert) {
    
    if (!Trigger_Switch__mdt.getInstance('Order')?.Disable__c) {
        OrderTriggerHandler handler = new OrderTriggerHandler();
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                handler.beforeInsert(Trigger.new);
            }
        }
    }
}