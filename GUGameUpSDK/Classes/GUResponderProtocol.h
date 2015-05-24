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
#import "GUMatch.h"
#import "GUMatchTurn.h"
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
 Invoked when storage DELETE operation successed
 @param storageKey storageKey of the delete operation
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
- (void)retrievedLeaderboardData:(GULeaderboard *)leaderboard
                         andRank:(GULeaderboardRank*)leaderboardRank;
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
 Invoked when successfully retrieved a list of all matches for gamer.
 @param matches Array of GUMatch objects
 */
- (void)retrievedMatches:(NSArray*)matches;

/**
 Invoked when could not get a list of matches from the server
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 */
- (void)failedToRetrieveMatches:(NSInteger)statusCode
                      withError:(NSError*)error;

/**
 Invoked when successfully retrieved a match status and metadata
 @param metadata Match status and metadata
 @param matchId ID of the match that the metadata belongs to
 */
- (void)retrievedMatch:(GUMatch*)match
           withMatchId:(NSString*)matchId;

/**
 Invoked when could not get match metadata and status
 @param matchId ID of the match that this failure belongs to
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 */
- (void)failedToRetrieveMatch:(NSString*)matchId
               withStatusCode:(NSInteger)statusCode
                    withError:(NSError*)error;

/**
 Invoked when successfully retrieved a match's turn data
 @param data Array of GUMatchTurn data for the given match
 @param matchId ID of the match that the data belongs to
 */
- (void)retrievedTurn:(NSArray*)turns
             forMatch:(NSString*)matchId;

/**
 Invoked when could not get match turn data
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 @param matchId ID of the match that this failure belongs to
 */
- (void)failedToRetrieveTurnData:(NSInteger)statusCode
                       withError:(NSError*)error
                        forMatch:(NSString*)matchId;

/**
 Invoked when successfully submitted a match's turn data
 @param matchId ID of the match
 */
- (void)successfullySubmittedTurnDataForMatch:(NSString*)matchId;

/**
 Invoked when could not submit match turn data
 @param statusCode HTTP status code
 @param data Turn data that was failed to submit
 @param matchId ID of the match that this failure belongs to
 @param error Error object associated with this failure
 */
- (void)failedToSubmitTurn:(NSInteger)statusCode
                 withError:(NSError*)error
                  ForMatch:(NSString*)matchId
                  withData:(id)data;


/**
 Invoked when successfully created a match.
 @param metadata New match status and metadata
 */
- (void)createdNewMatch:(id)metadata;

/**
 Invoked when could not create match immediately due to insufficient gamers in the queue.
 The current gamer will be added to a queue for the next available match.
 
 In this current implementation, the only way to get notified that the gamer has joint a new match
 is by constant polling of the [GUSession retrieveMatches]. 
 
 We recommend that you don't use a high number as the required number of gamers for a given match 
 as this could increase the likelihood that your gamer would be queued rather than immediately allocated a match.
 */
- (void)successfullyQueuedGamerForNewMatch;

/**
 Invoked when the service failed to create a new match.
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 */
- (void)failedToCreateMatch:(NSInteger)statusCode
                  withError:(NSError*)error;

/**
 Successfully ended the specified match
 @param matchId ID of the match
 */
- (void)SuccessfullyEndedMatch:(NSString*)matchId;

/**
 Failed to end the specified match
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 @param matchId ID of the match
 */
- (void)failedToEndMatch:(NSInteger)statusCode
               withError:(NSError*)error
              forMatchId:(NSString*)matchId;

/**
 Successfully left the specified match
 @param matchId ID of the match
 */
- (void)SuccessfullyLeftMatch:(NSString*)matchId;

/**
 Failed to leave the specified match
 @param statusCode HTTP status code
 @param error Error object associated with this failure
 @param matchId ID of the match
 */
- (void)failedToLeaveMatch:(NSInteger)statusCode
                 withError:(NSError*)error
                forMatchId:(NSString*)matchId;

/**
 Invoked when the gamer has successfully logged into their Social Provider
 @param session newly established Session. Can be safely stored on the device.

 NOTE: we recommend that you [GUSession ping]
 at the start of your game to make sure that both ApiKey and the session are valid,
 if you choose to store the GamerToken on device storage
 */
- (void)successfullyLoggedinWithSession:(id)session;

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
