@isTest
private class TasksTriggerTest {
  private static testMethod void lastCreatedActivity_isToday() {
    //setup
    Opportunity o = TestDataFactory.createOpportunity();

    //act
    Task t = TestDataFactory.createTask(o.Id, false);

    //result
    Opportunity result = [
      SELECT Last_Created_Activity__c
      FROM Opportunity
      WHERE Id = :o.Id
    ];
    System.assertEquals(Date.today(), result.Last_Created_Activity__c);
  }
}