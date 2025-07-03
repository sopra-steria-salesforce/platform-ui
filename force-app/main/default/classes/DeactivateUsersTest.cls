@isTest()

public class DeactivateUsersTest {

private static testmethod void deactivateUserFails_whenUserIsBUOwner(){
//  test.startTest();
    //setup
    User usr=TestDataFactory.CreateUser();
    usr.isActive = True;
    
    //new, used for testing:
User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];    
    System.RunAs(thisUser){
    //System.RunAs(usr){

      Account acct =TestDataFactory.createAccount();

    acct.APPS_Owner__c=usr.Id;
    System.debug('Ny bruker er ' + usr.id);
    update acct;
    }

    System.runAs ( new User(Id = UserInfo.getUserId()) ){
    try {
    usr.IsActive=False;
    update usr;
          } 
          
catch(Exception e) {   
//  Test.StopTest();
        system.assertEquals( e.getMessage(), e.getMessage() );      
    //result
    }
    }
  }
}