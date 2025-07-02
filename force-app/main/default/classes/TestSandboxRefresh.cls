@isTest
public class TestSandboxRefresh {
    static testMethod void testMethod1() {
            TestDataFactory.createContacts(200);
        Test.startTest();
            SandboxRefresh obj = new SandboxRefresh();
            DataBase.executeBatch(obj);
        Test.stopTest();
        List <Contact> contacts = [SELECT Email FROM Contact ];
        for(Contact c : contacts)
        {
            c.Email = c.Email +'.UAT';
            System.debug(c.Email);
        }
        System.assertEquals(200, contacts.size());
    }
}