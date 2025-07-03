public class DeactivateUser {
  public static void main(List<User> userList) {
    List<Account> accountList = new List<Account>();
    List<Opportunity> opportunityList = new List<Opportunity>();
    List<ID> UserIds = new List<ID>();

    for (User usr : userList) {
      UserIds.add(usr.ID);

      accountList = [
        SELECT ID, Name, OwnerID, APPS_Owner__c, BC_Owner__c, DPS_Owner__c
        FROM Account
        WHERE
          OwnerID IN :UserIDs
          OR APPS_Owner__c IN :UserIDs
          OR BC_Owner__c IN :UserIDs
          OR DPS_Owner__c IN :UserIDs
      ];
      opportunityList = [
        SELECT
          ID,
          Description,
          OwnerID,
          APPS_Owner__c,
          BC_Owner__c,
          DPS_Owner__c
        FROM Opportunity
        WHERE
          (OwnerID IN :UserIDs
          OR APPS_Owner__c IN :UserIDs
          OR BC_Owner__c IN :UserIDs
          OR DPS_Owner__c IN :UserIDs)
          AND IsClosed = FALSE
      ];

      if (
        (accountList.size() > 0 || opportunityList.size() > 0) &
        usr.IsActive == false
      ) {
        String msg =
          'The User is owner or BU owner for ' +
          accountList.size() +
          ' accounts and ' +
          opportunityList.size() +
          ' opportunities. Reassign ownerships before you deactivate. (This is a trigger.)';
        usr.addError(msg);
      }
    }
  }
}