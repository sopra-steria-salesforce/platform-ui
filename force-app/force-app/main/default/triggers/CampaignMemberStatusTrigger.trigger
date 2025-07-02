trigger CampaignMemberStatusTrigger on CampaignMember (after update) {
    for (CampaignMember cm : Trigger.new) {
        // Check if Status field is changed to "follow up"
        if (cm.Status == 'follow up' && Trigger.oldMap.get(cm.Id).Status != 'follow up') {
            // Initialize variables to store related Contact or Lead and Account Owner
            SObject relatedObject;
            Id accountId;

            // Check if CampaignMember is related to a Contact
            if (cm.ContactId != null) {
                // Query for the related Contact and its AccountId
                Contact relatedContact = [SELECT AccountId FROM Contact WHERE Id = :cm.ContactId LIMIT 1];
                if (relatedContact != null && relatedContact.AccountId != null) {
                    relatedObject = relatedContact;
                    accountId = relatedContact.AccountId;
                }
            }
            // Check if CampaignMember is related to a Lead
            else if (cm.LeadId != null) {
                // Query for the related Lead and its AccountId
                Lead relatedLead = [SELECT Account__c FROM Lead WHERE Id = :cm.LeadId LIMIT 1];
                if (relatedLead != null && relatedLead.Account__c != null) {
                    relatedObject = relatedLead;
                    accountId = relatedLead.Account__c;
                }
            }

            // If a related Contact or Lead exists
            if (relatedObject != null && accountId != null) {
                // Query for the related Account Owner
                Account relatedAccount = [SELECT OwnerId FROM Account WHERE Id = :accountId LIMIT 1];
                
                // Query for the related Campaign
                CampaignMember relatedCampaignMember = [SELECT CampaignId FROM CampaignMember WHERE Id = :cm.Id LIMIT 1];
                
                // Check if the related CampaignMember exists
                if(relatedCampaignMember != null) {
                    // Calculate due date (5 days from today)
                    Date dueDate = Date.today().addDays(5);
                    
                    // Create a Task for the Account Owner
                    Task newTask = new Task();
                    newTask.Subject = 'Follow Up Campaign Member';
                    newTask.Priority = 'Normal';
                    newTask.Status = 'Not Started';
                    newTask.ActivityDate = dueDate; // Set due date to 5 days from today
                    newTask.OwnerId = relatedAccount.OwnerId;
                    newTask.WhatId = cm.Id; // Link the Task to the Campaign Member
                    newTask.WhatId = relatedCampaignMember.CampaignId; // Link the Task to the Campaign
                    newTask.WhoId = cm.ContactId; // Add contact to task record
                    insert newTask;
                }
            }
        }
    }
}