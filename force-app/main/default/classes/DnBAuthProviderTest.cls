@IsTest
public with sharing class DnBAuthProviderTest {

    @IsTest
    private static void shouldInitiate() {
        //given
        DnBAuthProvider provider = new DnBAuthProvider();
        Map<String,String> config = setupAuthProviderConfig();

        //then
        Test.startTest();
        System.assertEquals(DnBAuthProvider.CUSTOM_MDT_NAME, provider.getCustomMetadataType());
        System.assert(provider.initiate(config, '').getUrl().contains(DnBAuthProvider.RESOURCE_CALLBACK));
        Test.stopTest();
    }

    @IsTest
    private static void shouldRunCallbackAndReturnToken() {
        //given
        DnBAuthProvider provider = new DnBAuthProvider();
        Map<String,String> config = setupAuthProviderConfig();
        Map<String,String> queryParams = new Map<String,String> {
            'code' => 'code',
            'state' => 'state'
        };
        Auth.AuthProviderCallbackState cbState = new Auth.AuthProviderCallbackState(null,null,queryParams);


        //when
        Test.setMock(HttpCalloutMock.class, new DnBAuthMock());
        Test.startTest();
        Auth.AuthProviderTokenResponse tokenResponse = provider.handleCallback(config, cbState);
        Test.stopTest();

        //then
        System.assertEquals('dummy-token-response', tokenResponse.oauthToken);
    }

    @IsTest
    private static void shouldRunRefreshAndReturnToken() {
        //given
        DnBAuthProvider provider = new DnBAuthProvider();
        Map<String,String> config = setupAuthProviderConfig();

        //when
        Test.setMock(HttpCalloutMock.class, new DnBAuthMock());
        Test.startTest();
        Auth.OAuthRefreshResult tokenResponse = provider.refresh(config, '');
        Test.stopTest();

        //then
        System.assertEquals('dummy-token-response', tokenResponse.accessToken);
    }

    @IsTest
    private static void shouldGetUserInfo() {
        //given
        DnBAuthProvider provider = new DnBAuthProvider();
        Map<String,String> config = setupAuthProviderConfig();
        Auth.AuthProviderTokenResponse response = new Auth.AuthProviderTokenResponse('provider', 'token' ,'sampleOauthSecret', 'state');

        //when
        Test.startTest();
        Auth.UserData userInfo = provider.getUserInfo(config, response) ;
        Test.stopTest();

        //then
        System.assertEquals(config.get(DnBAuthProvider.CMT_FIELD_PROVIDER_NAME), userInfo.provider);
    }

    private static Map<String,String> setupAuthProviderConfig() {
        Map<String,String> authProviderConfiguration = new Map<String,String>();
        authProviderConfiguration.put(DnBAuthProvider.CMT_FIELD_PROVIDER_NAME, 'DnBAuthProvider');
        authProviderConfiguration.put(DnBAuthProvider.CMT_FIELD_NAMED_CREDENTIAL, 'DnBCredentials');
        authProviderConfiguration.put(DnBAuthProvider.CMT_FIELD_GRANT_TYPE, 'client_credentials');
        authProviderConfiguration.put(DnBAuthProvider.CMT_FIELD_SCOPE, 'credit_data_companies');
        return authProviderConfiguration;
    }

    public class DnBAuthMock implements HttpCalloutMock {
        String tokenResponse = '{\n' +
            '    "access_token": "dummy-token-response",\n' +
            '    "scope": "credit_data_companies",\n' +
            '    "token_type": "Bearer",\n' +
            '    "expires_in": 3600\n' +
        '}';

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(tokenResponse);
            res.setStatusCode(200);
            return res;
        }
    }
}