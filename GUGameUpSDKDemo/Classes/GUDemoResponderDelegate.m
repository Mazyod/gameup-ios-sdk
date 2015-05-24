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

#import "GUDemoResponderDelegate.h"
#import "GUSession.h"
#import "GUAppDelegate.h"
#import "GUAchievement.h"
#import "GUAchievementUpdate.h"
#import "GULeaderboard.h"
#import "GULeaderboardRank.h"
#import "GULeaderboardUpdate.h"

@implementation GUDemoResponderDelegate

- (void)successfulPing
{
    NSLog(@"Ping successful!!");
}
- (void)failedPing:(NSInteger)statusCode
         withError:(NSError*) error
{
    NSLog(@"Ping failed with error %@", error);
}

- (void)retrievedServerData:(GUServer*)serverData
{
    NSString *inStr = [NSString stringWithFormat: @"Server Time: %ld", (long)[serverData time]];
    NSLog(@"ServerTime: %@", inStr);
}
- (void)failedToRetrieveServerData:(NSInteger)statusCode
                          withError:(NSError*) error
{
    NSLog(@"ServerTime failed with error %@", error);
}

- (void)retrievedGameData:(GUGame*)game
{
    
    NSLog(@"Game Name: %@",[game name]);
    NSLog(@"Game Description: %@",[game description]);
    NSLog(@"Game CreatedAt: %ld",(long)[game createdAt]);
    NSLog(@"Game UpdatedAt: %ld",(long)[game updatedAt]);
}
- (void)failedToRetrieveGameData:(NSInteger)statusCode
                        withError:(NSError*) error
{
    NSLog(@"Game failed with error %ld %@", (long)statusCode, error);
}

- (void)retrievedGamerProfile:(GUGamer*)gamer
{
    
    NSLog(@"\n\nGamer Nick Name: %@",[gamer nickname]);
    NSLog(@"Gamer Name: %@",[gamer name]);
    NSLog(@"Gamer timezone: %@",[gamer timezone]);
    NSLog(@"Gamer location: %@",[gamer location]);
    NSLog(@"Gamer createdAt: %ld",(long)[gamer createdAt]);
}
- (void)failedToRetrieveGamerProfile:(NSInteger)statusCode
                            withError:(NSError*) error
{
    NSLog(@"Gamer failed with error %ld %@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)successfullyStoredData:(id)storageKey
{
    NSLog(@"Successfully stored data %@", storageKey);
}
- (void)failedToStoreData:(NSInteger)statusCode
                withError:(NSError*)error
           withStorageKey:(NSString*)storageKey
                 withData:(NSDictionary*)data
{
    NSLog(@"failed to stored data with error %ld %@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)retrievedStoredData:(NSString*)storageKey withData:(NSDictionary*)data
{
    NSLog(@"Successfully retrieved stored data key=%@ data=%@", storageKey, data);
}

- (void)failedToRetrieveStoredData:(NSInteger)statusCode
                         withError:(NSError*)error
                    withStorageKey:(NSString*)storageKey
{
    NSLog(@"failed to retrieve stored data %ld key=%@ error=%@", (long)statusCode, storageKey, [error localizedRecoverySuggestion]);
}

- (void)successfullyDeletedData:(NSString*)storageKey
{
    NSLog(@"Successfully deleted data %@", storageKey);
}
- (void)failedToDeleteStoredData:(NSInteger)statusCode
                       withError:(NSError*)error
                  withStorageKey:(NSString*)storageKey
{
    NSLog(@"failed to delete stored data %ld key=%@ error=%@", (long)statusCode, storageKey, [error localizedRecoverySuggestion]);
}

- (void)retrievedGameAchievements:(NSArray*)achievements
{
    NSMutableString *value = [[NSMutableString alloc] initWithString:@""];
    for(id achievement in achievements) {
        [value appendString:[achievement name]];
        [value appendString:@"-"];
    }
    
    NSLog(@"Successfully retrieved game achievements %@", value);
}
- (void)failedToRetrieveGameAchievements:(NSInteger)statusCode
                               withError:(NSError *)error
{
    NSLog(@"Failed to retrieve game achievements %ld error=%@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)retrievedGamerAchievements:(NSArray*)gamerAchievements
{
    if ([gamerAchievements count] > 0) {
        [_dataHolder setAchievement:[gamerAchievements objectAtIndex:0]];
    }
    
    NSMutableString *value = [[NSMutableString alloc] initWithString:@""];
    for(id achievement in gamerAchievements) {
        [value appendString:[achievement name]];
        [value appendString:@"-"];
    }
    
    NSLog(@"Successfully retrieved game achievements %@", value);
}

- (void)failedToRetrieveGamerAchievements:(NSInteger)statusCode
                                withError:(NSError *)error
{
    NSLog(@"Failed to retrieve gamer achievements %ld error=%@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)successfullyUpdatedAchievement:(NSString*)achievementUid
{
    NSLog(@"Successfully updated gamer achievement with id %@", achievementUid);
}
- (void)failedToUpdateAchievement:(NSInteger)statusCode
                        withError:(NSError*)error
               withAchievementUid:(NSString*)achievementUid
{
    NSLog(@"Failed to update achievement data for %@ %ld error=%@", achievementUid, (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)retrievedLeaderboardData:(GULeaderboard*)leaderboard
{
    NSLog(@"Successfully retrieved leaderboard %@", [leaderboard name]);
}
- (void)failedToRetrieveLeaderboardData:(NSInteger)statusCode
                              withError:(NSError *)error
{
    NSLog(@"Failed to retrieve leaderboard %ld error=%@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)retrievedLeaderboardData:(GULeaderboard *)leaderboard andRank:(GULeaderboardRank*)leaderboardRank
{
    NSLog(@"Successfully retrieved leaderboard and rank %@ %ld", [leaderboard name], (long)[leaderboardRank rank]);
}
- (void)failedToRetrieveLeaderboardDataAndRank:(NSInteger)statusCode
                                     withError:(NSError *)error
{
    NSLog(@"Failed to retrieve leaderboard and rank %ld error=%@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)successfullyUpdatedLeaderboardRank:(NSString*)leaderboardId
{
    NSLog(@"Successfully updated leaderboard ranking %@", leaderboardId);
}
- (void)failedToUpdateLeaderboardRank:(NSInteger)statusCode
                            withError:(NSError*)error
                   withLeaderboardUid:(NSString*)leaderboardUid
{
    NSLog(@"Failed to update leaderboard ranking %ld error=%@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)retrievedMatches:(NSArray*)matches
{
    id m = [[NSMutableString alloc] initWithString:@""];
    for (GUMatch* match in matches) {
        [m appendString:match.matchId];
        [m appendString:@", "];
        
        _dataHolder.match = match;
    }
    
    NSLog(@"Match list: %@", m);
}
- (void)failedToRetrieveMatches:(NSInteger)statusCode
                      withError:(NSError*)error
{
    NSLog(@"Failed to get match list %ld error=%@", (long)statusCode, [error localizedRecoverySuggestion]);
}
- (void)retrievedMatch:(GUMatch*)match
           withMatchId:(NSString*)matchId
{
    id m = [[NSMutableString alloc] initWithString:@""];
    for (id gamer in match.gamers) {
        [m appendString:gamer];
        [m appendString:@", "];
    }
    NSLog(@"Match gamers: %@", m);
}
- (void)failedToRetrieveMatch:(NSString*)matchId
               withStatusCode:(NSInteger)statusCode
                    withError:(NSError*)error
{
    NSLog(@"Failed to get match list %ld error=%@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)retrievedTurn:(NSArray*)turns forMatch:(NSString*)matchId
{
    id m = [[NSMutableString alloc] initWithString:@""];
    for (GUMatchTurn* turn in turns) {
        [m appendString:turn.gamer];
        [m appendString:@", "];
        _dataHolder.turn = turn;
    }
    NSLog(@"Turn data %@ for match %@", m, matchId);
}
- (void)failedToRetrieveTurnData:(NSInteger)statusCode
                       withError:(NSError*)error
                        forMatch:(NSString*)matchId
{
    NSLog(@"Failed to get turns for match %@ - %ld %@", matchId, (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)successfullySubmittedTurnDataForMatch:(NSString*)matchId
{
    NSLog(@"Submitted turn data for match %@", matchId);
}

- (void)failedToSubmitTurn:(NSInteger)statusCode
                 withError:(NSError*)error
                  ForMatch:(NSString*)matchId
                  withData:(id)data
{
    NSLog(@"Failed to submit turns for match %@ - %ld %@", matchId, (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)createdNewMatch:(GUMatch*)match
{
    NSLog(@"Created new match %@", match.matchId);
    _dataHolder.match = match;
}
- (void)successfullyQueuedGamerForNewMatch
{
    NSLog(@"Queued gamer for a match");
}
- (void)failedToCreateMatch:(NSInteger)statusCode
                  withError:(NSError*)error
{
    NSLog(@"Failed to create match %ld %@", (long)statusCode, [error localizedRecoverySuggestion]);
}
- (void)SuccessfullyEndedMatch:(NSString*)matchId
{
    NSLog(@"Ended match %@", matchId);
}
- (void)failedToEndMatch:(NSInteger)statusCode
               withError:(NSError*)error
              forMatchId:(NSString*)matchId
{
    NSLog(@"Failed to end match %@ - %ld %@", matchId, (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)SuccessfullyLeftMatch:(NSString*)matchId
{
    NSLog(@"Left match %@", matchId);
}

- (void)failedToLeaveMatch:(NSInteger)statusCode
                 withError:(NSError*)error
                forMatchId:(NSString*)matchId
{
    NSLog(@"Failed to leave match %@ - %ld %@", matchId, (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)successfullyLoggedinWithSession:(GUSession*)session
{
    [_dataHolder setSession:session];
    
    NSLog(@"Successfully logged in with token: %@", [session getGamerToken]);
    
    [_viewController backToMainView];
    [_viewController setResultText:@"Successfully logged in. Gamer Token:"];
    [_viewController appendResultText:[session getGamerToken]];
}
- (void)failedToLoginWithError:(NSError*) error
{
    [_viewController backToMainView];
    
    [_viewController setResultText:@"Failed to login"];
    [_viewController appendResultText:[error localizedDescription]];
    NSLog(@"failed to login with error =%@", [error localizedDescription]);
}
- (void)loginCancelled
{
    [_viewController backToMainView];
    
    [_viewController setResultText:@"User cancelled login"];
}
@end
