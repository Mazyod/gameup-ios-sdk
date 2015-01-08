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

#import "GUAchievementUpdate.h"

@implementation GUAchievementUpdate

- (id)initToUnlockAchievementUid:(NSString*)achievementUid
{
    return [self initWithAchievementUid:achievementUid andCount:1];
}

- (id)initWithAchievementUid:(NSString*) achievementId andCount:(NSInteger)count
{
    self = [super init];
    if (self) {
        _achievementId = achievementId;
        _count = count;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*) dictionary
{
    [NSException raise:@"Cannot instantiate using NSDictionary" format:nil];
    return nil;
}

- (NSDictionary*)toDictionary
{
    return @{@"count" : [NSNumber numberWithInt:(int)_count]};
}

@end
