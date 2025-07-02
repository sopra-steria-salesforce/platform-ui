trigger TasksTrigger on Task (after insert)  {

            TaskCalculation.updateNumberOfOpenTasks(Trigger.new);
 }