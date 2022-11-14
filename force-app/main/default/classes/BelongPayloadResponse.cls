/**
 * Takes a paylod to create account and related contacts
 */
@RestResource(urlMapping='/Belong/*')
global with sharing class BelongPayloadResponse {
    private static final String FAIL = 'No objects inserted ';
    private static final String FAIL_CONTACTS = 'No contacts inserted ';
    @TestVisible private static final String PARTIAL_SUCCESS = 'Some of the contacts have not been inserted, Failed reason: ';
    @TestVisible private static final String SUCCESS = 'Successfully inserted all objects';

    /**
     * @description - main method that takes the payload and delegate tasks of account and contact creation to helping methods
     * @return ResponseWrapper - returns a description in response to the payload
     */
    @HttpPost
    global static ResponseWrapper createAccountAndContacts(){
        ResponseWrapper respWrapper = new ResponseWrapper();
        try {
            BelongPayload reqData = (BelongPayload)JSON.deserialize(RestContext.Request.requestBody.toString(), BelongPayload.class);
            Map<String, Object> untypedPayload = (Map<String, Object>)JSON.deserializeUntyped(RestContext.Request.requestBody.toString());
            Id accountId = createAccount(untypedPayload, respWrapper);
            if(accountId != null) {
                List<Object> untypedContacts = (List<Object>)untypedPayload.get('contacts');
                createContacts(untypedContacts, accountId, respWrapper);
            }
            
        }
        catch(Exception ex) {
            respWrapper.message = FAIL + ex;
            //log the error
        }

        return respWrapper;
    }

    /**
     * @description Create Account from payload
     * @params Map<String, Object> accountPayload - payload converted in a map format 
     * ResponseWrapper respWrapper - used to fill in the response
     * @return Id - Id of the account created
     */
    private static Id createAccount(Map<String, Object> accountPayload, ResponseWrapper respWrapper) {
        try {
            Account acc = new Account(
                Name = (String) accountPayload.get('Name'),
                Type = (String) accountPayload.get('Type'),
                Phone = (String) accountPayload.get('Phone'),
                Fax = (String) accountPayload.get('Fax'),
                AccountNumber = (String) accountPayload.get('AccountNumber'),
                Industry = (String) accountPayload.get('Industry'),
                AnnualRevenue = (Decimal) accountPayload.get('AnnualRevenue'),
                NumberOfEmployees = (Integer) accountPayload.get('NumberOfEmployees'),
                Ownership = (String) accountPayload.get('Ownership'),
                Description = (String) accountPayload.get('Description'),
                Rating = (String) accountPayload.get('Rating')
            );
            insert acc;
            return acc.Id;
        }
        catch(Exception ex) {
            respWrapper.message = FAIL + ex;
            //log the error
        }
        return null;
    }

    /**
     * @description Create Contacts from payload
     * @params Map<String, Object> accountPayload - payload converted in a map format 
     * Id - Id of the account for which contacts are to be created
     * ResponseWrapper respWrapper - used to fill in the response
     * @return List<Contact> - list of all the contacts attempted for insertion
     */
    private static List<Contact> createContacts(List<Object> contactPayload, Id accountId, ResponseWrapper respWrapper) {
        List<Contact> contactList = new List<Contact>();
        try {
            for(Object con : contactPayload) {
                Map<String, Object> contact  = (Map<String, Object>) con;
                contactList.add(new Contact(
                    LastName = (String) contact.get('LastName'),
                    FirstName = (String) contact.get('FirstName'),
                    Salutation = (String) contact.get('Salutation'),
                    Phone = (String) contact.get('Phone'),
                    MobilePhone = (String) contact.get('MobilePhone'),
                    Email = (String) contact.get('Email'),
                    Title = (String) contact.get('Title'),
                    Department = (String) contact.get('Department'),
                    Description = (String) contact.get('Description'),
                    AccountId = accountId
                ));
            }

            Boolean completeSuccess = true;
            List<Database.SaveResult> insertResults = Database.insert(contactlist, false);
            respWrapper.message = PARTIAL_SUCCESS;

            for(Integer i=0; i<insertResults.size(); i++){
                if (!insertResults.get(i).isSuccess()) {
                    Database.Error error = insertResults.get(i).getErrors().get(0);
                    respWrapper.message += error.getMessage() + ':' + contactlist.get(i).FirstName + ' | ';
                    completeSuccess = false;
                }
            }

            if(completeSuccess) {
                respWrapper.message = SUCCESS;
            }

            return contactList;
        }
        catch(Exception ex) {
            respWrapper.message = FAIL_CONTACTS + ex;
            //log the error
        }

        return null;
    }

    /**
     * Used to return response of the payload
     */
    global class ResponseWrapper {          
        public String message;
    }
}
