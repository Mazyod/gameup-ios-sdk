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
#import "GUSession.h"
#import "GUResponderProtocol.h"
#import "GURequestRetryHandlerProtocol.h"
#import "GULoginViewController.h"

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
 Restores a GameUp Session with a Gamer Token. Validate Gamer Token with [GUSession ping].
 */
-(GUSession*)restoreSession:(id)gamerToken;

/**
 Ping the GameUp service with the given API Key to check it is reachable and ready to handle
 requests.
 */
-(void)ping;

/**
 Retrieve GameUp global service and/or server instance data.
 */
-(void)retrieveServerInfo;

/**
 Retrieve information about the game the given API key corresponds to, as
 configured in the remote service.
 */
-(void)retrieveGameDetails;

/**
 Get a list of achievements available for the game, excluding any gamer
 data such as progress or completed timestamps.
 */
-(void)retrieveAllAchievements;

/**
 Get the metadata including leaderboard enteries for given leaderboard.

 @param leaderboardId The Leadeboard ID to use.
 */
-(void)retrieveLeaderboardDataWithLeaderboardId:(id)leaderboardId;

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
