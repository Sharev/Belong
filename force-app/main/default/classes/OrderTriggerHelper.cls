/**
 * This class is a helper class for OrderTriggerHandler
 */
public with sharing class OrderTriggerHelper {

    /**
     * @description - assigns primary contact to the order
     * @params List<Order> orderList - a list of orders
     */
    public void assignPrimaryContact(List<Order> orderList) {
        Set<Id> accountIds = new Set<Id>();
        for(Order order : orderList) {
            accountIds.add(order.AccountId);
        }

        Map<Id, Id> contactIdByAccountIdMap = findPrimaryContacts(accountIds);
        for(Order order : orderList) {
            order.CustomerAuthorizedById = contactIdByAccountIdMap.get(order.AccountId);
        }
    }

    /**
     * @description - find primary contacts if any for given accounts
     * @params Set<Id> accountIds - a set of account ids
     * @return a map of primary Contact Ids by account Id
     */
    public Map<Id, Id> findPrimaryContacts(Set<Id> accountIds) {
        Map<Id, Id> contactIdByAccountIdMap = new Map<Id, Id>();

        List<AccountContactRelation> acrList = [SELECT ContactId, AccountId 
                                                FROM AccountContactRelation 
                                                WHERE AccountId IN :accountIds AND IsDirect = true
                                                WITH SECURITY_ENFORCED];
        for(AccountContactRelation acr : acrList) {
            contactIdByAccountIdMap.put(acr.AccountId, acr.ContactId);
        }
        return contactIdByAccountIdMap;
    }
}
