@isTest
public with sharing class DeleteObsoleteEntitySubscriptionsTest {
  private static testMethod void doTest() {
    List<Opportunity> opportunities = new List<Opportunity>();
    opportunities = TestDataFactory.createOpportunities(1);
    test.startTest();
    //act
    for (integer i = 0; i < opportunities.size(); i++) {
      Opportunity oppt = opportunities[i];
      oppt.StageName = 'Closed';
    }
    update opportunities;

    List<ID> OpptIDs = new List<ID>();
    for (Opportunity oppt : opportunities) {
      OpptIDs.add(oppt.ID);
    }
    List<EntitySubscription> subscriptionList = new List<EntitySubscription>();
    subscriptionList = [
      SELECT ID, parentID, SubscriberID
      FROM EntitySubscription
      WHERE ParentID IN :OpptIDs
    ];
    delete subscriptionList;
    DeleteObsoleteEntitySubscriptions.SubscriptionDelete(OpptIDs);

    subscriptionList = [
      SELECT ID, parentID, SubscriberID
      FROM EntitySubscription
      WHERE ParentID IN :OpptIDs
    ];
    Test.StopTest();
    //result
    System.assertEquals(0, subscriptionList.size());
  }
}