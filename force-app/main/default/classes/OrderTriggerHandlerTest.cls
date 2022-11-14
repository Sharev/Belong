/**
 * Test class for OrderTriggerHandler and OrderTriggerHelper
 */
@IsTest
public class OrderTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'business name');
        insert acc;
        Contact con = new Contact(LastName = 'contact test', AccountId = acc.Id, Email = 'test@test.com', MobilePhone = '0123456789');
        insert con;
        Contract contract = new Contract(Status = 'Draft', AccountId = acc.Id, StartDate = System.today(), ContractTerm = 4);
        insert contract;
    }

    @IsTest
    static void testAssignPrimaryContact_Positive() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'business name' LIMIT 1];
        Contract contract = [SELECT Id FROM Contract WHERE AccountId =: acc.Id];
        System.debug('order before:: ');
        Order order = new Order(EffectiveDate = System.today(),
            Status = 'Draft',
            ContractId = contract.Id,
            AccountId = acc.Id
        );
        insert order;
        Order orderRetrieve = [SELECT Id, CustomerAuthorizedById FROM Order WHERE Id =: order.Id];
        System.assertNotEquals(null, orderRetrieve.CustomerAuthorizedById, 'Contact should be assigned to the Order');
    }
}
