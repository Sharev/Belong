/**
 * Test class for BeyondPayloadResponse
 */
@IsTest
public class BelongPayloadResponseTest {
    @IsTest
    static void testCreateAccountsAndContacts_Positive() {
		String json = '{'+
		'\"Name\": \"LWC Kaanam\",'+
		'\"Type\": \"Customer - Direct\",'+
		'\"Phone\": \"+61470688711\",'+
		'\"Fax\": null,'+
		'\"AccountNumber\": null,'+
		'\"Industry\": \"Apparel\",'+
		'\"AnnualRevenue\": null,'+
		'\"NumberOfEmployees\": null,'+
		'\"Ownership\": \"Public\",'+
		'\"Description\": \"Test Description\",'+
		'\"Rating\": \"Warm\",'+
		'\"contacts\": ['+
		'{'+
		'\"LastName\": \"Young\",'+
		'\"FirstName\": \"Andy\",'+
		'\"Salutation\": \"Mr\",'+
		'\"Phone\": \"(785) 241-6200\",'+
		'\"MobilePhone\": \"(785) 265-5350\",'+
		'\"Email\": \"a_young@dickenson.com\",'+
		'\"Title\": \"SVP, Operations\",'+
		'\"Department\": \"Internal Operations\",'+
		'\"Description\": \"Test Contact\"'+
		'},'+
		'{'+
		'\"LastName\": \"Young\",'+
		'\"FirstName\": \"Not Andy\",'+
		'\"Salutation\": \"Mr\",'+
		'\"Phone\": \"(785) 241-6200\",'+
		'\"MobilePhone\": \"(785) 265-5350\",'+
		'\"Email\": \"not_young@dickenson.com\",'+
		'\"Title\": \"SVP, Operations\",'+
		'\"Department\": \"External Operations\",'+
		'\"Description\": \"Test Contact\"'+
		'}'+
		']'+
		'}';

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/Belong/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        String str = json;
        req.requestBody= Blob.valueOf(str);
        RestContext.response= res;
        BelongPayloadResponse.ResponseWrapper wrapper = BelongPayloadResponse.createAccountAndContacts();
        System.assertEquals(BelongPayloadResponse.SUCCESS, wrapper.message, 'All records should be successful');
	}

    @IsTest
    static void testCreateAccountsAndContacts_Negative() {
		String json = '{'+
		'\"Name\": \"LWC Kaanam\",'+
		'\"Type\": \"Customer - Direct\",'+
		'\"Phone\": \"+61470688711\",'+
		'\"Fax\": null,'+
		'\"AccountNumber\": null,'+
		'\"Industry\": \"Apparel\",'+
		'\"AnnualRevenue\": null,'+
		'\"NumberOfEmployees\": null,'+
		'\"Ownership\": \"Public\",'+
		'\"Description\": \"Test Description\",'+
		'\"Rating\": \"Warm\",'+
		'\"contacts\": ['+
		'{'+
		'\"LastName\": \"Young\",'+
		'\"FirstName\": \"Andy\",'+
		'\"Salutation\": \"Mr\",'+
		'\"Phone\": \"(785) 241-6200\",'+
		'\"MobilePhone\": \"(785) 265-5350\",'+
		'\"Email\": \"a_young@dickenson.com\",'+
		'\"Title\": \"SVP, Operations\",'+
		'\"Department\": \"Internal Operations\",'+
		'\"Description\": \"Test Contact\"'+
		'},'+
		'{'+
		'\"LastName\": \"\",'+
		'\"FirstName\": \"Not Andy\",'+
		'\"Salutation\": \"Mr\",'+
		'\"Phone\": \"(785) 241-6200\",'+
		'\"MobilePhone\": \"(785) 265-5350\",'+
		'\"Email\": \"not_young@dickenson.com\",'+
		'\"Title\": \"SVP, Operations\",'+
		'\"Department\": \"External Operations\",'+
		'\"Description\": \"Test Contact\"'+
		'}'+
		']'+
		'}';

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/Belong/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        String str = json;
        req.requestBody= Blob.valueOf(str);
        RestContext.response= res;
        BelongPayloadResponse.ResponseWrapper wrapper = BelongPayloadResponse.createAccountAndContacts();
        System.assert(wrapper.message.indexOf(BelongPayloadResponse.PARTIAL_SUCCESS) != -1, 'All records should be successful');
	}
}
