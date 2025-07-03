@isTest
public with sharing class ConvertLeadsInvocableTest {

    @testSetup
    static void setupTestData() {
        // Create a test Lead
        Lead testLead = new Lead(
                LastName = 'TestLastName',
                Company = 'TestCompany',
                Status = 'Open - Not Contacted',
                FirstName = 'TestFirstName'
        );
        insert testLead;
    }

    @isTest
    static void testLeadConversionSuccess() {
        // Query the test lead
        Lead testLead = [SELECT Id FROM Lead WHERE LastName = 'TestLastName' LIMIT 1];

        // Create a request to convert the lead
        ConvertLeadsInvocable.LeadConvertRequest request = new ConvertLeadsInvocable.LeadConvertRequest();
        request.leadId = testLead.Id;
        request.convertedStatus = 'Qualified'; // assuming this status value exists in org
        request.createOpportunity = true;
        request.opportunityName = 'Test Opportunity';
        request.sendEmailToOwner = false;

        List<ConvertLeadsInvocable.LeadConvertRequest> requests = new List<ConvertLeadsInvocable.LeadConvertRequest>();
        requests.add(request);

        // Convert the lead
        Test.startTest();
        List<ConvertLeadsInvocable.LeadConvertResult> results = ConvertLeadsInvocable.convertLeads(requests);
        Test.stopTest();

        // Assertions to ensure lead was converted successfully
        System.assertEquals(1, results.size(), 'Expected one conversion result');
        System.assertNotEquals(null, results[0].accountId, 'Expected account to be created');
        System.assertNotEquals(null, results[0].contactId, 'Expected contact to be created');
        System.assertNotEquals(null, results[0].opportunityId, 'Expected opportunity to be created');
    }
}