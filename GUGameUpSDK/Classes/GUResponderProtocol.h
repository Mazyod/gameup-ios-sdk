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
#import "GUGame.h"
#import "GUGamer.h"
#import "GUServer.h"
#import "GUAchievement.h"
#import "GULeaderboard.h"
#import "GULeaderboardRank.h"

/**
 Callback protocol to be called upon completion / failure of GameUp Requests
 */
@protocol GUResponderProtocol
@required
/** Invoked when the ping request has been successful */
- (void)successfulPing;
/**
 Invoked when the ping request has failed
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 */
- (void)failedPing:(NSInteger)statusCode
         withError:(NSError*) error;

/**
 Invoked when the server data was retrieved successfully
 @param serverData server data retrieved
 */
- (void)retrievedServerData:(GUServer*)serverData;
/**
 Invoked when server data failure was failed
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 */
- (void)failedToRetrieveServerData:(NSInteger)statusCode
                         withError:(NSError*) error;

/**
 Invoked when game data was successfully retrieved
 @param game Game data retrieved
 */
- (void)retrievedGameData:(GUGame*)game;
/**
 Invoked when retrieving game data failed
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 */
- (void)failedToRetrieveGameData:(NSInteger)statusCode
                       withError:(NSError*) error;

/**
 Invoked when gamer profile data was successfully retrieved
 @param gamer Gamer profile data retrieved
 */
- (void)retrievedGamerProfile:(GUGamer*)gamer;
/**
 Invoked when retrieving gamer profile data failed
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 */
- (void)failedToRetrieveGamerProfile:(NSInteger)statusCode
                           withError:(NSError*) error;

/**
 Invoked when storage PUT operation successed
 @param storageKey storageKey of the put operation
 */
- (void)successfullyStoredData:(id)storageKey;
/**
 Invoked when storage PUT operation failed
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 @param storageKey Storage key associated with this failure
 @param data Data that was supposedly meant to be stored
 */
- (void)failedToStoreData:(NSInteger)statusCode
                withError:(NSError*)error
           withStorageKey:(NSString*)storageKey
                 withData:(NSDictionary*)data;

/**
 Invoked when storage GET operation successed
 @param storageKey storageKey of the get operation
 @param data Data retrieved from GameUp storage
 */
- (void)retrievedStoredData:(NSString*)storageKey
                   withData:(NSDictionary*)data;
/**
 Invoked when storage GET operation failed
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 @param storageKey Storage key associated with this failure
 */
- (void)failedToRetrieveStoredData:(NSInteger)statusCode
                         withError:(NSError*)error
                    withStorageKey:(NSString*)storageKey;

/**
 * Invoked when storage DELETE operation successed
 * @param storageKey storageKey of the delete operation
 */
- (void)successfullyDeletedData:(NSString*)storageKey;
/**
 Invoked when storage DELETE operation failed
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 @param storageKey Storage key associated with this failure
 */
- (void)failedToDeleteStoredData:(NSInteger)statusCode
                       withError:(NSError*)error
                  withStorageKey:(NSString*)storageKey;

/**
 Invoked when successfully retrieved list of achievements, 
 without gamer data
 @param achievements Array of GUAchievement objects
 */
- (void)retrievedGameAchievements:(NSArray*)achievements;
/**
 Invoked when retrieving game achievements failed
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 */
- (void)failedToRetrieveGameAchievements:(NSInteger)statusCode
                               withError:(NSError *)error;

/**
 Invoked when successfully retrieved list of achievements,
 including gamer progress towards those achievements
 @param achievements Array of GUAchievement objects
 */
- (void)retrievedGamerAchievements:(NSArray*)gamerAchievements;
/**
 Invoked when retrieving gamer achievements failed
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 */
- (void)failedToRetrieveGamerAchievements:(NSInteger)statusCode
                                withError:(NSError *)error;

/**
 Invoked when successfully updated achievement progress
 @param achievementUid ID of the updated achievement
 */
- (void)successfullyUpdatedAchievement:(NSString*)achievementUid;
/**
 Invoked when updating achievement progress failed
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 @param achievementUid ID of the achievement
 */
- (void)failedToUpdateAchievement:(NSInteger)statusCode
                        withError:(NSError*)error
               withAchievementUid:(NSString*)achievementUid;

/**
 Invoked when successfully retrieved leaderboard

 @param leaderboard Leaderboard metadata
 */
- (void)retrievedLeaderboardData:(GULeaderboard*)leaderboard;
/**
 Invoked when retrieving gamer leaderboard metadata failed
 @param error Error object associated with this failure
 */
- (void)failedToRetrieveLeaderboardData:(NSInteger)statusCode
                              withError:(NSError *)error;


/**
 Invoked when successfully retrieved leaderboard,
 including gamer's standing in the leaderboard

 @param leaderboard Leaderboard metadata
 @param leaderboardRank gamer's rank in the leaderboard
 */
- (void)retrievedLeaderboardData:(GULeaderboard *)leaderboard andRank:(GULeaderboardRank*)leaderboardRank;
/**
 Invoked when retrieving gamer leaderboard ranking failed
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 */
- (void)failedToRetrieveLeaderboardDataAndRank:(NSInteger)statusCode
                                     withError:(NSError *)error;

/**
 Invoked when successfully updated leaderboard score
 @param leaderboardId ID of the updated leaderboard
 */
- (void)successfullyUpdatedLeaderboardRank:(NSString*)leaderboardId;
/**
 Invoked when updating leaderboard score failed
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 @param leaderboardUid ID of the Leaderboard
 */
- (void)failedToUpdateLeaderboardRank:(NSInteger)statusCode
                            withError:(NSError*)error
                   withLeaderboardUid:(NSString*)leaderboardUid;

/**
 Invoked when the gamer has successfully logged into their Social Provider
 @param gamerToken token retrieved. Can be safely stored on the device.

 NOTE: we recommend that you ping(apikey, gamerToken) 
 at the start of your game to make sure that both ApiKey and GamerToken are valid,
 if you choose to store the GamerToken on device storage
 */
- (void)successfullyLoggedinWithGamerToken:(NSString*)gamerToken;
/**
 Invoked when the gamer failed to login to their Social Provider
 caused by of multiple password failure, server errors etc

 @param error Error object associated with this failure
 */
- (void)failedToLoginWithError:(NSError*) error;

/**
 Invoked when the gamer explicitly presses 'Cancel' button the Login Window Navigation Bar
 */
- (void)loginCancelled;

@end
