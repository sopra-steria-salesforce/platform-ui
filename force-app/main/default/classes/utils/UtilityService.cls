public inherited sharing class UtilityService {
    public static final Boolean isPROD {
        get {
            if (isPROD ==null) {
                isPROD =![SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
            }
            return isPROD;
        }
        set;
    }

    public static final Boolean isSandbox {
        get{
            if (isSandbox==null) {
                Organization currentOrganization = [SELECT IsSandbox, TrialExpirationDate FROM Organization LIMIT 1];
                isSandbox=currentOrganization.IsSandbox && currentOrganization.TrialExpirationDate==null;
            }
            return isSandbox;
        }
        set;
    }

    public static final Boolean isScratchOrg {
        get{
            if (isScratchOrg==null) {
                Organization currentOrganization = [SELECT IsSandbox, TrialExpirationDate FROM Organization LIMIT 1];
                isScratchOrg= currentOrganization.IsSandbox && currentOrganization.TrialExpirationDate!=null;
            }
            return isScratchOrg;
        }
        set;
    }

    public static String getSandboxName() {
        String url = System.URL.getOrgDomainUrl().getHost().toUpperCase();
         if (url.contains('QA')) {
            return 'QA';
        }
        else if (url.contains('UAT')) {
            return 'UAT';
        }
        else {
            return '';
        }
    }

    // Assumes that oldRecords & newRecords have the same order & size
    public static List<SObject> getRecordsWithChangedFieldValue(List<SObject> oldRecords, List<SObject> newRecords, String field, String fieldValue ){
        List<SObject> changedRecords = new List<SObject>();
        for (Integer i=0; i<newRecords.size(); i++){
            String oldValue = String.valueOf(oldRecords[i].get(field));
            String newValue = String.valueOf(newRecords[i].get(field));
            if (fieldValue.equals(newValue) && (oldValue == null || !oldValue.equals(newValue))) {
                changedRecords.add(newRecords[i]);
            }
        }
        return changedRecords;
    }
}