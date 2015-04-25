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

static NSString *const GAMEUP_LOGIN_URL = @"https://accounts.gameup.io";
static NSString *const GAMEUP_API_URL = @"https://api.gameup.io";

typedef NS_ENUM(NSInteger, GURequestType)
{
    PING,
    SERVER,
    GAME,
    GAMER,
    STORAGE_PUT,
    STORAGE_GET,
    STORAGE_DELETE,
    ACHIEVEMENTS_GAME,
    ACHIEVEMENTS_GAMER,
    ACHIEVEMENT_POST,
    LEADERBOARD_GAME,
    LEADERBOARD_GAMER,
    LEADERBOARD_POST,
    LOGIN
};

@interface GUHttpClient : NSObject

+ (id) USER_AGENT;
+ (id) REQUEST_URLS;

+ (void)sendLoginRequest:(NSString*)provider
              withApiKey:(NSString*)apikeyToUse
         withAccessToken:(NSString*)accessToken
               withToken:(NSString*)token
           withResponder:(id<GUResponderProtocol>)responder
        withRetryHandler:(id<GURequestRetryHandlerProtocol>)handler;

+ (void)sendRequest:(NSString*)to
       withEndpoint:(enum GURequestType)endpoint
withAppendedUrlPath:(NSString*)appendedUrlPath
         withMethod:(NSString*)method
         withApiKey:(NSString*)apikeyToUse
          withToken:(NSString*)token
         withEntity:(id)entity
      withResponder:(id<GUResponderProtocol>)responder
   withRetryHandler:(id<GURequestRetryHandlerProtocol>)handler;

@end