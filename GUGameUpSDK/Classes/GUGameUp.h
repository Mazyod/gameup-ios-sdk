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

#import <Foundation/Foundation.h>
#import "GUResponderProtocol.h"
#import "GURequestRetryHandlerProtocol.h"
#import "GULoginViewController.h"
#import "GUAchievementUpdate.h"
#import "GULeaderboardUpdate.h"

/**
 Represents interface for interacting with the GameUp service
 */
@interface GUGameUp : NSObject

/**
 Initialise GUGameUp with an API Key, your responder and default retry handler.
 */
-(id)initWithApiKey:(id)apikey withResponder:(id<GUResponderProtocol>)responder;

/**
 Initialise GUGameUp with an API Key, your responder and a custom retry handler.
 */
-(id)initWithApiKey:(id)apikey withResponder:(id<GUResponderProtocol>)responder withRetryHandler:(id<GURequestRetryHandlerProtocol>)handler;

/**
 Ping the GameUp service with the given API Key to check it is reachable and ready to handle
 requests.
 */
-(void)ping;

/**
 Ping the GameUp service to check it is reachable and ready to handle
 requests.

 @param token The gamer token to use, may be an empty String but not null.
 */
-(void)pingWithToken:(id)token;

/**
 Retrieve GameUp global service and/or server instance data.
 */
-(void)requestServerInfo;

/**
 Retrieve information about the game the given API key corresponds to, as
 configured in the remote service.
 */
-(void)requestToGetGameDetails;

/**
 Get information about the gamer who owns this session.

 @param token The gamer token to use.
 */
-(void)requestToGetGamerProfile:(id)token;

/**
 Perform a key-value storage read operation.

 @param token The gamer token to use.
 @param storageKey The key to attempt to read data from.
 */
-(void)requestToGetStoredData:(id)token storedWithKey:(NSString*)storageKey;

/**
 Perform a key-value storage write operation, storing data as JSON. Data
 is private per-user and per-game.

 NOTE: This is not designed to store confidential data, such as payment
 information etc.

 @param token The gamer token to use.
 @param storageKey The key to store the given data under.
 @param value The object to serialise and store.
 */
-(void)requestToStoreData:(id)token storeWithKey:(NSString*)storageKey withValue:(NSDictionary*)value;

/**
 Perform a key-value storage delete operation. Will silently ignore absent
 data.

 @param token The gamer token to use.
 @param key The key to delete data from.
 */
-(void)requestToDeleteStoredData:(id)token storedWithKey:(NSString*)storageKey;

/**
 Get a list of achievements available for the game, excluding any gamer
 data such as progress or completed timestamps.
 */
-(void)requestToGetAllAchievements;

/**
 Get a list of achievements available for the game, including any gamer
 data such as progress or completed timestamps.

 @param token The gamer token to use.
 */
-(void)requestToGetAllAchievements:(id)token;

/**
 Report progress towards a given achievement.

 @param token The gamer token to use.
 @param achievementUpdate An achievement update to be sent to the GameUp server
 */
-(void)requestToUpdateAchievement:(id)token withAchievementUpdate:(GUAchievementUpdate*)achievementUpdate;

/**
 Get the metadata including leaderboard enteries for given leaderboard.

 @param leaderboardId The Leadeboard ID to use.
 */
-(void)requestToGetLeaderboardData:(id)leaderboardId;

/**
 Get the metadata including leaderboard enteries for given leaderboard. 
 This also retrieves the current gamer's leaderboard standing

 @param token The gamer token to use.
 @param leaderboardId The Leadeboard ID to use.
 */
-(void)requestToGetLeaderboardDataAndRank:(id)token withLeaderboardId:(id)leaderboardId;

/**
 Update the gamer's stand in the leaderboard with a new score

 @param token The gamer token to use.
 @param leaderboardUpdate A Leaderboard update to be sent to the GameUp server
 */
-(void)requestToUpdateLeaderboardRank:(id)token withLeaderboardUpdate:(GULeaderboardUpdate*)leaderboardUpdate;

/**
 Prepares a GULoginStoryboard and attaches it to a GULoginViewController to login through Twitter
 
 @return GULoginViewController prepared to be shown to the user
 */
-(UIViewController*)loginThroughBrowserToTwitter;

/**
 Prepares a GULoginStoryboard and attaches it to a GULoginViewController to login through Twitter
 and links an existing (usually an anonymous token) to this account.

 @param gamerToken The gamerToken to attach to the logged in profile
 @return GULoginViewController prepared to be shown to the user
 */
-(UIViewController*)loginThroughBrowserToTwitterAndLinkExistingToken:(NSString*)gamerToken;

/**
 Prepares a GULoginStoryboard and attaches it to a GULoginViewController to login through Google
 
 @return GULoginViewController prepared to be shown to the user
 */
-(UIViewController*)loginThroughBrowserToGoogle;

/**
 Prepares a GULoginStoryboard and attaches it to a GULoginViewController to login through Google
 and links an existing (usually an anonymous token) to this account.
 
 @param gamerToken The gamerToken to attach to the logged in profile
 @return GULoginViewController prepared to be shown to the user
 */
-(UIViewController*)loginThroughBrowserToGoogleAndLinkExistingToken:(NSString*)gamerToken;

/**
 Prepares a GULoginStoryboard and attaches it to a GULoginViewController to login through Facebook
 
 @return GULoginViewController prepared to be shown to the user
 */
-(UIViewController*)loginThroughBrowserToFacebook;

/**
 Prepares a GULoginStoryboard and attaches it to a GULoginViewController to login through Facebook
 and links an existing (usually an anonymous token) to this account.
 
 @param gamerToken The gamerToken to attach to the logged in profile
 @return GULoginViewController prepared to be shown to the user
 */
-(UIViewController*)loginThroughBrowserToFacebookAndLinkExistingToken:(NSString*)gamerToken;

/**
 Prepares a GULoginStoryboard and attaches it to a GULoginViewController to login through GameUp
 
 @return GULoginViewController prepared to be shown to the user
 */
-(UIViewController*)loginThroughBrowserToGameUp;

/**
 Prepares a GULoginStoryboard and attaches it to a GULoginViewController to login through GameUp
 and links an existing (usually an anonymous token) to this account.
 
 @param gamerToken The gamerToken to attach to the logged in profile
 @return GULoginViewController prepared to be shown to the user
 */
-(UIViewController*)loginThroughBrowserToGameUpAndLinkExistingToken:(NSString*)gamerToken;

/**
 Perform an anonymous login
 @param deviceId An identifier to use to create a gamerToken. Using Device ID is recommended.
 */
-(void)loginAnonymouslyWith:(NSString*)deviceId;

/**
 Perform OAuth passthrough login for Facebook.
 @param accessToken The Facebook access token to send to GameUp.
 */
-(void)loginThroughFacebookWith:(NSString*)accessToken;

/**
 Perform OAuth passthrough login for Facebook.
 @param accessToken The Facebook access token to send to GameUp.
 @param gameUpSession A session pointing to an existing account, on
                      successful login the new social profile will be
                      bound to this same account if possible, data will
                      be migrated from the given account to the new one
                      otherwise.
 */
-(void)loginThroughFacebookWith:(NSString*)accessToken andLinkExistingToken:(NSString*)gamerToken;

/**
 Perform OAuth passthrough login for Google.
 @param accessToken The Google access token to send to GameUp.
 */
-(void)loginThroughGoogleWith:(NSString*)accessToken;

/**
 Perform OAuth passthrough login for Google.
 @param accessToken The Google access token to send to GameUp.
 @param gameUpSession A session pointing to an existing account, on
                      successful login the new social profile will be
                      bound to this same account if possible, data will
                      be migrated from the given account to the new one
 */
-(void)loginThroughGoogleWith:(NSString*)accessToken andLinkExistingToken:(NSString*)gamerToken;
@end
