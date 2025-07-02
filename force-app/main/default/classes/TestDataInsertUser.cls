public class TestDataInsertUser {
  public static void insertUser(Integer numberOfUsers) {
    List<User> result = new List<User>();
    Integer n = numberOfUsers;
    for (Integer i = 0; i < numberOfUsers; i++) {
      n = n + 1;
      String orgId = UserInfo.getOrganizationId();
      String dateString = String.valueof(Datetime.now())
        .replace(' ', '')
        .replace(':', '')
        .replace('-', '');
      Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
      Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
      String uniqueName = orgId + dateString + randomInt;
      result.add(
        new User(
          Alias = 'testu' + n,
          Email = 'test@example.com' + n,
          Email2__c = 'test@example.com' + n,
          Country = 'Norway',
          EmailEncodingKey = 'ISO-8859-1',
          LastName = 'Test',
          LanguageLocaleKey = 'en_US',
          LocaleSidKey = 'no_NO',
          TimeZoneSidKey = 'Europe/Paris',
          ProfileId = p.Id,
          UserName = 'test' + uniqueName + '@soprasteriaxTest.com',
          Business_Unit__c = 'APPS',
          IsActive = true
        )
      );
    }

    insert result;
  }
}