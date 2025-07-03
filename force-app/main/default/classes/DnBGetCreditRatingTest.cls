@IsTest
public with sharing class DnBGetCreditRatingTest {

    @IsTest
    private static void shouldGetCreditSuccessfully() {
        //given
        Account acc = new Account(Name = 'A', Country__c = 'Norway', Org_number__c = '937340303');
        insert acc;
        String creditResponse = '{"risk": { "creditRatings": { "currentCreditRating": { "code": "B" } } } }';

        //when
        Test.setMock(HttpCalloutMock.class, new DnBCallMock(200, creditResponse));
        Test.startTest();
        List<DnBGetCreditRating.FlowResponse> resp = DnBGetCreditRating.getCreditRatingInvocable(new List<String> { acc.Id });
        Test.stopTest();

        //then
        System.assertEquals(true, resp[0].success);
        System.assertEquals('B', resp[0].message);

    }

    @IsTest
    private static void shouldReturnFalseWhenErrorReturned() {
        //given
        Account acc = new Account(Name = 'A', Country__c = 'Norway', Org_number__c = '842852102');
        insert acc;
        String creditResponse = '{"status":500,"statusText":"INTERNAL_SERVER_ERROR","timestamp":"2021-06-18T16:00:06.149503","message":"Unexpected error"}';

        //when
        Test.setMock(HttpCalloutMock.class, new DnBCallMock(500, creditResponse));
        Test.startTest();
        List<DnBGetCreditRating.FlowResponse> resp = DnBGetCreditRating.getCreditRatingInvocable(new List<String> { acc.Id });
        Test.stopTest();

        //then
        System.assertEquals(false, resp[0].success);
        System.assertEquals('Unexpected error', resp[0].message);

    }

    @IsTest
    private static void shouldReturnFalseOnCountryValidationError() {
        //given
        Account acc = new Account(Name = 'A', Org_number__c = '842852102');
        insert acc;

        //when
        Test.startTest();
        List<DnBGetCreditRating.FlowResponse> resp = DnBGetCreditRating.getCreditRatingInvocable(new List<String> { acc.Id });
        Test.stopTest();

        //then
        System.assertEquals(false, resp[0].success);
        System.assertEquals(DnBGetCreditRating.ERR_MSG_UNSUPPORTED_COUNTRY, resp[0].message);
    }

    @IsTest
    private static void shouldReturnFalseOnOrNumValidationError() {
        //given
        Account acc = new Account(Name = 'A', Country__c = 'Finland');
        insert acc;

        //when
        Test.startTest();
        List<DnBGetCreditRating.FlowResponse> resp = DnBGetCreditRating.getCreditRatingInvocable(new List<String> { acc.Id });
        Test.stopTest();

        //then
        System.assertEquals(false, resp[0].success);
        System.assertEquals(DnBGetCreditRating.ERR_MSG_ORN_NUM_REQUIRED, resp[0].message);
    }

    @IsTest
    private static void shouldReturnFalseOnException() {
        //when
        Test.startTest();
        List<DnBGetCreditRating.FlowResponse> resp = DnBGetCreditRating.getCreditRatingInvocable(null);
        Test.stopTest();

        //then
        System.assertEquals(false, resp[0].success);
    }

    public class DnBCallMock implements HttpCalloutMock {

        private Integer code;
        private String responseJSON;

        public DnBCallMock(Integer code, String responseJSON) {
            this.code = code;
            this.responseJSON = responseJSON;
        }

        public HttpResponse respond(HttpRequest req) {
            System.debug('Mock req ' + req.getEndpoint());
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(this.responseJSON);
            res.setStatusCode(this.code);
            return res;
        }
    }
}