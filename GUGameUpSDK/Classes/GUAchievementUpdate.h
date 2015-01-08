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
#import "GUJSONSerialisableProtocol.h"

/**
 Represents an achievement update request 
*/
@interface GUAchievementUpdate : NSObject <GUJSONSerialisableProtocol>

/** 
  Create and inititiate a new achievement update request to unlock a normal achievement
 
  Progress will be "1". This method is intended for convenience when
  triggering "normal"-type achievements, but will still add 1 to an
  "incremental"-type achievement if needed.
 */
- (id)initToUnlockAchievementUid:(NSString*)achievementUid;

/** Create and inititiate a new achievement update request with the achievement ID and the count */
- (id)initWithAchievementUid:(NSString*)achievementUid andCount:(NSInteger)count;

/** Achievement ID of this achievement update request */
@property(readwrite) NSString* achievementId;

/** Count held in this achievement update request */
@property(readwrite) NSInteger count;

@end
