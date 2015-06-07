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

#import "GUHttpClient.h"
#import "GUSession.h"
#import "GUAchievement.h"
#import "GULeaderboard.h"
#import "GULeaderboardRank.h"
#import "GUMatch.h"
#import "GUMatchTurn.h"
#import "GUResponderProtocol.h"
#import "GURequestRetryHandlerProtocol.h"

static NSString *const GAMEUP_VERSION=@"0.7.0";
static NSString *const AFN_VERSION=@"AFN2.5.0";

static NSString *const USER_AGENT_NAME=@"gameup-ios-sdk";

static NSString *USER_AGENT = nil;
static NSInteger REQUEST_TIMEOUT=30; //seconds

static NSDictionary *REQUEST_URLS = nil;
static AFHTTPRequestOperationManager *NETWORK_MANAGER = nil;

@implementation GUHttpClient

+ (void)initialize
{
    REQUEST_URLS = @{
                     @(PING) : @"/v0/",
                     @(SERVER) : @"/v0/server/",
                     @(GAME) : @"/v0/game/",
                     @(GAMER) : @"/v0/gamer/",
                     @(STORAGE_PUT) : @"/v0/gamer/storage/:key",
                     @(STORAGE_GET) : @"/v0/gamer/storage/:key",
                     @(STORAGE_DELETE) : @"/v0/gamer/storage/:key",
                     @(ACHIEVEMENTS_GAME) : @"/v0/game/achievement/",
                     @(ACHIEVEMENTS_GAMER) : @"/v0/game/achievement/",
                     @(ACHIEVEMENT_POST) : @"/v0/gamer/achievement/:id",
                     @(LEADERBOARD_GAME) : @"/v0/game/leaderboard/:id",
                     @(LEADERBOARD_GAMER) : @"/v0/gamer/leaderboard/:id",
                     @(LEADERBOARD_POST) : @"/v0/gamer/leaderboard/:id",
                     @(MATCH_GET_ALL) : @"/v0/gamer/match/",
                     @(MATCH_GET) : @"/v0/gamer/match/:id",
                     @(MATCH_TURN_GET): @"/v0/gamer/match/:id/turn/:turn_id",
                     @(MATCH_TURN_POST): @"/v0/gamer/match/:id/turn",
                     @(MATCH_POST): @"/v0/gamer/match/",
                     @(MATCH_POST_ACTION): @"/v0/gamer/match/:id",
                     @(LOGIN) : @"/v0/gamer/login/:type",
                     @(PUSH_SUBSCRIBE) : @"/v0/gamer/push/"
                    };
    
    USER_AGENT = [[NSString alloc] initWithString:[GUHttpClient setupUserAgent]];
}

+ (NSString*) setupUserAgent
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

+ (id) USER_AGENT
{
    return USER_AGENT;
}

+ (id) REQUEST_URLS
{
    return REQUEST_URLS;
}

+ (void) initNetworkManager
{
    if (NETWORK_MANAGER == nil)
    {
        NSURL *baseURL = [NSURL URLWithString:GAMEUP_API_URL];
        NETWORK_MANAGER = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    }
}

+ (void)sendLoginRequest:(NSString*)provider
              withApiKey:(NSString*)apikeyToUse
         withAccessToken:(NSString*)accessToken
               withToken:(NSString*)token
           withResponder:(id<GUResponderProtocol>)responder
        withRetryHandler:(id<GURequestRetryHandlerProtocol>)handler;

{
    NSDictionary* entity = @{@"type" : provider, @"access_token": accessToken};
    
    [GUHttpClient sendRequest:GAMEUP_LOGIN_URL
                 withEndpoint:LOGIN
                withUrlParams:@{@":type": @"oauth2"}
                   withMethod:@"POST"
                   withApiKey:apikeyToUse
                    withToken:token
                   withEntity:entity
                withResponder:responder
             withRetryHandler:handler];
}

+ (void)sendRequest:(NSString*)to
       withEndpoint:(enum GURequestType)endpoint
      withUrlParams:(NSDictionary*)urlParams
         withMethod:(NSString*)method
         withApiKey:(NSString*)apiKey
          withToken:(NSString*)token
         withEntity:(id)entity
      withResponder:(id<GUResponderProtocol>)responder
   withRetryHandler:(id<GURequestRetryHandlerProtocol>)handler
{
    
    NSMutableString *stringUrl = [[NSMutableString alloc] initWithString:to];
    [stringUrl appendString:[REQUEST_URLS objectForKey:@(endpoint)]];
    
    NSString* finalUrl = stringUrl;
    for (id key in urlParams) {
        id param = [urlParams objectForKey:key];
        finalUrl = [finalUrl stringByReplacingOccurrencesOfString:key withString:param];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:finalUrl]
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
        [request setHTTPBody:[GUHttpClient serialiseDictionaryToData:entity]];
    }
    
    [GUHttpClient sendRequest:request
                 withEndpoint:endpoint
                withUrlParams:urlParams
                   withApiKey:apiKey
                   withEntity:entity
                withResponder:responder
             withRetryHandler:handler];
}

+ (void)sendRequest:(NSURLRequest*)request
       withEndpoint:(enum GURequestType)endpoint
      withUrlParams:(NSDictionary*)urlParams
         withApiKey:(id)apikey
         withEntity:(id)entity
      withResponder:(id<GUResponderProtocol>)responder
   withRetryHandler:(id<GURequestRetryHandlerProtocol>)retryHandler
{
    [GUHttpClient initNetworkManager];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        [retryHandler requestSucceed:request];
        [GUHttpClient listenerCallback:endpoint
                        withStatusCode:[[operation response] statusCode]
                         withUrlParams:urlParams
                            withApiKey:apikey
                     withRequestEntity:entity
                    withResponseEntity:JSON
                         withResponder:responder
                      withRetryHandler:retryHandler];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = [operation response];
        
        if ([response statusCode] >= 500) {
            [retryHandler requestFailed:request];
            if ([retryHandler shouldRetryRequest:request]) {
                [GUHttpClient sendRequest:request
                             withEndpoint:endpoint
                            withUrlParams:urlParams
                               withApiKey:apikey
                               withEntity:entity
                            withResponder:responder
                 withRetryHandler:retryHandler];
            } else {
                [self listenerCallback:endpoint
                        withStatusCode:[response statusCode]
                         withUrlParams:urlParams
                            withApiKey:apikey
                     withRequestEntity:entity
                    withResponseEntity:error
                         withResponder:responder
                      withRetryHandler:retryHandler];
            }
        } else {
            [retryHandler requestSucceed:request];
            [self listenerCallback:endpoint
                    withStatusCode:[response statusCode]
                     withUrlParams:urlParams
                        withApiKey:apikey
                 withRequestEntity:entity
                withResponseEntity:error
                     withResponder:responder
                  withRetryHandler:retryHandler];
        }
    }];
    [NETWORK_MANAGER.operationQueue addOperation:op];
}

+ (void)listenerCallback:(enum GURequestType)requestKey
          withStatusCode:(NSInteger)statusCode
     withUrlParams:(NSDictionary*)urlParams
              withApiKey:(id)apikey
       withRequestEntity:(id)requestEntity
      withResponseEntity:(id)responseEntity
           withResponder:(id<GUResponderProtocol>)responseDelegate
        withRetryHandler:(id<GURequestRetryHandlerProtocol>)retryHandler
{
    switch (requestKey) {
        case LOGIN:
            if (statusCode == 200) {
                id token = [responseEntity objectForKey:@"token"];
                GUSession* session = [[GUSession alloc] initWithApiKey:apikey
                                                             withToken:token
                                                         withResponder:responseDelegate
                                                      withRetryHandler:retryHandler];
                [responseDelegate successfullyLoggedinWithSession:session];
            }
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
            if (statusCode == 200) { [responseDelegate retrievedStoredData:[urlParams objectForKey:@":key"] withData:[GUHttpClient parseStorageDataToDictionary:responseEntity]]; }
            else { [responseDelegate failedToRetrieveStoredData:statusCode withError:responseEntity withStorageKey:[urlParams objectForKey:@":key"]]; }
            break;
        case STORAGE_PUT:
            if (statusCode == 200) { [responseDelegate successfullyStoredData:[urlParams objectForKey:@":key"]]; }
            else { [responseDelegate failedToStoreData:statusCode withError:responseEntity withStorageKey:[urlParams objectForKey:@":key"] withData:requestEntity ]; }
            break;
        case STORAGE_DELETE:
            if (statusCode == 200) { [responseDelegate successfullyDeletedData:[urlParams objectForKey:@":key"]]; }
            else { [responseDelegate failedToDeleteStoredData:statusCode withError:responseEntity withStorageKey:[urlParams objectForKey:@":key"]]; }
            break;
        case ACHIEVEMENTS_GAME:
            if (statusCode == 200) { [responseDelegate retrievedGameAchievements:[GUHttpClient convertDictionaryToAchievementArray:responseEntity]]; }
            else { [responseDelegate failedToRetrieveGameAchievements:statusCode withError:responseEntity]; }
            break;
        case ACHIEVEMENTS_GAMER:
            if (statusCode == 200) { [responseDelegate retrievedGamerAchievements:[GUHttpClient convertDictionaryToAchievementArray:responseEntity]]; }
            else { [responseDelegate failedToRetrieveGamerAchievements:statusCode withError:responseEntity]; }
            break;
        case ACHIEVEMENT_POST:
            if (statusCode == 200 || statusCode == 204) { [responseDelegate successfullyUpdatedAchievement:[urlParams objectForKey:@":id"]]; }
            else { [responseDelegate failedToUpdateAchievement:statusCode withError:responseEntity withAchievementUid:[urlParams objectForKey:@":id"]]; }
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
            if (statusCode == 200 || statusCode == 204) { [responseDelegate successfullyUpdatedLeaderboardRank:[urlParams objectForKey:@":id"]]; }
            else { [responseDelegate failedToUpdateLeaderboardRank:statusCode withError:responseEntity withLeaderboardUid:[urlParams objectForKey:@":id"]]; }
            break;
        case MATCH_GET_ALL:
            if (statusCode == 200) { [responseDelegate retrievedMatches:[GUHttpClient getMatches:responseEntity]]; }
            else { [responseDelegate failedToRetrieveMatches:statusCode withError:responseEntity];}
            break;
        case MATCH_GET:
            if (statusCode == 200) { [responseDelegate retrievedMatch:[[GUMatch alloc] initWithDictionary:responseEntity] withMatchId:[urlParams objectForKey:@":id"]]; }
            else { [responseDelegate failedToRetrieveMatch:[urlParams objectForKey:@":id"] withStatusCode:statusCode withError:responseEntity]; }
            break;
        case MATCH_TURN_GET:
            if (statusCode == 200) { [responseDelegate retrievedTurn:[GUHttpClient getMatchTurns:responseEntity] forMatch:[urlParams objectForKey:@":id"]]; }
            else { [responseDelegate failedToRetrieveTurnData:statusCode withError:responseEntity forMatch:[urlParams objectForKey:@":id"]]; }
            break;
        case MATCH_TURN_POST:
            if (statusCode == 204) { [responseDelegate successfullySubmittedTurnDataForMatch:[urlParams objectForKey:@":id"]];}
            else { [responseDelegate failedToSubmitTurn:statusCode withError:responseEntity ForMatch:[urlParams objectForKey:@":id"] withData:requestEntity]; }
            break;
        case MATCH_POST:
            if (statusCode == 204) { [responseDelegate successfullyQueuedGamerForNewMatch]; }
            else if (statusCode == 200) { [responseDelegate createdNewMatch:[[GUMatch alloc] initWithDictionary:responseEntity]]; }
            else { [responseDelegate failedToCreateMatch:statusCode withError:responseEntity]; }
            break;
        case MATCH_POST_ACTION:
            if ([[requestEntity objectForKey:@"action"] isEqualToString:@"end"]) {
                if (statusCode == 204) { [responseDelegate SuccessfullyEndedMatch:[urlParams objectForKey:@":id"]]; }
                else { [responseDelegate failedToEndMatch:statusCode withError:responseEntity forMatchId:[urlParams objectForKey:@":id"]]; }
            } else if ([[requestEntity objectForKey:@"action"] isEqualToString:@"leave"]) {
                if (statusCode == 204) { [responseDelegate SuccessfullyLeftMatch:[urlParams objectForKey:@":id"]]; }
                else { [responseDelegate failedToLeaveMatch:statusCode withError:responseEntity forMatchId:[urlParams objectForKey:@":id"]]; }
            }
            break;
        case PUSH_SUBSCRIBE:
            if (statusCode == 204) { [responseDelegate successfullySubscribed]; }
            else { [responseDelegate failedToRegisterForPush:responseEntity]; }
            break;
        default:
            break;
    }
}

+ (NSArray*)getMatchTurns:(NSDictionary*) dict
{
    id result = [[NSMutableArray alloc] init];
    for (id turn in [dict objectForKey:@"turns"])
    {
        [result addObject:[[GUMatchTurn alloc] initWithDictionary:turn]];
    }
    
    return result;
}

+ (NSArray*)getMatches:(NSDictionary*) dict
{
    id result = [[NSMutableArray alloc] init];
    for (id match in [dict objectForKey:@"matches"])
    {
        [result addObject:[[GUMatch alloc] initWithDictionary:match]];
    }
    
    return result;
}

+ (NSData*)serialiseDictionaryToData:(NSDictionary*)dict
{
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    return json;
}

+ (NSDictionary*)parseStorageDataToDictionary:(NSDictionary*)dict
{
    NSString* jsonString = [dict objectForKey:@"value"];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

+ (NSArray*)convertDictionaryToAchievementArray:(NSDictionary*)dict {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    NSArray* achievements = [dict objectForKey:@"achievements"];
    for (id jsonAchievement in achievements) {
        GUAchievement* achievement = [[GUAchievement alloc] initWithDictionary:jsonAchievement];
        [result addObject:achievement];
    }
    
    return [[NSArray alloc] initWithArray:result];
}

@end
