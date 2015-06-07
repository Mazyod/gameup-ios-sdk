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
 Represents interface for interacting with the GameUp service with a gamer token
 */
@interface GUSession : NSObject

/**
 Initialise a GameUp Session with an API Key, Gamer Token, your responder and a custom retry handler.
 */
-(id)initWithApiKey:(id)apikeyToUse
          withToken:(id)tokenToUse
      withResponder:(id<GUResponderProtocol>)responder
   withRetryHandler:(id<GURequestRetryHandlerProtocol>)handler;


/**
 Returns the cached Gamer Token. Save this Gamer Token in the local device storage for later restore.
 */
-(id)getGamerToken;

/**
 Get information about the gamer who owns this session.
 */
-(void)retrieveGamerProfile;

/**
 Perform a key-value storage read operation.
 
 @param storageKey The key to attempt to read data from.
 */
-(void)retrieveStoredDataWithKey:(NSString*)storageKey;

/**
 Perform a key-value storage write operation, storing data as JSON. Data
 is private per-user and per-game.
 
 NOTE: This is not designed to store confidential data, such as payment
 information etc.
 
 @param value The object to serialise and store.
 @param storageKey The key to store the given data under.
 */
-(void)storeData:(NSDictionary*)value WithKey:(NSString*)storageKey;

/**
 Perform a key-value storage delete operation. Will silently ignore absent
 data.
 
 @param key The key to delete data from.
 */
-(void)deleteStoredDataWithKey:(NSString*)storageKey;

/**
 Get a list of achievements available for the game, including any gamer
 data such as progress or completed timestamps.
 */
-(void)retrieveAllAchievementsWithProgress;

/**
 Report progress towards a given achievement.
 
 @param achievementUpdate An achievement update to be sent to the GameUp server
 */
-(void)updateAchievement:(GUAchievementUpdate*)achievementUpdate;

/**
 Get the metadata including leaderboard enteries for given leaderboard.
 This also retrieves the current gamer's leaderboard standing
 
 @param leaderboardId The Leadeboard ID to use.
 */
-(void)retrieveLeaderboardDataAndRankWithLeaderboardId:(id)leaderboardId;

/**
 Update the gamer's stand in the leaderboard with a new score
 
 @param update A Leaderboard update to be sent to the GameUp server
 */
-(void)updateLeaderboardRank:(GULeaderboardUpdate*)update;

/**
 Retrieve a list of matches the gamer is part of, along with the metadata for each match. 
 */
-(void)retrieveMatches;

/**
 Retrieve a particular match's status and metadata.
 @param matchId The match identifier
 */
-(void)retrieveMatch:(NSString*) matchId;

/**
 Get turn data for a particular match, only returning turns newer than the identified one.
 @param matchId The match identifier
 @param The turn number to start from, not inclusive. Use '0' to get all the turns in the match
 */
-(void)retrieveTurnData:(NSInteger) turnNumber forMatchWithId:(NSString*) matchId;

/**
 Submit turn data to the specified match.
 
 @param matchId The match identifier
 @param data Turn data to submit
 @param turn Last seen turn number - this is used as a basic consistency check
 @param nextGamerNickname Which gamer the next turn belongs to
 */
-(void)submitTurn:(NSInteger)turn withData:(NSString*)data toNextGamer:(NSString*)nextGamerNickname forMatch:(NSString*)matchId;

/**
 Request a new match. If there are not enough waiting gamers, the current gamer will be added to the queue instead.
 @param requiredGamers The minimal required number of gamers needed to create a new match
 */
-(void)createMatch:(NSInteger)requiredGamers;

/**
 End match. This will only work if it's the current gamer's turn.
 @param matchId The match identifier
 */
-(void)endMatchWithId:(NSString*)matchId;


/**
 Leave match. This will only work if it's NOT the current gamer's turn.
 @param matchId The match identifier
 */
-(void)leaveMatchWithId:(NSString*)matchId;

/**
 Subscribe this device for Push notification with GameUp Push and Apple Push Notifications.
 
 @param inDeviceToken raw Device Token recieved from APN
 @param segments Segment names to subscribe to. To subscribe to all segments, pass an empty array.
 */
- (void)subscribePushWithDeviceToken:(NSData*)inDeviceToken toSegments:(NSArray*)segments;

@end