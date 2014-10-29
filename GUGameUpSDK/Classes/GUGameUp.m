/*
 * Copyright 2014 GameUp
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <GUGameUp.h>
#import <GUJSONSerialisableProtocol.h>
#import <GUResponderProtocol.h>
#import <AFNetworking/AFNetworking.h>
#import <Base64.h>

typedef NS_ENUM(NSInteger, GURequest)
{
    PING,
    GAME,
    GAMER,
    STORAGE_PUT,
    STORAGE_GET,
    STORAGE_DELETE,
    LOGIN
};

static NSString *const GAMEUP_VERSION=@"0.1.0";
static NSString *const AFN_VERSION=@"AFN1.3.4";

static NSString *const USER_AGENT_NAME=@"gameup-ios-sdk";
static NSString *const GAMEUP_LOGIN_URL = @"https://login.gameup.io";
static NSString *const GAMEUP_API_URL = @"https://api.gameup.io";

static NSString *USER_AGENT;

@implementation GUGameUp
{
    id<GUResponderProtocol> responseDelegate;
    NSDictionary *requestUrls;
}

- (id) initWithResponder:(id<GUResponderProtocol>)responder
{
    self = [super init];
    if (self) {
        USER_AGENT = [[NSString alloc] initWithString:[self setupUserAgent]];
        
        responseDelegate = responder;
        requestUrls = @{
            @(PING) : @"/v0/",
            @(GAME) : @"/v0/game/",
            @(GAMER) : @"/v0/gamer/",
            @(STORAGE_PUT) : @"/v0/storage/",
            @(STORAGE_GET) : @"/v0/storage/",
            @(STORAGE_DELETE) : @"/v0/storage/",
            @(LOGIN) : @"/v0/gamer/login/"
        };
    }
    return self;
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


- (UIViewController*)requestSocialLogin:(NSString*)apiKey
{
    NSMutableString *loginUrlPath = [[NSMutableString alloc] initWithString:GAMEUP_LOGIN_URL];
    [loginUrlPath appendString:[requestUrls objectForKey:@(LOGIN)]];
    GULoginViewController *controller = [[GULoginViewController alloc]initWithResponder:responseDelegate
                                                                     withLoginServerUrl:loginUrlPath
                                                                             withApiKey:apiKey
                                                                          withUserAgent:USER_AGENT];
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
                                                       timeoutInterval:30.0];
    
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
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self listenerCallback:endpoint withStatusCode:200 withAppendedUrlPath:appendedUrlPath withRequestEntity:entity withResponseEntity:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,  NSError *error, id JSON) {
        [self listenerCallback:endpoint withStatusCode:[response statusCode] withAppendedUrlPath:appendedUrlPath withRequestEntity:entity withResponseEntity:error];
    }];
    [operation start];

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
        case GAME:
            if (statusCode == 200) { [responseDelegate retrievedGameData:[[GUGame alloc] initWithDictionary:responseEntity]]; }
            else { [responseDelegate failedToRetrievedGameData:statusCode withError:responseEntity]; }
            break;
        case GAMER:
            if (statusCode == 200) { [responseDelegate retrievedGamerProfile:[[GUGamer alloc] initWithDictionary:responseEntity]]; }
            else { [responseDelegate failedToRetrievedGamerProfile:statusCode withError:responseEntity]; }
            break;
        case STORAGE_GET:
            if (statusCode == 200) { [responseDelegate retrievedStoredData:urlPath withData:[self parseStorageDataToDictionary:responseEntity]]; }
            else { [responseDelegate failedtoRetrieveStoredData:statusCode withError:responseEntity withStorageKey:urlPath]; }
            break;
        case STORAGE_PUT:
            if (statusCode == 200) { [responseDelegate successfullyStoredData:urlPath]; }
            else { [responseDelegate failedtoStoreData:statusCode withError:responseEntity withStorageKey:urlPath withData:requestEntity ]; }
            break;
        case STORAGE_DELETE:
            if (statusCode == 200) { [responseDelegate successfullyDeletedData:urlPath]; }
            else { [responseDelegate failedtoDeleteStoredData:statusCode withError:responseEntity withStorageKey:urlPath withData:requestEntity]; }
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

@end
