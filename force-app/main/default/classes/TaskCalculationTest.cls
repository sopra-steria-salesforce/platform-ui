@isTest
private class TaskCalculationTest { 


    private static testmethod void getWhatIds_hasTwoIds(){
            //setup
            List<Opportunity> opportunities=new List<Opportunity>();
            opportunities=TestDataFactory.createOpportunities(2);
            
            List<Task> tasks=new List<Task>();
            tasks.add(new Task(WhatId=opportunities[0].Id));
            tasks.add(new Task(WhatId=opportunities[1].Id));
            tasks.add(new Task(Subject='No opportunity'));
            
            //act
            List<string> result=TaskCalculation.getWhatIds(tasks);
            
            //result
            System.assertEquals(opportunities[0].Id,result[0]);
            System.assertEquals(opportunities[1].Id,result[1]);
            System.assertEquals(2,result.size());
        }

	private static testmethod void getValidOpportunities_hasTwoIds_whenTwoValidAndOneInvalidId(){
		//setup
		List<Opportunity> opportunities=new List<Opportunity>();
        opportunities=TestDataFactory.createOpportunities(2);

        //act
		List<String> ids=new List<String>();
		ids.add(opportunities[0].Id);
		ids.add(opportunities[1].Id);
		ids.add('00358000005Gx7X');

        //result
		List<Opportunity> result=TaskCalculation.getValidOpprtunities(ids);
		System.assertEquals(2,result.size());
	}
}