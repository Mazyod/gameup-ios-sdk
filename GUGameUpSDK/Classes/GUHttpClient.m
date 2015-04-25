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
#import "GUAchievement.h"
#import "GULeaderboard.h"
#import "GULeaderboardRank.h"
#import "GUResponderProtocol.h"
#import "GURequestRetryHandlerProtocol.h"

static NSString *const GAMEUP_VERSION=@"0.6.0";
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
          withAppendedUrlPath:@"oauth2"
                   withMethod:@"POST"
                   withApiKey:apikeyToUse
                    withToken:token
                   withEntity:entity
                withResponder:responder
             withRetryHandler:handler];
}

+ (void)sendRequest:(NSString*)to
       withEndpoint:(enum GURequestType)endpoint
withAppendedUrlPath:(NSString*)appendedUrlPath
         withMethod:(NSString*)method
         withApiKey:(NSString*)apiKey
          withToken:(NSString*)token
         withEntity:(id)entity
      withResponder:(id<GUResponderProtocol>)responder
   withRetryHandler:(id<GURequestRetryHandlerProtocol>)handler
{
    
    NSMutableString *stringUrl = [[NSMutableString alloc] initWithString:to];
    [stringUrl appendString:[REQUEST_URLS objectForKey:@(endpoint)]];
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
        [request setHTTPBody:[GUHttpClient serialiseDictionaryToData:entity]];
    }
    
    [GUHttpClient sendRequest:request
                 withEndpoint:endpoint
          withAppendedUrlPath:appendedUrlPath
                   withEntity:entity
                withResponder:responder
             withRetryHandler:handler];
}

+ (void)sendRequest:(NSURLRequest*)request
       withEndpoint:(enum GURequestType)endpoint
withAppendedUrlPath:(NSString*)appendedUrlPath
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
                        withStatusCode:200
                   withAppendedUrlPath:appendedUrlPath
                     withRequestEntity:entity
                    withResponseEntity:JSON
                         withResponder:responder];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = [operation response];
        
        if ([response statusCode] >= 500) {
            [retryHandler requestFailed:request];
            if ([retryHandler shouldRetryRequest:request]) {
                [GUHttpClient sendRequest:request
                     withEndpoint:endpoint
              withAppendedUrlPath:appendedUrlPath
                       withEntity:entity
                    withResponder:responder
                 withRetryHandler:retryHandler];
            } else {
                [self listenerCallback:endpoint
                        withStatusCode:[response statusCode]
                   withAppendedUrlPath:appendedUrlPath
                     withRequestEntity:entity
                    withResponseEntity:error
                         withResponder:responder];
            }
        } else {
            [retryHandler requestSucceed:request];
            [self listenerCallback:endpoint
                    withStatusCode:[response statusCode]
               withAppendedUrlPath:appendedUrlPath
                 withRequestEntity:entity
                withResponseEntity:error
                     withResponder:responder];
        }
    }];
    [NETWORK_MANAGER.operationQueue addOperation:op];
}

+ (void)listenerCallback:(enum GURequestType)requestKey
          withStatusCode:(NSInteger)statusCode
     withAppendedUrlPath:(id)urlPath
       withRequestEntity:(id)requestEntity
      withResponseEntity:(id)responseEntity
           withResponder:(id<GUResponderProtocol>)responseDelegate
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
            if (statusCode == 200) { [responseDelegate retrievedStoredData:urlPath withData:[GUHttpClient parseStorageDataToDictionary:responseEntity]]; }
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
            if (statusCode == 200) { [responseDelegate retrievedGameAchievements:[GUHttpClient convertDictionaryToAchievementArray:responseEntity]]; }
            else { [responseDelegate failedToRetrieveGameAchievements:statusCode withError:responseEntity]; }
            break;
        case ACHIEVEMENTS_GAMER:
            if (statusCode == 200) { [responseDelegate retrievedGamerAchievements:[GUHttpClient convertDictionaryToAchievementArray:responseEntity]]; }
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
