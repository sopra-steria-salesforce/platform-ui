public with sharing class OpportunityUpdateBULead implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(List<Opportunity> newOpportunities, List<Opportunity> oldOpportunities) {
        for (Opportunity opportunity : newOpportunities) {
            if (opportunity.Business_Unit_Count__c == 1 && opportunity.StageName != Utils.PLANNING_0) {
                opportunity.BU_Lead__c = opportunity.Business_Unit__c;
            }
        }
    }
}