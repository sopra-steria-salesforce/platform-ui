@isTest
public with sharing class OpportunityUpdateBULeadTest {

    @TestSetup
    static void createTestData() {
        Opportunity opportunity = TestDataFactory.createOpportunity();
    }

    @IsTest
    static void updateBusinessUnitTest() {
        Opportunity opportunity = [SELECT Id, Business_Unit__c, Business_Unit_Count__c, BU_Lead__c, StageName FROM Opportunity LIMIT 1];
        System.debug(opportunity);

        Test.startTest();
        opportunity.Business_Unit__c = Utils.APPS;
        update opportunity;
        Test.stopTest();

        Opportunity opportunityAfterUpdate = [SELECT Id, Business_Unit__c, Business_Unit_Count__c, BU_Lead__c, StageName FROM Opportunity LIMIT 1];
        System.assert(opportunityAfterUpdate.BU_Lead__c == Utils.APPS);
    }
}