@isTest
private class HistoryTrackTest {

    @isTest static void testTriggerLogic() {
        // Create an Account
        Account acc = new Account(Name = 'Test Account', Country__c = 'Sweden');
        insert acc;

        // Create a Contact
        Contact con = new Contact(FirstName = 'Test FirstName', LastName = 'Test LastName', AccountId = acc.id);
        insert con;
        
        // Create a Campaign
        Campaign camp = new Campaign(Name = 'Test Campaign',  Account__c = acc.Id, Country__c = 'Sweden');
        insert camp;

        // Create a CampaignMember associated with the Contact
        CampaignMember cm = new CampaignMember(
            CampaignId = camp.Id,
            ContactId = con.Id,
            Status = 'Sent'
        );
        
        insert cm;

        // Update the CampaignMember status
        cm.Status = 'Opened';
        update cm;
        
    }
}