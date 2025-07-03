@isTest
public class TestFlowOppStageChange {
  //test for flow Record Triggered: Opp Changes After Save

  @isTest
  static void setCurrencyRateTest() {
    // Test cannot work in package validation (build org) until Salesforce supports installing package versions using SO snapshots in PROD
    if (!UtilityService.isScratchOrg) {
      Double currencyRate = 11.34;
      Currency__c nokCurrency = new Currency__c(
              Name = 'NOK',
              Rate__c = currencyRate
      );
      insert nokCurrency;
      TestDataFactory.createOpportunitiesToTestFlows(1);
      Opportunity oneOpp = [
              SELECT CloseDate, Id, StageName, Status__c, Currency__c, EUR_Rate__c
              FROM Opportunity
              LIMIT 1
      ];
      System.debug(oneOpp.EUR_Rate__c + 'currencyOpp');
      System.assertEquals(
              currencyRate,
              oneOpp.EUR_Rate__c,
              'The currency rate has not been updated.'
      );
    } else{
      Assert.isTrue(true);
    }
  }

  //Calculate amount with amount null, months and consultants not null
  @isTest
  static void updateCalculatedAmount() {
    TestDataFactory.createOpportunitiesToTestFlows(1);
    Opportunity oneOpp = [
      SELECT Id, Amount, Consultants__c, Months__c
      FROM Opportunity
      LIMIT 1
    ];
    oneOpp.Consultants__c = 10;
    oneOpp.Months__c = 30;
    oneOpp.Amount = 0;
    update oneOpp;
    Opportunity oneOpp1 = [
      SELECT Amount_old_value__c, Id, Amount, Amount_Calculated__c
      FROM Opportunity
      WHERE Id = :oneOpp.Id
    ];
    System.assertEquals(
      oneOpp1.Amount_old_value__c,
      oneOpp1.Amount_calculated__c
    );
    System.assertEquals(oneOpp1.Amount, oneOpp1.Amount_calculated__c);
  }

  @isTest
  static void newCalculatedAmount() {
    TestDataFactory.createOpportunitiesToTestFlows(1);
    Opportunity oneOpp = [
      SELECT Id, Amount, Amount_Calculated__c, Amount_Old_Value__c
      FROM Opportunity
      LIMIT 1
    ];

    System.assertEquals(
      oneOpp.Amount_old_value__c,
      oneOpp.Amount_calculated__c
    );
    System.assertEquals(oneOpp.Amount, oneOpp.Amount_calculated__c);
  }

  @isTest
  static void singleBULead() {
    TestDataFactory.createOpportunitiesToTestFlows(1);
    Opportunity oneOpp = [
      SELECT BU_Lead__c, StageName, Business_Unit__c
      FROM Opportunity
      LIMIT 1
    ];
    oneOpp.StageName = '2 - RFI';
    update oneOpp;
    System.debug(oneOpp.Bu_Lead__c);
    Opportunity oneOpp1 = [
      SELECT BU_Lead__c, StageName
      FROM Opportunity
      WHERE Id = :oneOpp.Id
      LIMIT 1
    ];
    System.assertEquals(
      Utils.APPS,
      oneopp1.BU_Lead__c,
      'BU Lead should be APPS'
    );
  }

  @isTest
  static void twoBULeads() {
    Test.StartTest();
    TestDataFactory.createOpportunitiesToTestFlowsWithTwoBuLeads(1);
    Test.StopTest();
    Opportunity oneOpp = [
      SELECT BU_Lead__c, StageName, Business_Unit__c
      FROM Opportunity
      LIMIT 1
    ];
    System.debug(oneOpp.Business_Unit__c);
    System.assertEquals(
      null,
      oneopp.BU_Lead__c,
      'There should not be a BU Lead'
    );
  }
}