public with sharing class DnBAuthProvider extends Auth.AuthProviderPluginClass {
    public static final String RESOURCE_CALLBACK = '/services/authcallback/';
    public static final String DUMMY_CODE = '999';
    public static final String CUSTOM_MDT_NAME = 'DnBAuthConfig__mdt';
    public static final String CMT_FIELD_PROVIDER_NAME = 'Auth_Provider_Name__c';
    public static final String CMT_FIELD_SCOPE = 'OAuth_Scope__c';
    public static final String CMT_FIELD_GRANT_TYPE = 'Grant_Type__c';
    public static final String CMT_FIELD_NAMED_CREDENTIAL = 'Named_Credential__c';

    public String getCustomMetadataType() {
        return CUSTOM_MDT_NAME;
    }

    public PageReference initiate(Map<String, String> config, String stateToPropagate) {
        PageReference pageRef = new PageReference(Url.getSalesforceBaseUrl().toExternalForm() + RESOURCE_CALLBACK + config.get('Auth_Provider_Name__c'));
        pageRef.getParameters().put('state', stateToPropagate);
        pageRef.getParameters().put('code', DUMMY_CODE); // Empirically found this is required, but unused
        return pageRef;
    }

    public Auth.AuthProviderTokenResponse handleCallback(Map<String, String> config, Auth.AuthProviderCallbackState state) {
        TokenResponse response = retrieveToken(config);

        return new Auth.AuthProviderTokenResponse(
            config.get(CMT_FIELD_PROVIDER_NAME),
            response.access_token,
            'refresh',
            state.queryParameters.get('state')
        );
    }

    public override Auth.OAuthRefreshResult refresh(Map<String, String> config, String refreshToken) {
        TokenResponse response = retrieveToken(config);
        return new Auth.OAuthRefreshResult(response.access_token, response.token_type);
    }

    private TokenResponse retrieveToken(Map<String, String> config) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + config.get(CMT_FIELD_NAMED_CREDENTIAL));
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
        req.setMethod('POST');
        req.setBody('grant_type=' + config.get(CMT_FIELD_GRANT_TYPE) + '&scope=' + config.get(CMT_FIELD_SCOPE));
        HttpResponse res = new Http().send(req);
        return (TokenResponse)JSON.deserialize(res.getBody(), TokenResponse.class);
    }

    public Auth.UserData getUserInfo(Map<String, String> config, Auth.AuthProviderTokenResponse response) {
        final Auth.UserData userData = new Auth.UserData(
            config.get(CMT_FIELD_PROVIDER_NAME),
            null,
            null,
            null,
            null,
            null,
            config.get(CMT_FIELD_PROVIDER_NAME),
            null,
            config.get(CMT_FIELD_PROVIDER_NAME),
            config.get(CMT_FIELD_NAMED_CREDENTIAL),
            new Map<String,String>()
        );

        return userData;
    }

    private class TokenResponse {
        public String access_token;
        public String scope;
        public String token_type;
        public Integer expires_in;
    }
}