@IsTest
public class UtilityServiceTest {

    @IsTest
    static void testMethods () {
        Test.startTest();
        UtilityService.getSandboxName();
        Boolean bool = UtilityService.isPROD;
        bool = UtilityService.isSandbox;
        bool = UtilityService.isScratchOrg;
        Test.stopTest();
    }

    @isTest
    static void testgetRecordsWithChangedFieldValue_someChanged() {
        // Arrange
        List<SObject> oldRecords = new List<SObject>{
                new Opportunity(Name = 'Opp A', StageName = Utils.PLANNING_0),
                new Opportunity(Name = 'Opp B', StageName = Utils.OFFER_4),
                new Opportunity(Name = 'Opp C', StageName = Utils.PLANNING_0)
        };

        List<SObject> newRecords = new List<SObject>{
                new Opportunity(Name = 'Opp A', StageName = Utils.AWARDED),        // Changed
                new Opportunity(Name = 'Opp B', StageName = Utils.OFFER_4),    // Unchanged
                new Opportunity(Name = 'Opp C', StageName = Utils.AWARDED)       // Changed
        };

        // Act
        List<SObject> changed = UtilityService.getRecordsWithChangedFieldValue(oldRecords, newRecords, 'StageName', Utils.AWARDED);

        // Assert
        Assert.areEqual(2, changed.size(), 'Should detect two changed records');
    }

    @isTest
    static void testgetRecordsWithChangedFieldValue_nullToValue() {
        // Arrange
        List<SObject> oldRecords = new List<SObject>{
                new Opportunity(Name = 'Opp A', StageName = null),
                new Opportunity(Name = 'Opp B', StageName = Utils.PLANNING_0)
        };

        List<SObject> newRecords = new List<SObject>{
                new Opportunity(Name = 'Opp A', StageName = Utils.AWARDED), // Changed from null
                new Opportunity(Name = 'Opp B', StageName = Utils.PLANNING_0)    // No change
        };

        // Act
        List<SObject> changed = UtilityService.getRecordsWithChangedFieldValue(oldRecords, newRecords, 'StageName', Utils.AWARDED);

        // Assert
        Assert.areEqual(1, changed.size(), 'One change should be detected from null to value');
    }
}