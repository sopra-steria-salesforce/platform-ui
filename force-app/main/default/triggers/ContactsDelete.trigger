trigger ContactsDelete on Contact (before delete)  { 
 ContactsDelete.realignActivities(Trigger.old);
}