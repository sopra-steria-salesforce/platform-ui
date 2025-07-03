@isTest
public class CampaignMemberStatusTriggerTest {

    @isTest
    static void testTriggerLogic() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account1', Country__c = 'Sweden');
        insert testAccount;
        
    
        Contact testContact = new Contact(FirstName = 'Test Name', LastName = 'Test Contact', AccountId = testAccount.id);
        insert testContact;
        

        Campaign testCampaign = new Campaign(Name = 'Test Campaign', Country__c = 'Sweden');
        insert testCampaign; 
       
        CampaignMemberStatus testStatus1 = new CampaignMemberStatus(Label = 'Pending', CampaignId = testCampaign.id);
        insert testStatus1;

        CampaignMemberStatus testStatus2 = new CampaignMemberStatus(Label = 'Follow Up', CampaignId = testCampaign.id);
        insert testStatus2;     
        
        CampaignMemberStatus testStatus3 = new CampaignMemberStatus(Label = 'Not Started', CampaignId = testCampaign.id);
        insert testStatus3;     
         
        CampaignMember testCampaignMember = new CampaignMember(CampaignId = testCampaign.Id, ContactId = testContact.Id, Status = 'Pending');
        insert testCampaignMember;

        // Set up trigger context
        CampaignMember[] campaignMembersToUpdate = new CampaignMember[] {testCampaignMember};
        CampaignMember[] oldCampaignMembers = new CampaignMember[] {new CampaignMember(Status = 'Pending')};
        
        Test.startTest();
        // Update campaign members to trigger the trigger
        testCampaignMember.Status = 'Follow Up';
        update testCampaignMember;
        Test.stopTest();

        // Retrieve inserted task for assertion
        Task[] insertedTasks = [SELECT Id, Subject, Status, OwnerId, WhatId, WhoId FROM Task];

        // Assert that the task was inserted
        System.assertEquals(1, insertedTasks.size());
        Task insertedTask = insertedTasks[0];
        System.assertEquals('Follow Up Campaign Member', insertedTask.Subject);
        System.assertEquals('Not Started', insertedTask.Status);
   //     System.assertEquals(testAccount.OwnerId, insertedTask.OwnerId);
        System.assertEquals(testCampaign.Id, insertedTask.WhatId);
        System.assertEquals(testContact.Id, insertedTask.WhoId);
    }
}