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
#import "GUAppDelegate.h"
#import "GUAchievement.h"
#import "GUAchievementUpdate.h"
#import "GULeaderboard.h"
#import "GULeaderboardRank.h"
#import "GULeaderboardUpdate.h"

@implementation GUDemoResponderDelegate

- (void)printDictionary:(NSDictionary*) data
{
    [_viewController appendResultText:@"!!Only showing NSString values"];
    
    for(id key in data) {
        NSMutableString *value = [[NSMutableString alloc] initWithString:key];
        [value appendString:@"="];
        id dicValue = [data objectForKey:key];
        if ([dicValue isKindOfClass:[NSString class]]) {
            [value appendString:dicValue];
            [_viewController appendResultText:value];
        }
    }
}

- (void)successfulPing
{
    NSLog(@"Ping successful!!");
    [_viewController setResultText:@"Ping Successful!"];
}
- (void)failedPing:(NSInteger)statusCode
         withError:(NSError*) error
{
    NSLog(@"Ping failed with error %@", error);
    [_viewController setResultText:@"Ping failed: \n"];
    [_viewController appendResultText:[error localizedDescription]];
}

- (void)retrievedServerData:(GUServer*)serverData
{
    NSString *inStr = [NSString stringWithFormat: @"Server Time: %ld", (long)[serverData time]];
    [_viewController setResultText:inStr];
}
- (void)failedToRetrieveServerData:(NSInteger)statusCode
                          withError:(NSError*) error
{
    NSLog(@"ServerTime failed with error %@", error);
    [_viewController setResultText:@"ServerTime failed: \n"];
    [_viewController appendResultText:[error localizedDescription]];
}


- (void)retrievedGameData:(GUGame*)game
{
    [_viewController setResultText:@"Retrieved details: \n"];
    
    NSLog(@"Game Name: %@",[game name]);
    NSLog(@"Game Description: %@",[game description]);
    NSLog(@"Game CreatedAt: %ld",(long)[game createdAt]);
    NSLog(@"Game UpdatedAt: %ld",(long)[game updatedAt]);
}
- (void)failedToRetrieveGameData:(NSInteger)statusCode
                        withError:(NSError*) error
{
    
    [_viewController setResultText:@"Game retrieval failed: \n"];
    [_viewController appendResultText:[error localizedDescription]];

    NSLog(@"Game failed with error %ld %@", (long)statusCode, error);
}

- (void)retrievedGamerProfile:(GUGamer*)gamer
{
    [_viewController setResultText:@"Retrieved gamer profile: \n"];
    
    NSLog(@"\n\nGamer Nick Name: %@",[gamer nickname]);
    NSLog(@"Gamer Given Name: %@",[gamer givenName]);
    NSLog(@"Gamer Family Name: %@",[gamer familyName]);
    NSLog(@"Gamer timezone: %@",[gamer timezone]);
    NSLog(@"Gamer location: %@",[gamer location]);
    NSLog(@"Gamer createdAt: %ld",(long)[gamer createdAt]);
}
- (void)failedToRetrieveGamerProfile:(NSInteger)statusCode
                            withError:(NSError*) error
{
    
    [_viewController setResultText:@"Game profile retrieval failed: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    
    NSLog(@"Gamer failed with error %ld %@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)successfullyStoredData:(id)storageKey
{
    [_viewController setResultText:@"Successfully stored data at "];
    [_viewController appendResultText:storageKey];

    NSLog(@"Successfully stored data %@", storageKey);
}
- (void)failedToStoreData:(NSInteger)statusCode
                withError:(NSError*)error
           withStorageKey:(NSString*)storageKey
                 withData:(NSDictionary*)data
{
    
    [_viewController setResultText:@"Failed to store data: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    
    NSLog(@"failed to stored data with error %ld %@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)retrievedStoredData:(NSString*)storageKey withData:(NSDictionary*)data
{
    [_viewController setResultText:@"Retrieved data at "];
    [_viewController appendResultText:storageKey];
    [_viewController appendResultText:@"\n"];
    
    [self printDictionary:data];
    
    NSLog(@"Successfully retrieved stored data key=%@ data=%@", storageKey, data);
}

- (void)failedToRetrieveStoredData:(NSInteger)statusCode
                         withError:(NSError*)error
                    withStorageKey:(NSString*)storageKey
{
    [_viewController setResultText:@"Failed to retrieve stored data: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    
    NSLog(@"failed to retrieve stored data %ld key=%@ error=%@", (long)statusCode, storageKey, [error localizedRecoverySuggestion]);
}

- (void)successfullyDeletedData:(NSString*)storageKey
{
    [_viewController setResultText:@"Successfully deleted data at "];
    [_viewController appendResultText:storageKey];
    
    NSLog(@"Successfully deleted data %@", storageKey);
}
- (void)failedToDeleteStoredData:(NSInteger)statusCode
                       withError:(NSError*)error
                  withStorageKey:(NSString*)storageKey
{
    [_viewController setResultText:@"Failed to deleted stored data: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    
    NSLog(@"failed to delete stored data %ld key=%@ error=%@", (long)statusCode, storageKey, [error localizedRecoverySuggestion]);
}

- (void)retrievedGameAchievements:(NSArray*)achievements
{
    [_viewController setResultText:@"!!Only showing Game Achievement Names"];
    NSMutableString *value = [[NSMutableString alloc] initWithString:@""];
    for(id achievement in achievements) {
        [value appendString:[achievement name]];
        [value appendString:@"-"];
    }
    
    [_viewController appendResultText:value];
    NSLog(@"Successfully retrieved game achievements %@", value);
}
- (void)failedToRetrieveGameAchievements:(NSInteger)statusCode
                               withError:(NSError *)error
{
    [_viewController setResultText:@"Failed to retrieve game achievements: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    NSLog(@"Failed to retrieve game achievements %ld error=%@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)retrievedGamerAchievements:(NSArray*)gamerAchievements
{
    if ([gamerAchievements count] > 0) {
        [_dataHolder setAchievement:[gamerAchievements objectAtIndex:0]];
    }
    
    [_viewController setResultText:@"!!Only showing Gamer Achievement Names"];
    NSMutableString *value = [[NSMutableString alloc] initWithString:@""];
    for(id achievement in gamerAchievements) {
        [value appendString:[achievement name]];
        [value appendString:@"-"];
    }
    
    [_viewController appendResultText:value];
    NSLog(@"Successfully retrieved game achievements %@", value);
    
}
- (void)failedToRetrieveGamerAchievements:(NSInteger)statusCode
                                withError:(NSError *)error
{
    [_viewController setResultText:@"Failed to retrieve gamer achievements: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    NSLog(@"Failed to retrieve gamer achievements %ld error=%@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)successfullyUpdatedAchievement:(NSString*)achievementUid
{
    [_viewController setResultText:@"!!Updated achievement with ID "];
    [_viewController appendResultText:achievementUid];
    NSLog(@"Successfully updated gamer achievement with id %@", achievementUid);
}
- (void)failedToUpdateAchievement:(NSInteger)statusCode
                        withError:(NSError*)error
               withAchievementUid:(NSString*)achievementUid
{
    [_viewController setResultText:@"Failed to update achievement data with id:"];
    [_viewController appendResultText:achievementUid];
    [_viewController appendResultText:@"\n"];
    [_viewController appendResultText:[error localizedDescription]];
    NSLog(@"Failed to update achievement data for %@ %ld error=%@", achievementUid, (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)retrievedLeaderboardData:(GULeaderboard*)leaderboard
{
    [_viewController setResultText:@"Successfully retrieved leaderboard"];
    [_viewController appendResultText:[leaderboard name]];
    [_viewController appendResultText:@"\n"];
    NSLog(@"Successfully retrieved leaderboard %@", [leaderboard name]);
}
- (void)failedToRetrieveLeaderboardData:(NSInteger)statusCode
                              withError:(NSError *)error
{
    [_viewController setResultText:@"Failed to retrieve leaderboard: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    NSLog(@"Failed to retrieve leaderboard %ld error=%@", (long)statusCode, [error localizedRecoverySuggestion]);

}

- (void)retrievedLeaderboardData:(GULeaderboard *)leaderboard andRank:(GULeaderboardRank*)leaderboardRank
{
    [_viewController setResultText:@"Successfully retrieved leaderboard and rank"];
    [_viewController appendResultText:[leaderboard name]];
    [_viewController appendResultText:@"\n"];
    [_viewController appendResultText:@"current rank: \n"];
    [_viewController appendResultText:[@([leaderboardRank rank]) stringValue]];
    [_viewController appendResultText:@" @ : \n"];
    [_viewController appendResultText:[@([leaderboardRank rankAt]) stringValue]];
    NSLog(@"Successfully retrieved leaderboard and rank %@ %ld", [leaderboard name], (long)[leaderboardRank rank]);
}
- (void)failedToRetrieveLeaderboardDataAndRank:(NSInteger)statusCode
                                     withError:(NSError *)error
{
    [_viewController setResultText:@"Failed to retrieve leaderboard and rank: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    NSLog(@"Failed to retrieve leaderboard and rank %ld error=%@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)successfullyUpdatedLeaderboardRank:(NSString*)leaderboardId
{
    [_viewController setResultText:@"Successfully updated leaderboard ranking"];
    [_viewController appendResultText:leaderboardId];
    NSLog(@"Successfully updated leaderboard ranking %@", leaderboardId);

}
- (void)failedToUpdateLeaderboardRank:(NSInteger)statusCode
                            withError:(NSError*)error
                   withLeaderboardUid:(NSString*)leaderboardUid
{
    [_viewController setResultText:@"Failed to update leaderboard ranking: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    NSLog(@"Failed to update leaderboard ranking %ld error=%@", (long)statusCode, [error localizedRecoverySuggestion]);
}

- (void)successfullyLoggedinWithGamerToken:(NSString*)gamerToken
{
    [_dataHolder setGamerToken:gamerToken];
    
    NSLog(@"Successfully logged in with token: %@", gamerToken);
    
    [_viewController backToMainView];
    [_viewController setResultText:@"Successfully logged in. Gamer Token:"];
    [_viewController appendResultText:gamerToken];
}
- (void)failedToLoginWithError:(NSError*) error
{
    [_viewController backToMainView];
    
    [_viewController setResultText:@"Failed to logged in"];
    [_viewController appendResultText:[error localizedDescription]];
    NSLog(@"failed to login with error =%@", [error localizedDescription]);
}
- (void)loginCancelled
{
    [_viewController backToMainView];
    
    [_viewController setResultText:@"User cancelled login"];
}
@end
