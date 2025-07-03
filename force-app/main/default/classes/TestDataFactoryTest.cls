@isTest
private class TestDataFactoryTest {
  private static testMethod void createOpportunities_twoOpportunitiesAreCreated() {
    List<Opportunity> result = TestDataFactory.createOpportunities(2);
    System.assertEquals(2, result.size());
  }

  private static testMethod void createOpportunitiy_oneOpportunityIsCreated() {
    Opportunity result = TestDataFactory.createOpportunity();
    System.assertNotEquals(null, result.Id);
  }
  private static testMethod void createOpportunitiyWithBidRoom_oneOpportunityIsCreatedWithBidRoom() {
    Opportunity result = TestDataFactory.createOpportunityWithBidRoom();
    System.assertNotEquals(null, result.Bid_Number__c);
  }

  private static testMethod void createBids_twoBidsAreCreated() {
    Database.DMLOptions dml = new Database.DMLOptions();
    dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
    dml.DuplicateRuleHeader.runAsCurrentUser = true;

    List<Bid__c> result = TestDataFactory.createBids(2);
    System.assertEquals(2, result.size());
  }

  private static testMethod void createBidsWithoutBidUrl_twoBidsAreCreated() {
    Database.DMLOptions dml = new Database.DMLOptions();
    dml.DuplicateRuleHeader.allowSave = true; //Controlls bypass
    dml.DuplicateRuleHeader.runAsCurrentUser = true;

    List<Bid__c> result = TestDataFactory.createBidsWithoutBidUrl(2);
    System.assertEquals(2, result.size());
  }


  private static testMethod void createTask_oneOpenTaskIsCreated() {
    //setup
    Opportunity o = TestDataFactory.createOpportunity();

    //act
    Task result = TestDataFactory.createTask(o.Id, false);

    //result
    System.assertNotEquals(null, result.Id);
  }

  private static testMethod void createTask_oneClosedTaskIsCreated() {
    //setup
    Opportunity o = TestDataFactory.createOpportunity();

    //act
    Task result = TestDataFactory.createTask(o.Id, true);

    //result
    System.assertNotEquals(null, result.Id);
  }

  private static testMethod void createTasks_twoTasksIsCreated() {
    //setup
    Opportunity o = TestDataFactory.createOpportunity();

    //act
    List<Task> result = TestDataFactory.createTasks(2, o.Id, false);

    //result
    System.assertEquals(2, result.size());
  }

  private static testMethod void createTaskContact_oneTaskContactIsCreated() {
    //setup
    Contact c = TestDataFactory.createContact();

    //act
    Task result = TestDataFactory.createTaskContact(1, c.Id);

    //result
    System.assertNotEquals(null, result.Id);
  }

  private static testMethod void createTasksContact_twoTasksContactIsCreated() {
    //setup
    Contact c = TestDataFactory.createContact();

    //act
    List<Task> result = TestDataFactory.createTasksContact(2, c.Id);

    //result
    System.assertEquals(2, result.size());
  }

  private static testMethod void createEventContact_oneEventContactIsCreated() {
    //setup
    Contact c = TestDataFactory.createContact();

    //act
    Event result = TestDataFactory.createEventContact(1, c.Id);

    //result
    System.assertNotEquals(null, result.Id);
  }

  private static testMethod void createEventsContact_twoEventsContactIsCreated() {
    //setup
    Contact c = TestDataFactory.createContact();

    //act
    List<Event> result = TestDataFactory.createEventsContact(2, c.Id);

    //result
    System.assertEquals(2, result.size());
  }

  private static testMethod void createAccount_oneAccountIsCreated() {
    //act
    Account result = TestDataFactory.createAccount();

    //result
    System.assertNotEquals(null, result.Id);
  }

  private static testMethod void createAccounts_twoAccountsAreCreated() {
    //act
    List<Account> result = TestDataFactory.createAccounts(2);

    //result
    System.assertEquals(2, result.size());
  }
  private static testMethod void createContact_oneContactIsCreated() {
    //act
    Contact result = TestDataFactory.createContact();

    //result
    System.assertNotEquals(null, result.Id);
  }

  private static testMethod void createContacts_twoContactsAreCreated() {
    //act
    List<Contact> result = TestDataFactory.createContacts(2);

    //result
    System.assertEquals(2, result.size());
  }

  private static testMethod void createUsers_oneUserIsCreated() {
    User result = TestDataFactory.createUser();
    System.assertNotEquals(null, result.Id);
  }
}