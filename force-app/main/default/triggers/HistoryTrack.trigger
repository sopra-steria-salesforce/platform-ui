trigger HistoryTrack on CampaignMember (before insert, before update) {
    // Map to store unique status values
    Set<String> uniqueStatuses = new Set<String>();

    // Iterate through new CampaignMember records
    for (CampaignMember cm : Trigger.new) {
        // If it's an insert or the status field has changed
        if (Trigger.isInsert || (Trigger.isUpdate && cm.Status != Trigger.oldMap.get(cm.Id).Status)) {
            if(cm.Statuses__c != null) {
                uniqueStatuses.addAll(cm.Statuses__c.split(', '));
            } 
            
            // Add the status value to the set
            uniqueStatuses.add(cm.Status);
            
            // Concatenate all unique status values separated by commas
            cm.Statuses__c = String.join(new List<String>(uniqueStatuses),', ');
        }
    }

   
}