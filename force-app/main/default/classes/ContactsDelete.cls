public class ContactsDelete  {

 //     description='Transfer a Contact's activities to the Account when Contact is deleted'
    public static void realignActivities(List<Contact> contactList) {
        List<Task> taskList = New List<Task>();
        List<Event> eventList = New List<Event>();
    
    for (integer i =0 ; i < contactList.size(); i++){
        taskList=[SELECT Id, WhoId, WhatId FROM Task WHERE WhoId =: contactList[i].Id];
        
    //  for (Task t : taskList) {
    for (integer t = 0; t < taskList.size(); t ++) {
            taskList[t].WhoId = null;
            taskList[t].WhatID = contactList[i].AccountId ; 
        }
        update taskList; 
        System.debug('ContactsDelete class: tasklist ' + taskList); 

        eventList=[SELECT Id, WhoId, WhatId FROM Event WHERE WhoId =: contactList[i].Id];
    //  for (Event e : eventList) {
    for (integer e = 0; e < eventList.size(); e ++) {
     //       eventList[e].WhoId = null;
            eventList[e].WhatID = contactList[i].AccountId ; 
        }
        update eventList; 
                System.debug('eventlist ' + eventList); 
    }
  }
}