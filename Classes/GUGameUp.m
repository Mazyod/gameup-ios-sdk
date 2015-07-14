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

#import "GUGameUp.h"
#import "GUHttpClient.h"
#import "GUDefaultRequestRetryHandler.h"

@implementation GUGameUp
{
    id<GUResponderProtocol> responseDelegate;
    id<GURequestRetryHandlerProtocol> retryHandler;
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
    }
    return self;
}

-(GUSession*)restoreSession:(id)gamerToken
{
    return [[GUSession alloc] initWithApiKey:apiKey withToken:gamerToken withResponder:responseDelegate withRetryHandler:retryHandler];
}

- (void)ping
{
    [self sendApiRequest:PING
           withUrlParams:@{}
              withMethod:@"HEAD"
              withEntity:@""];
}

- (void)retrieveServerInfo
{
    [self sendApiRequest:SERVER
           withUrlParams:@{}
              withMethod:@"GET"
              withEntity:@""];
}

- (void)retrieveGameDetails
{
    [self sendApiRequest:GAME
           withUrlParams:@{}
              withMethod:@"GET"
              withEntity:@""];
}

-(void)retrieveAllAchievements
{
    [self sendApiRequest:ACHIEVEMENTS_GAME
           withUrlParams:@{}
              withMethod:@"GET"
              withEntity:@""];
}

-(void)retrieveLeaderboardDataWithLeaderboardId:(id)leaderboardId
{
    [self sendApiRequest:LEADERBOARD_GAME
           withUrlParams:@{@":id": leaderboardId}
              withMethod:@"GET"
              withEntity:@""];
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
    NSMutableString *loginUrlPath = [[NSMutableString alloc] initWithString:GAMEUP_ACCOUNTS_URL];
    [loginUrlPath appendString:[[GUHttpClient REQUEST_URLS] objectForKey:@(LOGIN)]];
    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"GULoginStoryboard" bundle: nil];
    
    GULoginViewController *controller = (GULoginViewController *)[loginStoryboard instantiateViewControllerWithIdentifier:@"GULoginViewController"];
    [controller initWithResponder:responseDelegate
                 withRetryHandler:retryHandler
               withLoginServerUrl:loginUrlPath
                     withProvider:loginProvider
                       withApiKey:apiKey
                   withGamerToken:gamerToken
                    withUserAgent:[GUHttpClient USER_AGENT]];
    return controller;
}

-(void)loginAnonymouslyWith:(NSString*)deviceId
{
    NSDictionary* entity = @{@"id" : deviceId};
    [GUHttpClient sendRequest:GAMEUP_ACCOUNTS_URL
                 withEndpoint:LOGIN
                withUrlParams:@{@":type": @"anonymous"}
                   withMethod:@"POST"
                   withApiKey:apiKey
                    withToken:@""
                   withEntity:entity
                withResponder:responseDelegate
             withRetryHandler:retryHandler];
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
    [GUHttpClient sendLoginRequest:provider
                        withApiKey:apiKey
                   withAccessToken:accessToken
                         withToken:token
                     withResponder:responseDelegate
                  withRetryHandler:retryHandler];
}

- (void)sendApiRequest:(enum GURequestType)endpoint
         withUrlParams:(NSDictionary*)urlParams
            withMethod:(NSString*)method
            withEntity:(id)entity
{

    [GUHttpClient sendRequest:GAMEUP_API_URL
                 withEndpoint:endpoint
                withUrlParams:urlParams
                   withMethod:method
                   withApiKey:apiKey
                    withToken:@""
                   withEntity:entity
                withResponder:responseDelegate
             withRetryHandler:retryHandler];
}
@end
