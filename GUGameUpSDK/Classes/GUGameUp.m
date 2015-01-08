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
#import "GUAchievementUpdate.h"
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
    LOGIN
};

static NSString *const GAMEUP_VERSION=@"0.3.0";
static NSString *const AFN_VERSION=@"AFN2.5.0";

static NSString *const USER_AGENT_NAME=@"gameup-ios-sdk";
static NSString *const GAMEUP_LOGIN_URL = @"https://login.gameup.io";
static NSString *const GAMEUP_API_URL = @"https://api.gameup.io";

static NSString *USER_AGENT;
static NSInteger REQUEST_TIMEOUT=30; //seconds

@implementation GUGameUp
{
    id<GUResponderProtocol> responseDelegate;
    id<GURequestRetryHandlerProtocol> retryHandler;
    NSDictionary *requestUrls;
    AFHTTPRequestOperationManager *networkManager;
}

- (id) initWithResponder:(id<GUResponderProtocol>)responder
{
    GUDefaultRequestRetryHandler *handler = [[GUDefaultRequestRetryHandler alloc] initWithDefaultRetryAttempts];
    return [self initWithResponder:responder withRetryHandler:handler];
}

- (id) initWithResponder:(id<GUResponderProtocol>)responder withRetryHandler:(id<GURequestRetryHandlerProtocol>)handler
{
    self = [super init];
    if (self) {
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

- (void)ping:(NSString*)apiKey
{
    [self ping:apiKey withToken:@""];
}

- (void)ping:(NSString*)apiKey withToken:(NSString*)token
{
    [self sendRequest:PING
  withAppendedUrlPath:@""
           withMethod:@"HEAD"
           withApiKey:apiKey
            withToken:token
           withEntity:@""];
}

- (void)requestServerInfo:(NSString *)apiKey
{
    [self sendRequest:SERVER
  withAppendedUrlPath:@""
           withMethod:@"GET"
           withApiKey:apiKey
            withToken:@""
           withEntity:@""];
}

- (void)requestToGetGameDetails:(NSString*)apiKey
{
    [self sendRequest:GAME
  withAppendedUrlPath:@""
           withMethod:@"GET"
           withApiKey:apiKey
            withToken:@""
           withEntity:@""];
}

- (void)requestToGetGamerProfile:(NSString*)apiKey withToken:(NSString*)token
{
    [self sendRequest:GAMER
  withAppendedUrlPath:@""
           withMethod:@"GET"
           withApiKey:apiKey
            withToken:token
           withEntity:@""];
}

- (void)requestToGetStoredData:(id)apiKey withToken:(id)token storedWithKey:(NSString*)storageKey
{
    [self sendRequest:STORAGE_GET
  withAppendedUrlPath:storageKey
           withMethod:@"GET"
           withApiKey:apiKey
            withToken:token
           withEntity:@""];
}

- (void)requestToStoreData:(id)apiKey withToken:(id)token storeWithKey:(NSString*)storageKey withValue:(NSDictionary*)value
{
    [self sendRequest:STORAGE_PUT
  withAppendedUrlPath:storageKey
           withMethod:@"PUT"
           withApiKey:apiKey
            withToken:token
           withEntity:value];
}

- (void)requestToDeleteStoredData:(id)apiKey withToken:(id)token storedWithKey:(NSString*)storageKey
{
    [self sendRequest:STORAGE_DELETE
  withAppendedUrlPath:storageKey
           withMethod:@"DELETE"
           withApiKey:apiKey
            withToken:token
           withEntity:@""];
}

-(void)requestToGetAllAchievements:(id)apiKey
{
    [self sendRequest:ACHIEVEMENTS_GAME
  withAppendedUrlPath:@""
           withMethod:@"GET"
           withApiKey:apiKey
            withToken:@""
           withEntity:@""];
}

-(void)requestToGetAllAchievements:(id)apiKey withToken:(id)token
{
    [self sendRequest:ACHIEVEMENTS_GAMER
  withAppendedUrlPath:@""
           withMethod:@"GET"
           withApiKey:apiKey
            withToken:token
           withEntity:@""];
}

-(void)requestToUpdateAchievement:(id)apiKey withToken:(id)token
            withAchievementUpdate:(GUAchievementUpdate*)achievementUpdate
{
    [self sendRequest:ACHIEVEMENT_POST
  withAppendedUrlPath:[achievementUpdate achievementId]
           withMethod:@"POST"
           withApiKey:apiKey
            withToken:token
           withEntity:[achievementUpdate toDictionary]];
}

- (UIViewController*)requestSocialLogin:(NSString*)apiKey
{
    NSMutableString *loginUrlPath = [[NSMutableString alloc] initWithString:GAMEUP_LOGIN_URL];
    [loginUrlPath appendString:[requestUrls objectForKey:@(LOGIN)]];
    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"GULoginStoryboard" bundle: nil];
    
    GULoginViewController *controller = (GULoginViewController *)[loginStoryboard instantiateViewControllerWithIdentifier:@"GULoginViewController"];
    [controller initWithResponder:responseDelegate withLoginServerUrl:loginUrlPath withApiKey:apiKey withUserAgent:USER_AGENT];
    return controller;
}

- (void)sendRequest:(enum GURequest)endpoint
withAppendedUrlPath:(NSString*)appendedUrlPath
         withMethod:(NSString*)method
         withApiKey:(NSString*)apikey
          withToken:(NSString*)token
         withEntity:(id)entity
{
    
    NSMutableString *stringUrl = [[NSMutableString alloc] initWithString:GAMEUP_API_URL];
    [stringUrl appendString:[requestUrls objectForKey:@(endpoint)]];
    [stringUrl appendString:appendedUrlPath];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:stringUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:REQUEST_TIMEOUT];
    
    NSMutableString *authorization = [[NSMutableString alloc] initWithString:apikey];
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
