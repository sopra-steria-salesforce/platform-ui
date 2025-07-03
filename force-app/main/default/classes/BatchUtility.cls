//Jessie Rymph March 2025, This utility is used with BUOwner but can be used by any batch

public class BatchUtility implements Database.Batchable<sObject> {
  public final String Query;
  public final String Entity;
  public final String Field;
  public final String Value;

  public batchUtility(String q, String e, String f, String v) {
    Query = q;
    Entity = e;
    Field = f;
    Value = v;
    System.debug('value v:' + v);
  }

  public Database.QueryLocator start(Database.BatchableContext bc) {
    System.debug('query is debugged here:' + query);
    return Database.getQueryLocator(query);
  }

  public void execute(Database.BatchableContext bc, List<sObject> scope) {
    for (Sobject s : scope) {
      s.put(Field, Value);
    }
    update scope;
  }

  public void finish(Database.BatchableContext bc) {
  }
}