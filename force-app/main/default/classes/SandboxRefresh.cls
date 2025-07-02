global class SandboxRefresh implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Email FROM Contact WHERE Email != null LIMIT 200';
       
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {
        for(Contact c : scope)
        {
            c.Email = c.Email +'.UAT';
            System.debug(c.Email);
        }
        update scope;
    }
    global void finish(Database.BatchableContext BC) {
    }
}