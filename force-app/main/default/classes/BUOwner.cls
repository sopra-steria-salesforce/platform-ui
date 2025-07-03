//Jessie Rymph, September 2024
//This invocable method runs in the flow User: Manage Users. It accepts the current owner variable, the new owner variable,
//the name of the business owner field and the business unit variable.
//If the names change for BU or BU Owner fields, they need to be changed in the Utils class.
//This adjusts both the accounts and the opportunities.
//Test with TestChangeBuOwner and testChangeBuOwnerUtil
//This calls the BatchUtility class

public class BUOwner {
  public static String e;
  public static String v;
  public static String f;
  public static String q;

  @InvocableMethod(
    label='AccountChangeBU Owner'
    description='This apex will change the business unit owner of all accounts connected to this user. '
  )
  public static void accountBUOwnerInvoke(List<FlowInputs> input) {
    for (FlowInputs i : input) {
      generateQueryStringAccount(
        i.var_currentOwnerId,
        i.var_newOwnerId,
        i.var_BU,
        i.var_BUOwnerField
      );
      generateQueryStringOpportunity(
        i.var_currentOwnerId,
        i.var_newOwnerId,
        i.var_BU,
        i.var_BUOwnerField
      );
    }
  }

  public static void generateQueryStringAccount(
    String var_currentOwnerId,
    String var_newOwnerId,
    String var_BU,
    String var_BUOwnerField
  ) {
    e = 'Account';
    v = var_newOwnerId;
    f = var_BUOwnerField;
    System.debug('f variable BuOwnerField' + f);
    q =
      'SELECT Id from Account WHERE ' +
      f +
      '= \'' +
      var_currentOwnerId +
      '\'';
    System.debug('debug the query here in generateQueryStringAccount' + q);
    Id batchInstanceId = Database.executeBatch(
      new batchUtility(q, e, f, v)
    );
  }
  public static void generateQueryStringOpportunity(
    String var_currentOwnerId,
    String var_newOwnerId,
    String var_BU,
    String var_BUOwnerField
  ) {
    e = 'Opportunity';
    f = var_BUOwnerField;
    v = var_newOwnerId;
    q =
      'SELECT Id FROM Opportunity WHERE ' +
      f +
      '= \'' +
      var_currentOwnerId +
      '\' AND IsClosed != true';
    Id batchInstanceId = Database.executeBatch(
      new batchUtility(q, e, f, v)
    );
  }
  //input details that comes to apex from flow
  public class FlowInputs {
    @InvocableVariable
    public String var_currentOwnerId;
    @InvocableVariable
    public String var_newOwnerId;
    @InvocableVariable
    public String var_BU;
    @InvocableVariable
    public String var_BUOwnerField;
  }

  //output details that go out from Flow
  public class FlowOutputs {
    @InvocableVariable
    public String out;
  }
}