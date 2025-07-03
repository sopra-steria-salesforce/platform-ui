//batch

public class setOpportunityHistory {
  public static Date myDate;
  public static void stage4(Id myOppId) {
    List<Opportunity> updateOpps = new List<Opportunity>();
    List<Opportunity> myOpps = [
      SELECT Id, Name
      FROM Opportunity
      WHERE Id = :myOppId
      //Calendar_YEAR(DashboardsGSP__Last_Stage_Change_Date__c) = 2024
      //AND StageName = '4 -Offer'
      //AND Contract_Price_Model__c != ''
      //LIMIT 10
    ];
    for (Opportunity record : myOpps) {
      for (OpportunityHistory ofh : [
        SELECT Id, CreatedDate, OpportunityId, StageName
        FROM OpportunityHistory
        WHERE
          StageName = '4 - Offer'
          AND Calendar_Year(CreatedDate) = 2024
          AND OpportunityId = :record.id
        ORDER BY CreatedDate DESC
        LIMIT 1
      ]) {
        myDate = ofh.CreatedDate.Date();
        System.debug('my date:' + myDate);
        record.Stage_4_Date__c = myDate;
        updateOpps.add(record);
      }
      update updateOpps;
    }
  }
}