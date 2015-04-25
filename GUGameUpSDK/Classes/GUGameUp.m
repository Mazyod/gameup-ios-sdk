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
#import "GUAchievementUpdate.h"
#import "GULeaderboardUpdate.h"
#import "GUResponderProtocol.h"
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
    [loginUrlPath appendString:[[GUHttpClient REQUEST_URLS] objectForKey:@(LOGIN)]];
    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"GULoginStoryboard" bundle: nil];
    
    GULoginViewController *controller = (GULoginViewController *)[loginStoryboard instantiateViewControllerWithIdentifier:@"GULoginViewController"];
    [controller initWithResponder:responseDelegate
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
    [GUHttpClient sendRequest:GAMEUP_LOGIN_URL
                 withEndpoint:LOGIN
          withAppendedUrlPath:@"anonymous"
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
   withAppendedUrlPath:(NSString*)appendedUrlPath
            withMethod:(NSString*)method
             withToken:(NSString*)token
            withEntity:(id)entity
{

    [GUHttpClient sendRequest:GAMEUP_API_URL
                 withEndpoint:endpoint
          withAppendedUrlPath:appendedUrlPath
                   withMethod:method
                   withApiKey:apiKey
                    withToken:token
                   withEntity:entity
                withResponder:responseDelegate
             withRetryHandler:retryHandler];
}
@end
