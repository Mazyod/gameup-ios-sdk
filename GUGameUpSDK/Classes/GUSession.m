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

#import "GUSession.h"
#import "GUHttpClient.h"
#import "GUAchievementUpdate.h"
#import "GULeaderboardUpdate.h"

@implementation GUSession
{
    id<GURequestRetryHandlerProtocol> retryHandler;
    id<GUResponderProtocol> responseDelegate;
    NSString* apiKey;
    NSString* token;
}

- (id) initWithApiKey:(id)apikeyToUse
            withToken:(id)tokenToUse
        withResponder:(id<GUResponderProtocol>)responder
     withRetryHandler:(id<GURequestRetryHandlerProtocol>)handler
{
    self = [super init];
    if (self) {
        apiKey = apikeyToUse;
        token = tokenToUse;
        responseDelegate = responder;
        retryHandler = handler;
    }
    return self;
}

- (id)getGamerToken
{
    return token;
}

- (void)ping
{
    [self sendApiRequest:PING
           withUrlParams:@{}
              withMethod:@"HEAD"
              withEntity:@""];
}

- (void)retrieveGamerProfile
{
    [self sendApiRequest:GAMER
           withUrlParams:@{}
              withMethod:@"GET"
              withEntity:@""];
}

- (void)retrieveStoredDataWithKey:(NSString*)key
{
    [self sendApiRequest:STORAGE_GET
           withUrlParams:@{@":key": key}
              withMethod:@"GET"
              withEntity:@""];
}

- (void)storeData:(NSDictionary*)value WithKey:(NSString*)storageKey
{
    [self sendApiRequest:STORAGE_PUT
           withUrlParams:@{@":key": storageKey}
              withMethod:@"PUT"
              withEntity:value];
}

- (void)deleteStoredDataWithKey:(NSString*)key
{
    [self sendApiRequest:STORAGE_DELETE
           withUrlParams:@{@":key": key}
              withMethod:@"DELETE"
              withEntity:@""];
}

-(void)retrieveAllAchievementsWithProgress
{
    [self sendApiRequest:ACHIEVEMENTS_GAMER
           withUrlParams:@{}
              withMethod:@"GET"
              withEntity:@""];
}

-(void)updateAchievement:(GUAchievementUpdate*)achievementUpdate
{
    [self sendApiRequest:ACHIEVEMENT_POST
           withUrlParams:@{@":id": [achievementUpdate achievementId]}
              withMethod:@"POST"
              withEntity:[achievementUpdate toDictionary]];
}

-(void)retrieveLeaderboardDataAndRankWithLeaderboardId:(id)leaderboardId
{
    [self sendApiRequest:LEADERBOARD_GAMER
           withUrlParams:@{@":id": leaderboardId}
              withMethod:@"GET"
              withEntity:@""];
}

-(void)updateLeaderboardRank:(GULeaderboardUpdate*)update
{
    [self sendApiRequest:LEADERBOARD_POST
           withUrlParams:@{@":id": [update leaderboardId]}
              withMethod:@"POST"
              withEntity:[update toDictionary]];
}

-(void)retrieveMatches
{
    [self sendApiRequest:MATCH_GET_ALL
           withUrlParams:@{}
              withMethod:@"GET"
              withEntity:@""];
}
-(void)retrieveMatch:(NSString*) matchId
{
    [self sendApiRequest:MATCH_GET
           withUrlParams:@{@":id": matchId}
              withMethod:@"GET"
              withEntity:@""];
}
-(void)retrieveTurnData:(NSInteger) turnNumber forMatchWithId:(NSString*) matchId
{
    [self sendApiRequest:MATCH_TURN_GET
           withUrlParams:@{@":id": matchId, @":turn_id":[[NSNumber numberWithLong:turnNumber] stringValue]}
              withMethod:@"GET"
              withEntity:@""];
}
-(void)submitTurn:(NSInteger)turn withData:(NSString*)data toNextGamer:(NSString*)nextGamerNickname forMatch:(NSString*)matchId
{
    id submission = @{@"last_turn": [NSNumber numberWithLong:turn],
                      @"next_gamer": nextGamerNickname,
                      @"data": data};
    
    [self sendApiRequest:MATCH_TURN_POST
           withUrlParams:@{@":id": matchId}
              withMethod:@"POST"
              withEntity:submission];
}

-(void)createMatch:(NSInteger)requiredGamers
{
    [self sendApiRequest:MATCH_POST
           withUrlParams:@{}
              withMethod:@"POST"
              withEntity:@{@"players": [NSNumber numberWithLong:requiredGamers]}];
}

-(void)endMatchWithId:(NSString*)matchId
{
    [self sendApiRequest:MATCH_POST_ACTION
           withUrlParams:@{@":id": matchId}
              withMethod:@"POST"
              withEntity:@{@"action": @"end"}];
}

-(void)leaveMatchWithId:(NSString*)matchId
{
    [self sendApiRequest:MATCH_POST_ACTION
           withUrlParams:@{@":id": matchId}
              withMethod:@"POST"
              withEntity:@{@"action": @"leave"}];
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
                    withToken:token
                   withEntity:entity
                withResponder:responseDelegate
             withRetryHandler:retryHandler];
}



@end