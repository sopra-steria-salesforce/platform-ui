//Entity subscriptions are created when a user follows a record.
// there is a limit on how many records a user can follow. When the opportunity reaches closed delete followers.
//This is called by the scheduled flow Opportunity: Cancel Subscriptions and it runs every day.
public class DeleteObsoleteEntitySubscriptions {
  @InvocableMethod
  public static void SubscriptionDelete(List<Id> OpportunityIds) {
    List<EntitySubscription> Subscriptions = [
      SELECT id
      FROM EntitySubscription
      WHERE Parent.id IN :OpportunityIds
    ];
    delete Subscriptions;
  }
}