trigger UserTrigger on User (before update)  { 
DeactivateUser.main(Trigger.new); 

}