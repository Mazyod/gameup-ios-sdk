/*
 * Copyright 2014-2015 GameUp
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>
#import "GUJSONSerialisableProtocol.h"

/**
 Represents a Leadeboard update request 
*/
@interface GULeaderboardUpdate : NSObject <GUJSONSerialisableProtocol>

/** 
  Create and inititiate a new leaderboard update request with a given score
 */
- (id)initWithLeaderboardUid:(NSString*)leaderboardUid andScore:(NSInteger)score;

/** Leaderboard identifier. */
@property(readwrite) NSString* leaderboardId;

/** Score to be recorded  */
@property(readwrite) NSInteger score;

@end
