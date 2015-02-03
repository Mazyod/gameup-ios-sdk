/*
 Copyright 2014-2015 GameUp

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <AFNetworking/AFNetworking.h>
#import <Base64.h>
#import "GUGameUp.h"
#import "GUAchievement.h"
#import "GUAchievementUpdate.h"
#import "GULeaderboard.h"
#import "GULeaderboardRank.h"
#import "GULeaderboardUpdate.h"
#import "GUJSONSerialisableProtocol.h"
#import "GUResponderProtocol.h"
#import "GURequestRetryHandlerProtocol.h"
#import "GUDefaultRequestRetryHandler.h"

typedef NS_ENUM(NSInteger, GURequest)
{
    PING,
    SERVER,
    GAME,
    GAMER,
    STORAGE_PUT,
    STORAGE_GET,
    STORAGE_DELETE,
    ACHIEVEMENTS_GAME,
    ACHIEVEMENTS_GAMER,
    ACHIEVEMENT_POST,
    LEADERBOARD_GAME,
    LEADERBOARD_GAMER,
    LEADERBOARD_POST,
    LOGIN
};

static NSString *const GAMEUP_VERSION=@"0.5.0";
static NSString *const AFN_VERSION=@"AFN2.5.0";

static NSString *const USER_AGENT_NAME=@"gameup-ios-sdk";
static NSString *const GAMEUP_LOGIN_URL = @"https://accounts.gameup.io";
static NSString *const GAMEUP_API_URL = @"https://api.gameup.io";

static NSString *USER_AGENT;
static NSInteger REQUEST_TIMEOUT=30; //seconds

@implementation GUGameUp
{
    id<GUResponderProtocol> responseDelegate;
    id<GURequestRetryHandlerProtocol> retryHandler;
    NSDictionary *requestUrls;
    AFHTTPRequestOperationManager *networkManager;
    NSString* apiKey;
}

- (id) initWithApiKey:(id)apikeyToUse withResponder:(id<GUResponderProtocol>)responder
{
    GUDefaultRequestRetryHandler *handler = [[GUDefaultRequestRetryHandler alloc] initWithDefaultRetryAttempts];
    return [self initWithApiKey:apikeyToUse withResponder:responder withRetryHandler:handler];
}

- (id) initWithApiKey:(id)apikeyToUse withResponder:(id<GUResponderProtocol>)responder withRetryHandler:(id<GURequestRetryHandlerProtocol>)handler
{
    self = [super init];
    if (self) {
        apiKey = apikeyToUse;
        responseDelegate = responder;
        retryHandler = handler;

        requestUrls = @{
            @(PING) : @"/v0/",
            @(SERVER) : @"/v0/server/",
            @(GAME) : @"/v0/game/",
            @(GAMER) : @"/v0/gamer/",
            @(STORAGE_PUT) : @"/v0/gamer/storage/",
            @(STORAGE_GET) : @"/v0/gamer/storage/",
            @(STORAGE_DELETE) : @"/v0/gamer/storage/",
            @(ACHIEVEMENTS_GAME) : @"/v0/game/achievement/",
            @(ACHIEVEMENTS_GAMER) : @"/v0/game/achievement/",
            @(ACHIEVEMENT_POST) : @"/v0/gamer/achievement/",
            @(LEADERBOARD_GAME) : @"/v0/game/leaderboard/",
            @(LEADERBOARD_GAMER) : @"/v0/gamer/leaderboard/",
            @(LEADERBOARD_POST) : @"/v0/gamer/leaderboard/",
            @(LOGIN) : @"/v0/gamer/login/"
        };
        
        USER_AGENT = [[NSString alloc] initWithString:[self setupUserAgent]];
        networkManager = [self setupNetworkManager];
    }
    return self;
}

- (AFHTTPRequestOperationManager*) setupNetworkManager
{
    NSURL *baseURL = [NSURL URLWithString:GAMEUP_API_URL];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    return manager;
}

- (NSString*) setupUserAgent
{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSMutableString *USER_AGENT_MUTABLE = [[NSMutableString alloc] initWithString:USER_AGENT_NAME];
    [USER_AGENT_MUTABLE appendString:@"/"];
    [USER_AGENT_MUTABLE appendString:GAMEUP_VERSION];
    [USER_AGENT_MUTABLE appendString:@" ("];
    [USER_AGENT_MUTABLE appendString:[[UIDevice currentDevice] systemName]];
    [USER_AGENT_MUTABLE appendString:@" "];
    [USER_AGENT_MUTABLE appendString:[[UIDevice currentDevice] systemVersion]];
    [USER_AGENT_MUTABLE appendString:@"; "];
    [USER_AGENT_MUTABLE appendString:AFN_VERSION];
    [USER_AGENT_MUTABLE appendString:@"; "];
    [USER_AGENT_MUTABLE appendString:secretAgent];
    [USER_AGENT_MUTABLE appendString:@")"];
    
    return USER_AGENT_MUTABLE;
}

- (void)ping
{
    [self pingWithToken:@""];
}

- (void)pingWithToken:(NSString*)token
{
    [self sendApiRequest:PING
  withAppendedUrlPath:@""
           withMethod:@"HEAD"
            withToken:token
           withEntity:@""];
}

- (void)requestServerInfo
{
    [self sendApiRequest:SERVER
  withAppendedUrlPath:@""
           withMethod:@"GET"
            withToken:@""
           withEntity:@""];
}

- (void)requestToGetGameDetails
{
    [self sendApiRequest:GAME
  withAppendedUrlPath:@""
           withMethod:@"GET"
            withToken:@""
           withEntity:@""];
}

- (void)requestToGetGamerProfile:(NSString*)token
{
    [self sendApiRequest:GAMER
  withAppendedUrlPath:@""
           withMethod:@"GET"
            withToken:token
           withEntity:@""];
}

- (void)requestToGetStoredData:(id)token storedWithKey:(NSString*)storageKey
{
    [self sendApiRequest:STORAGE_GET
  withAppendedUrlPath:storageKey
           withMethod:@"GET"
            withToken:token
           withEntity:@""];
}

- (void)requestToStoreData:(id)token storeWithKey:(NSString*)storageKey withValue:(NSDictionary*)value
{
    [self sendApiRequest:STORAGE_PUT
  withAppendedUrlPath:storageKey
           withMethod:@"PUT"
            withToken:token
           withEntity:value];
}

- (void)requestToDeleteStoredData:(id)token storedWithKey:(NSString*)storageKey
{
    [self sendApiRequest:STORAGE_DELETE
  withAppendedUrlPath:storageKey
           withMethod:@"DELETE"
            withToken:token
           withEntity:@""];
}

-(void)requestToGetAllAchievements
{
    [self sendApiRequest:ACHIEVEMENTS_GAME
  withAppendedUrlPath:@""
           withMethod:@"GET"
            withToken:@""
           withEntity:@""];
}

-(void)requestToGetAllAchievements:(id)token
{
    [self sendApiRequest:ACHIEVEMENTS_GAMER
  withAppendedUrlPath:@""
           withMethod:@"GET"
            withToken:token
           withEntity:@""];
}

-(void)requestToUpdateAchievement:(id)token
            withAchievementUpdate:(GUAchievementUpdate*)achievementUpdate
{
    [self sendApiRequest:ACHIEVEMENT_POST
  withAppendedUrlPath:[achievementUpdate achievementId]
           withMethod:@"POST"
            withToken:token
           withEntity:[achievementUpdate toDictionary]];
}

-(void)requestToGetLeaderboardData:(id)leaderboardId
{
    [self sendApiRequest:LEADERBOARD_GAME
  withAppendedUrlPath:leaderboardId
           withMethod:@"GET"
            withToken:@""
           withEntity:@""];
}
-(void)requestToGetLeaderboardDataAndRank:(id)token withLeaderboardId:(id)leaderboardId
{
    [self sendApiRequest:LEADERBOARD_GAMER
  withAppendedUrlPath:leaderboardId
           withMethod:@"GET"
            withToken:token
           withEntity:@""];
}
-(void)requestToUpdateLeaderboardRank:(id)token withLeaderboardUpdate:(GULeaderboardUpdate*)leaderboardUpdate
{
    [self sendApiRequest:LEADERBOARD_POST
  withAppendedUrlPath:[leaderboardUpdate leaderboardId]
           withMethod:@"POST"
            withToken:token
           withEntity:[leaderboardUpdate toDictionary]];
}

-(UIViewController*)loginThroughBrowserToTwitter
{
    return [self loginThroughBrowserToTwitterAndLinkExistingToken:@""];
}
-(UIViewController*)loginThroughBrowserToTwitterAndLinkExistingToken:(NSString*)gamerToken
{
    return [self loginThroughBrowserTo:@"twitter" andLinkExistingToken:gamerToken];
}
-(UIViewController*)loginThroughBrowserToGoogle
{
    return [self loginThroughBrowserToGoogleAndLinkExistingToken:@""];
}
-(UIViewController*)loginThroughBrowserToGoogleAndLinkExistingToken:(NSString*)gamerToken
{
    return [self loginThroughBrowserTo:@"google" andLinkExistingToken:gamerToken];
}
-(UIViewController*)loginThroughBrowserToFacebook
{
    return [self loginThroughBrowserToFacebookAndLinkExistingToken:@""];
}
-(UIViewController*)loginThroughBrowserToFacebookAndLinkExistingToken:(NSString*)gamerToken
{
    return [self loginThroughBrowserTo:@"facebook" andLinkExistingToken:gamerToken];
}
-(UIViewController*)loginThroughBrowserToGameUp
{
    return [self loginThroughBrowserToGameUpAndLinkExistingToken:@""];
}
-(UIViewController*)loginThroughBrowserToGameUpAndLinkExistingToken:(NSString*)gamerToken
{
    return [self loginThroughBrowserTo:@"gameup" andLinkExistingToken:gamerToken];
}

-(UIViewController*)loginThroughBrowserTo:(NSString*)loginProvider andLinkExistingToken:(NSString*)gamerToken
{
    NSMutableString *loginUrlPath = [[NSMutableString alloc] initWithString:GAMEUP_LOGIN_URL];
    [loginUrlPath appendString:[requestUrls objectForKey:@(LOGIN)]];
    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"GULoginStoryboard" bundle: nil];
    
    GULoginViewController *controller = (GULoginViewController *)[loginStoryboard instantiateViewControllerWithIdentifier:@"GULoginViewController"];
    [controller initWithResponder:responseDelegate
               withLoginServerUrl:loginUrlPath
                     withProvider:loginProvider
                       withApiKey:apiKey
                   withGamerToken:gamerToken
                    withUserAgent:USER_AGENT];
    return controller;
}

-(void)loginAnonymouslyWith:(NSString*)deviceId
{
    NSDictionary* entity = @{@"id" : deviceId};
    [self sendRequest:GAMEUP_LOGIN_URL
         withEndpoint:LOGIN
  withAppendedUrlPath:@"anonymous"
           withMethod:@"POST"
            withToken:@""
           withEntity:entity];
}
-(void)loginThroughFacebookWith:(NSString*)accessToken
{
    [self sendLoginRequest:@"facebook" withAccessToken:accessToken withToken:@""];
}
-(void)loginThroughFacebookWith:(NSString*)accessToken andLinkExistingToken:(NSString*)gamerToken
{
    [self sendLoginRequest:@"facebook" withAccessToken:accessToken withToken:gamerToken];
}
-(void)loginThroughGoogleWith:(NSString*)accessToken
{
    [self sendLoginRequest:@"google" withAccessToken:accessToken withToken:@""];
}
-(void)loginThroughGoogleWith:(NSString*)accessToken andLinkExistingToken:(NSString*)gamerToken
{
    [self sendLoginRequest:@"google" withAccessToken:accessToken withToken:gamerToken];
}
- (void)sendLoginRequest:(NSString*)provider
         withAccessToken:(NSString*)accessToken
               withToken:(NSString*)token
{
    NSDictionary* entity = @{@"type" : provider, @"access_token": accessToken};
    
    [self sendRequest:GAMEUP_LOGIN_URL
         withEndpoint:LOGIN
  withAppendedUrlPath:@"oauth2"
           withMethod:@"POST"
            withToken:token
           withEntity:entity];
}
- (void)sendApiRequest:(enum GURequest)endpoint
withAppendedUrlPath:(NSString*)appendedUrlPath
         withMethod:(NSString*)method
          withToken:(NSString*)token
         withEntity:(id)entity
{
    [self sendRequest:GAMEUP_API_URL
         withEndpoint:endpoint
  withAppendedUrlPath:appendedUrlPath
           withMethod:method
            withToken:token
           withEntity:entity];
}
- (void)sendRequest:(NSString*)to
       withEndpoint:(enum GURequest)endpoint
withAppendedUrlPath:(NSString*)appendedUrlPath
         withMethod:(NSString*)method
          withToken:(NSString*)token
         withEntity:(id)entity
{
    
    NSMutableString *stringUrl = [[NSMutableString alloc] initWithString:to];
    [stringUrl appendString:[requestUrls objectForKey:@(endpoint)]];
    [stringUrl appendString:appendedUrlPath];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:stringUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:REQUEST_TIMEOUT];
    
    NSMutableString *authorization = [[NSMutableString alloc] initWithString:apiKey];
    [authorization appendString:@":"];
    [authorization appendString:token];
    
    NSMutableString *base64EncodedAuth = [[NSMutableString alloc] initWithString:@"Basic "];
    [base64EncodedAuth appendString:[authorization base64EncodedString]];
    
    [request setHTTPMethod:method];
    [request setValue:base64EncodedAuth forHTTPHeaderField:@"Authorization"];
    [request setValue:USER_AGENT forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if ([method isEqualToString:@"PUT"] || [method isEqualToString:@"POST"]) {
        [request setHTTPBody:[self serialiseDictionaryToData:entity]];
    }
    
    [self sendRequest:request withEndpoint:endpoint withAppendedUrlPath:appendedUrlPath withEntity:entity];
}
- (void)sendRequest:(NSURLRequest*)request
       withEndpoint:(enum GURequest)endpoint
withAppendedUrlPath:(NSString*)appendedUrlPath
         withEntity:(id)entity
{
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        [retryHandler requestSucceed:request];
        [self listenerCallback:endpoint withStatusCode:200 withAppendedUrlPath:appendedUrlPath withRequestEntity:entity withResponseEntity:JSON];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = [operation response];
        
        if ([response statusCode] >= 500) {
            [retryHandler requestFailed:request];
            if ([retryHandler shouldRetryRequest:request]) {
                [self sendRequest:request withEndpoint:endpoint withAppendedUrlPath:appendedUrlPath withEntity:entity];
            } else {
                [self listenerCallback:endpoint withStatusCode:[response statusCode] withAppendedUrlPath:appendedUrlPath withRequestEntity:entity withResponseEntity:error];
            }
        } else {
            [retryHandler requestSucceed:request];
            [self listenerCallback:endpoint withStatusCode:[response statusCode] withAppendedUrlPath:appendedUrlPath withRequestEntity:entity withResponseEntity:error];
        }
    }];
    [networkManager.operationQueue addOperation:op];
}

- (void)listenerCallback:(enum GURequest)requestKey
          withStatusCode:(NSInteger)statusCode
     withAppendedUrlPath:(id)urlPath
        withRequestEntity:(id)requestEntity
       withResponseEntity:(id)responseEntity
{
    switch (requestKey) {
        case LOGIN:
            if (statusCode == 200) { [responseDelegate successfullyLoggedinWithGamerToken:[responseEntity objectForKey:@"token"]]; }
            else { [responseDelegate failedToLoginWithError:responseEntity]; }
            break;
        case PING:
            if (statusCode == 200) { [responseDelegate successfulPing]; }
            else { [responseDelegate failedPing:statusCode withError:responseEntity]; }
            break;
        case SERVER:
            if (statusCode == 200) { [responseDelegate retrievedServerData:[[GUServer alloc] initWithDictionary:responseEntity]]; }
            else { [responseDelegate failedToRetrieveServerData:statusCode withError:responseEntity]; }
            break;
        case GAME:
            if (statusCode == 200) { [responseDelegate retrievedGameData:[[GUGame alloc] initWithDictionary:responseEntity]]; }
            else { [responseDelegate failedToRetrieveGameData:statusCode withError:responseEntity]; }
            break;
        case GAMER:
            if (statusCode == 200) { [responseDelegate retrievedGamerProfile:[[GUGamer alloc] initWithDictionary:responseEntity]];}
            else { [responseDelegate failedToRetrieveGamerProfile:statusCode withError:responseEntity]; }
            break;
        case STORAGE_GET:
            if (statusCode == 200) { [responseDelegate retrievedStoredData:urlPath withData:[self parseStorageDataToDictionary:responseEntity]]; }
            else { [responseDelegate failedToRetrieveStoredData:statusCode withError:responseEntity withStorageKey:urlPath]; }
            break;
        case STORAGE_PUT:
            if (statusCode == 200) { [responseDelegate successfullyStoredData:urlPath]; }
            else { [responseDelegate failedToStoreData:statusCode withError:responseEntity withStorageKey:urlPath withData:requestEntity ]; }
            break;
        case STORAGE_DELETE:
            if (statusCode == 200) { [responseDelegate successfullyDeletedData:urlPath]; }
            else { [responseDelegate failedToDeleteStoredData:statusCode withError:responseEntity withStorageKey:urlPath]; }
            break;
        case ACHIEVEMENTS_GAME:
            if (statusCode == 200) { [responseDelegate retrievedGameAchievements:[self convertDictionaryToAchievementArray:responseEntity]]; }
            else { [responseDelegate failedToRetrieveGameAchievements:statusCode withError:responseEntity]; }
            break;
        case ACHIEVEMENTS_GAMER:
            if (statusCode == 200) { [responseDelegate retrievedGamerAchievements:[self convertDictionaryToAchievementArray:responseEntity]]; }
            else { [responseDelegate failedToRetrieveGamerAchievements:statusCode withError:responseEntity]; }
            break;
        case ACHIEVEMENT_POST:
            if (statusCode == 200 || statusCode == 204) { [responseDelegate successfullyUpdatedAchievement:urlPath]; }
            else { [responseDelegate failedToUpdateAchievement:statusCode withError:responseEntity withAchievementUid:urlPath]; }
            break;
        case LEADERBOARD_GAME:
            if (statusCode == 200) { [responseDelegate retrievedLeaderboardData:[[GULeaderboard alloc] initWithDictionary:responseEntity]]; }
            else { [responseDelegate failedToRetrieveLeaderboardData:statusCode withError:responseEntity]; }
            break;
        case LEADERBOARD_GAMER:
            if (statusCode == 200) {
                GULeaderboard* leaderboard = [[GULeaderboard alloc] initWithDictionary:[responseEntity objectForKey:@"leaderboard"]];
                GULeaderboardRank* rank = [[GULeaderboardRank alloc] initWithDictionary:[responseEntity objectForKey:@"rank"]];
                [responseDelegate retrievedLeaderboardData:leaderboard andRank:rank];
            } else { [responseDelegate failedToRetrieveLeaderboardDataAndRank:statusCode withError:responseEntity]; }
            break;
        case LEADERBOARD_POST:
            if (statusCode == 200 || statusCode == 204) { [responseDelegate successfullyUpdatedLeaderboardRank:urlPath]; }
            else { [responseDelegate failedToUpdateLeaderboardRank:statusCode withError:responseEntity withLeaderboardUid:urlPath]; }
            break;
        default:
            break;
    }
}

- (NSData*)serialiseDictionaryToData:(NSDictionary*)dict
{
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    return json;
}

- (NSDictionary*)parseStorageDataToDictionary:(NSDictionary*)dict
{
    NSString* jsonString = [dict objectForKey:@"value"];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (NSArray*)convertDictionaryToAchievementArray:(NSDictionary*)dict {
    NSMutableArray* result = [[NSMutableArray alloc] init];

    NSArray* achievements = [dict objectForKey:@"achievements"];
    for (id jsonAchievement in achievements) {
        GUAchievement* achievement = [[GUAchievement alloc] initWithDictionary:jsonAchievement];
        [result addObject:achievement];
    }
    
    return [[NSArray alloc] initWithArray:result];
}

@end
