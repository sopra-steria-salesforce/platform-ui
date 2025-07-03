public with sharing class TaskCalculation {
  public static void updateNumberOfOpenTasks(List<Task> tasks) {
    List<String> whatIds = getWhatIds(tasks);
    List<Opportunity> opportunities = getValidOpprtunities(whatIds);

    updateActivityDateInOpportunities(opportunities);
  }
  @testVisible
  private static List<string> getWhatIds(List<Task> tasks) {
    List<String> result = new List<String>();

    for (Task t : tasks) {
      if (t.WhatId != null)
        result.add(t.WhatId);
    }
    return result;
  }

  @testVisible
  private static List<Opportunity> getValidOpprtunities(List<String> ids) {
    return [SELECT Id FROM Opportunity WHERE Id IN :ids];
  }

  @testVisible
  private static void updateActivityDateInOpportunities(
    List<Opportunity> opportunities
  ) {
    for (Opportunity o : opportunities) {
      o.Last_Created_Activity__c = Date.today();
    }
    if (opportunities.size() > 0) {
      update opportunities;
    }
  }
}