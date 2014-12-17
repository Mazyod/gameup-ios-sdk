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
#import "GULoginViewController.h"
#import "GUAchievementUpdate.h"
#import "GULeaderboardUpdate.h"

/**
 Represents interface for interacting with the GameUp service
 */
@interface GUGameUp : NSObject

-(id)initWithResponder:(id<GUResponderProtocol>)responder;

/**
 Ping the GameUp service to check it is reachable and ready to handle
 requests.

 @param apiKey The API key to use.
 */
-(void)ping:(NSString*)apiKey;

/**
 Ping the GameUp service to check it is reachable and ready to handle
 requests.

 @param apiKey The API key to use.
 @param token The gamer token to use, may be an empty String but not null.
 */
-(void)ping:(id)apiKey withToken:(id)token;

/**
 Retrieve GameUp global service and/or server instance data.

 @param apiKey The API key to use.
 */
-(void)requestServerInfo:(NSString*)apiKey;

/**
 Retrieve information about the game the given API key corresponds to, as
 configured in the remote service.

 @param apiKey The API key to use.
 */
-(void)requestToGetGameDetails:(id)apiKey;

/**
 Get information about the gamer who owns this session.

 @param apiKey The API key to use.
 @param token The gamer token to use.
 */
-(void)requestToGetGamerProfile:(id)apiKey withToken:(id)token;

/**
 Perform a key-value storage read operation.

 @param apiKey The API key to use.
 @param token The gamer token to use.
 @param storageKey The key to attempt to read data from.
 */
-(void)requestToGetStoredData:(id)apiKey withToken:(id)token storedWithKey:(NSString*)storageKey;

/**
 Perform a key-value storage write operation, storing data as JSON. Data
 is private per-user and per-game.

 NOTE: This is not designed to store confidential data, such as payment
 information etc.

 @param apiKey The API key to use.
 @param token The gamer token to use.
 @param storageKey The key to store the given data under.
 @param value The object to serialise and store.
 */
-(void)requestToStoreData:(id)apiKey withToken:(id)token storeWithKey:(NSString*)storageKey withValue:(NSDictionary*)value;

/**
 Perform a key-value storage delete operation. Will silently ignore absent
 data.

 @param apiKey The API key to use.
 @param token The gamer token to use.
 @param key The key to delete data from.
 */
-(void)requestToDeleteStoredData:(id)apiKey withToken:(id)token storedWithKey:(NSString*)storageKey;

/**
 Get a list of achievements available for the game, excluding any gamer
 data such as progress or completed timestamps.

 @param apiKey The API key to use.
 */
-(void)requestToGetAllAchievements:(id)apiKey;

/**
 Get a list of achievements available for the game, including any gamer
 data such as progress or completed timestamps.

 @param apiKey The API key to use.
 @param token The gamer token to use.
 */
-(void)requestToGetAllAchievements:(id)apiKey withToken:(id)token;

/**
 Report progress towards a given achievement.

 @param apiKey The API key to use.
 @param token The gamer token to use.
 @param achievementUpdate An achievement update to be sent to the GameUp server
 */
-(void)requestToUpdateAchievement:(id)apiKey withToken:(id)token withAchievementUpdate:(GUAchievementUpdate*)achievementUpdate;

/**
 Get the metadata including leaderboard enteries for given leaderboard.

 @param apiKey The API key to use.
 @param leaderboardId The Leadeboard ID to use.
 */
-(void)requestToGetLeaderboardData:(id)apiKey withLeaderboardId:(id)leaderboardId;

/**
 Get the metadata including leaderboard enteries for given leaderboard. 
 This also retrieves the current gamer's leaderboard standing

 @param apiKey The API key to use.
 @param token The gamer token to use.
 @param leaderboardId The Leadeboard ID to use.
 */
-(void)requestToGetLeaderboardDataAndRank:(id)apiKey withToken:(id)token withLeaderboardId:(id)leaderboardId;

/**
 Update the gamer's stand in the leaderboard with a new score

 @param apiKey The API key to use.
 @param token The gamer token to use.
 @param leaderboardUpdate A Leaderboard update to be sent to the GameUp server
 */
-(void)requestToUpdateLeaderboardRank:(id)apiKey withToken:(id)token withLeaderboardUpdate:(GULeaderboardUpdate*)leaderboardUpdate;

/**
 Prepares a GULoginStoryboard and attaches it to a GULoginViewController

 @param apiKey The API key to use.
 @return GULoginViewController prepared to be shown to the user
 */
-(UIViewController*)requestSocialLogin:(id)apiKey;
@end
