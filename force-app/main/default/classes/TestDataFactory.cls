/* 31.3.25 Using a separate class TestDataInsertUser to create the user
that owns opportunities
 */
@IsTest
public class TestDataFactory {
    public class MockException extends Exception {
    }

    public static List<Opportunity> createOpportunities(Integer numberOfRecords, Boolean doInsert, Boolean addMockId) {
        if (doInsert && addMockId) {
            throw new MockException('Cannot add Mock Id to inserted record!');
        }
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            Opportunity opportunity = new Opportunity(
                Id = addMockId ? generateFakeId(Opportunity.SObjectType) : null,
                AccountId = createAccount(doInsert, addMockId).Id,
                Name = 'Test Opportunity ' + i,
                StageName = '1 - Possibility',
                Status__c = '-',
                Business_Unit__c = 'APPS',
                Contract_Category__c = 'New contract (not connected to framework/capacity agreement)',
                CloseDate = Date.today() + 1,
                Consultants__c = 1,
                Months__c = 1,
                Proposal_Due_Date_Time__c = DateTime.now(),
                Type = 'Frame Agreement'
            );
            opportunities.add(opportunity);
        }
        if (doInsert) {
            insert opportunities;
        }
        return opportunities;
    }

    public static List<Account> createAccounts(Integer numberOfRecords, Boolean doInsert, Boolean addMockId) {
        if (doInsert && addMockId) {
            throw new MockException('Cannot add Mock Id to inserted record!');
        }
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            accounts.add(
                new Account(
                    Id = addMockId ? generateFakeId(Account.SObjectType) : null,
                    Name = (Math.random() * 10).format() + 'Client Name',
                    Country__c = 'Norway',
                    Apps_Owner__c = UserInfo.getUserId()
                )
            );
        }
        if (doInsert) {
            insert accounts;
        }
        return accounts;
    }

    public static Account createAccount(Boolean doInsert, Boolean addMockId) {
        /*Database.DMLOptions dml = new Database.DMLOptions();
	dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
	dml.DuplicateRuleHeader.runAsCurrentUser = true;*/
        Account account = new Account(
            Id = addMockId ? generateFakeId(Account.SObjectType) : null,
            Name = (Math.random() * 10).format() + 'Client Name',
            Country__c = 'Norway',
            Apps_Owner__c = UserInfo.getUserId()
        );
        if (doInsert) {
            insert account;
        }
        return account;
    }

    public static List<Opportunity> createOpportunities(Integer numberOfOpportunities) {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        Account a = createAccount();
        List<Opportunity> result = new List<Opportunity>();
        for (Integer i = 0; i < numberOfOpportunities; i++) {
            result.add(
                new Opportunity(
                    Name = 'TestDataFactoryTestOpportunity12345',
                    StageName = '1 - Possibility',
                    Status__c = '-',
                    Business_Unit__c = 'APPS',
                    Contract_Category__c = 'New contract (not connected to framework/capacity agreement)',
                    CloseDate = Date.today() + 1,
                    Consultants__c = 1,
                    Months__c = 1,
                    AccountID = a.Id,
                    Proposal_Due_Date_Time__c = DateTime.now(),
                    Type = 'Frame Agreement'
                )
            );
        }

        insert result;
        return result;
    }

    public static List<Opportunity> createOpportunitiesToTestFlows(Integer numberOfOpportunities) {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        Account a = createAccount();
        List<Opportunity> result = new List<Opportunity>();
        for (Integer i = 0; i < numberOfOpportunities; i++) {
            result.add(
                new Opportunity(
                    Name = 'Opportunities Testing Flows',
                    StageName = '1 - Possibility',
                    Status__c = '-',
                    Business_Unit__c = 'APPS',
                    CloseDate = Date.today() + 30,
                    Consultants__c = 2,
                    Months__c = 1,
                    AccountID = a.Id,
                    Type = 'Frame Agreement'
                )
            );
        }

        insert result;
        return result;
    }

    public static List<Opportunity> createOpportunitiesToTestFlowsWithTwoBuLeads(Integer numberOfOpportunities) {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        Account a = createAccount();
        List<Opportunity> result = new List<Opportunity>();
        for (Integer i = 0; i < numberOfOpportunities; i++) {
            result.add(
                new Opportunity(
                    Name = 'Opportunities Testing Flows',
                    StageName = '1 - Possibility',
                    Status__c = '-',
                    Business_Unit__c = 'APPS;DPS;',
                    CloseDate = Date.today() + 30,
                    Consultants__c = 2,
                    Months__c = 1,
                    AccountID = a.Id,
                    Type = 'Frame Agreement'
                )
            );
        }

        insert result;
        return result;
    }

    public static Opportunity createOpportunity() {
        List<Opportunity> opportunities = createOpportunities(1);
        return opportunities[0];
    }

    public static Opportunity createOpportunityWithBidRoom() {
        Account a = createAccount();
        Opportunity result = new Opportunity(
            Name = 'TestDataFactoryTestOpportunity12345',
            StageName = '1 - Possibility',
            Status__c = '-',
            Business_Unit__c = 'APPS',
            CloseDate = Date.today(),
            Consultants__c = 1,
            Months__c = 1,
            AccountID = a.Id,
            Proposal_Due_Date_Time__c = DateTime.now()
        );
        result.Bid_Number__c = 'https://steria.sharepoint.com/sites/intra_sc_tilbud1/110';

        insert result;
        return result;
    }

    public static List<Bid__c> createBids(Integer numberOfBids) {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        Account a = createAccount();
        Opportunity o = createOpportunity();

        List<Bid__c> result = new List<Bid__c>();
        for (Integer i = 0; i < numberOfBids; i++) {
            //         result.add(new Bid__c(Opportunity__c = o.Id, BID_Number__c = '1'));
            result.add(new Bid__c(Opportunity__c = o.Id, BID_Number__c = i.format()));
        }

        insert result;
        return result;
    }
    //public static Bid__c createBid() {
    //List<Bid__c> Bids = createBids(1);
    //return BidsWithoutUrl[0];
    //}
    public static List<Bid__c> createBidsWithoutBidUrl(Integer numberOfBids) {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        Account a = createAccount();
        Opportunity o = createOpportunity();

        List<Bid__c> result = new List<Bid__c>();
        for (Integer i = 0; i < numberOfBids; i++) {
            result.add(new Bid__c(Opportunity__c = o.Id));
        }

        insert result;
        return result;
    }
    //public static Bid__c createBidWithoutURL() {
    //List<Bid__c> Bids = createBidsWithoutBidUrl(1);
    //return BidsWithoutUrl[0];
    //}

    public static Task createTask(String whatId, Boolean isClosed) {
        List<Task> result = createTasks(1, whatId, isClosed);
        return result[0];
    }

    public static List<Task> createTasks(Integer numberOfTasks, String whatId, Boolean isClosed) {
        String status = 'Open';

        if (isClosed)
            status = 'Completed';

        List<Task> result = new List<Task>();
        for (Integer i = 0; i < numberOfTasks; i++) {
            result.add(new Task(WhatId = whatId, Subject = 'Test', Status = status));
        }
        insert result;
        return result;
    }

    public static Task createTaskContact(Integer numberOfTasks, String whoId) {
        List<Task> result = createTasksContact(1, whoId);
        return result[0];
    }

    public static List<Task> createTasksContact(Integer numberOfTasks, String whoId) {
        List<Task> result = new List<Task>();
        for (Integer i = 0; i < numberOfTasks; i++) {
            result.add(new Task(WhoId = whoId, Subject = 'Test'));
        }
        insert result;
        return result;
    }

    public static Event createEventContact(Integer numberOfEvents, String whoId) {
        List<Event> result = createEventsContact(1, whoId);
        return result[0];
    }

    //public static List<Event> createEventsContact(Integer numberOfEvents, String whoId, String assignedTo, Datetime startdatetime, dateTime enddatetime) {

    public static List<Event> createEventsContact(Integer numberOfEvents, String whoId) {
        List<Event> result = new List<Event>();
        for (Integer i = 0; i < numberOfEvents; i++) {
            result.add(new Event(WhoId = whoId, Subject = 'Test', startdatetime = DateTime.now(), enddatetime = DateTime.now()));
        }
        insert result;
        return result;
    }

    public static List<Account> createAccounts(Integer numberOfAccounts) {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        List<Account> result = new List<Account>();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        // Insert account as current user
        System.runAs(thisUser) {
            User u = createUser();
            for (Integer i = 0; i < numberOfAccounts; i++) {
                Integer m = numberOfAccounts;
                m = m + 1;
                result.add(new Account(Name = (Math.random() * 10).format() + 'Client Name', Country__c = 'Norway', Apps_Owner__c = u.Id));
            }
            insert result;
        }
        return result;
    }

    public static Account createAccount() {
        TriggerHandler.bypass('AccountTriggerHandler');
        List<Account> result = createAccounts(1);
        return result[0];
    }

    public static List<Contact> createContacts(Integer numberOfContacts) {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        Account a = createAccount();
        List<Contact> result = new List<Contact>();

        for (Integer i = 0; i < numberOfContacts; i++) {
            Integer m = numberOfContacts;
            m = m + 1;
            result.add(
                new Contact(FirstName = (Math.random() * 10).format() + 'First Name', LastName = (Math.random() * 10).format() + 'Last Name', AccountId = a.Id, Email = 'cuddlypuppy' + i + '@aol.com')
            );
        }
        insert result;
        return result;
    }

    public static Contact createContact() {
        //  Account a=createAccount();
        List<Contact> result = createContacts(1);
        return result[0];
    }

    public static User createUser() {
        testDataInsertUser.insertUser(1);
        List<User> result = [
            SELECT Id, Alias, Email
            FROM User
            WHERE Alias LIKE '%testu%' AND Email LIKE '%test@example.com%'
        ];
        return result[0];
    }

    public static List<User> createUsers(Integer i) {
        testDataInsertUser.insertUser(i);
        List<User> result = [
            SELECT Id, Alias, Email
            FROM User
            WHERE Alias LIKE '%testu%' AND Email LIKE '%test@example.com%'
        ];
        return result;
    }

    public static Account createAccountWithCheckInBrreg(Boolean shouldInsert, String accountOrgNumber) {
        Account account = new Account(Name = 'Test account', Org_number__c = accountOrgNumber, Country__c = 'Norway');
        if (shouldInsert) {
            insert account;
        }
        return account;
    }
    public static Lead createLead(Boolean shouldInsert, Id accountId) {
        Lead lead = new Lead(FirstName = 'Test', LastName = 'Test LastName', Company = 'Company Test', Account__c = accountId);
        if (shouldInsert) {
            insert lead;
        }
        return lead;
    }

    private static Integer mockIncrement=0;
    private static Integer getMockIncrement(){
        mockIncrement++;
        return mockIncrement;
    }
    //https://salesforce.stackexchange.com/questions/21137/creating-unit-tests-without-interacting-with-the-database-creating-fake-ids
    public static String generateFakeId(Schema.SObjectType sObjectType) {
        String result = String.valueOf(getMockIncrement());
        return sObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12 - result.length()) + result;
    }
}
