@isTest
private class ContactsDeleteTest  {
    private static testmethod void  taskIsKeptWhenContactIsDeleted(){
        //setup
        System.debug('start test class');
        List<Contact> contactList=TestDataFactory.createContacts(1);
        contact c = contactList[0];
        Account a = [SELECT ID, Name FROM Account where ID =: c.AccountId];
        List<Task> result = TestDataFactory.createTasksContact(3,contactList[0].ID);
        String contactID = c.Id;
        String taskID = result[0].Id;
        
        //act

        delete contactList;
        List<Task> after = [SELECT Id, WhatID, WhoID from Task where id =: taskId];

        for (task t:after){
//        for (Integer i = 0; i < after.size(); i++) {
            //System.assertEquals(null,after[i].whoId);
            //System.assertEquals(a.Id, after[i].whatId);
    //        System.assertEquals(null,t.whoId);
            System.assertEquals(a.Id, t.whatId);
        }
    }

        private static testmethod void  eventIsKeptWhenContactIsDeleted(){
        //setup

        List<Contact> contactListEvent=TestDataFactory.createContacts(1);
        contact cEvent = contactListEvent[0];
        Account a = [SELECT ID, Name FROM Account where ID =: cEvent.AccountId];
        List<Event> result = TestDataFactory.createEventsContact(1,contactListEvent[0].ID);
        String contactID = cEvent.Id;
        String eventId = result[0].Id;
        
        //act

    
        delete contactListEvent;
        List<Event> after =  [SELECT Id, WhatID, WhoID from Event where id =: eventId];
          //for (Integer i = 0; i < after.size(); i++) {
            //System.assertEquals(null,after[i].whoId);
            //System.assertEquals(a.Id, after[i].whatId);
            for (Event e:after) {
       //     System.assertEquals(null,e.whoId);
            System.assertEquals(a.Id, e.whatId);
        }
         
        

    }

}