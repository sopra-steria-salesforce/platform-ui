public with sharing class setOpportunityFieldHistory {
  public static Date myDate;
  public static void stage4() {
    List<Opportunity> updateOpps = new List<Opportunity>();
    List<Opportunity> myOpps = [
      SELECT Id, Name
      FROM Opportunity
      WHERE Calendar_YEAR(DashboardsGSP__Last_Stage_Change_Date__c) = 2024
      //AND StageName = '4 -Offer'
      LIMIT 10
    ];
    for (Opportunity record : myOpps) {
      System.debug('evaluate first opportunity');
      myDate = null;
      for (OpportunityFieldHistory ofh : [
        SELECT Id, CreatedDate, OpportunityId, Field, NewValue
        FROM OpportunityFieldHistory
        WHERE
          Field = 'StageName'
          //AND Calendar_Year(CreatedDate) = 2024
          AND OpportunityId = :record.id
        ORDER BY CreatedDate DESC
      ]) {
        //for (OpportunityFieldHistory ofh : oppFieldHistories) {
        System.debug('evaluate an opportunity field history record');
        if (
          ofh.NewValue == '4 - Offer' &&
          (myDate == null ||
          myDate < ofh.CreatedDate.Date())
        ) {
          myDate = ofh.CreatedDate.Date();
          System.debug('my date:' + myDate);
        }
      }
      record.Stage_4_Date__c = myDate;
      updateOpps.add(record);
    }

    update updateOpps;
  }
}