public with sharing class DnBGetCreditRating {

    public final static String ERR_MSG_UNSUPPORTED_COUNTRY = 'Country is not supported for credit check';
    public final static String ERR_MSG_ORN_NUM_REQUIRED = 'Org Number is required for credit check';

    public static Map<String, String> country2urlSuffix = new Map<String, String> {
        'Norway' => 'no',
        'Sweden' => 'se',
        'Finland' => 'fi',
        'Denmark' => 'dk'
    };

    @InvocableMethod
    public static List<FlowResponse> getCreditRatingInvocable(List<String> recordIds) {
        try {

            Account account = [SELECT Id, Org_number__c, Country__c FROM Account WHERE Id = :recordIds[0]];

            if (!country2urlSuffix.containsKey(account.Country__c)) {
                return new List<FlowResponse> { new FlowResponse(false, ERR_MSG_UNSUPPORTED_COUNTRY) };
            }

            if (String.isBlank(account.Org_number__c)) {
                return new List<FlowResponse> { new FlowResponse(false, ERR_MSG_ORN_NUM_REQUIRED) };
            }

            Response response = getCreditRating(sanitizeOrgNum(account.Org_number__c), country2urlSuffix.get(account.Country__c));
            String message;

//            if (response.success) {
//            message = ((CreditRatingResponse)response.data).risk.creditRatings.currentCreditRating.code  + '  ' + 
//                           ((CreditRatingResponse)response.data).risk.creditRatings.currentCreditRating.annualReportDate.year + '-' +
//                           ((CreditRatingResponse)response.data).risk.creditRatings.currentCreditRating.annualReportDate.month; 
//                           }
            if (response.success) {
                message = ((CreditRatingResponse)response.data).risk.creditRatings.currentCreditRating.code;
            }
            else {
                message = ((ErrorResponse)response.data).message;
            }

            return new List<FlowResponse> { new FlowResponse(response.success, message) };
        }
        catch (Exception ex) {
            return new List<FlowResponse> { new FlowResponse(false, ex.getMessage()) };
        }
    }

    private static String sanitizeOrgNum(String orgNum) {
        return orgNum.replace('-', '');
    }

    public class FlowResponse {
        @InvocableVariable(Label='success' Description='success' Required=true)
        public Boolean success;

        @InvocableVariable(Label='message' Description='message' Required=true)
        public String message;

        public FlowResponse(Boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }

    public static Response getCreditRating(String regNum, String countryUrlSuffix) {

        CreditRatingRequest request = new CreditRatingRequest(regNum);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DnBCallouts/credit-data-companies/v2/companies/' + countryUrlSuffix);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setBody(JSON.serialize(request));
        HttpResponse res = new Http().send(req);

        System.debug(res.getBody());

        if (res.getStatusCode() == 200) {
            CreditRatingResponse data = (CreditRatingResponse)JSON.deserialize(res.getBody(), CreditRatingResponse.class);
            return new Response(true, data);
        }
        else {
            ErrorResponse data = (ErrorResponse)JSON.deserialize(res.getBody(), ErrorResponse.class);
            return new Response(false, data);
        }
    }

    public class CreditRatingRequest {
        public String registrationNumber;
        public String language;
        public List<Segment> segments;

        public CreditRatingRequest(String regNum) {
            this.registrationNumber = regNum;
            this.language = 'EN';
            this.segments = new List<Segment> {
                Segment.RISK,
                Segment.FINANCE
            };
        }
    }

    public enum Segment { RISK, FINANCE, MANAGEMENT, OWNERSHIP, EVENTS }

    public class Response {
        public Boolean success;
        public Object data;

        public Response(Boolean success, Object data) {
            this.success = success;
            this.data = data;
        }
    }

    public class CreditRatingResponse {
        Risk risk;
    }

    public class Risk {
        CreditRatings creditRatings;
    }

    public class CreditRatings {
        CurrentCreditRating currentCreditRating;
    }

    public class CurrentCreditRating {
        AnnualReportDate annualReportDate;
        public String code; //AAA, AA, A, B, C, AN, -
        public String description;
    }
    
    public class AnnualReportDate {
        public String year;
        public String month;
    }

    public class ErrorResponse {
        public Integer status;
        public String statusText;
        public String timestamp;
        public String message;
        public List<SubError> subErrors;
    }

    public class SubError {
        public String size;
        public String rejectedValue;
        public String message;
    }
}