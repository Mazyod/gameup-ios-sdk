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

#import "GUAchievement.h"

@implementation GUAchievement

- (id)initWithDictionary:(NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        _publicId = [dictionary valueForKey:@"public_id"];
        _name = [dictionary valueForKey:@"name"];
        _desc = [dictionary valueForKey:@"description"];
        _points = (int)[dictionary valueForKey:@"points"];
        _requiredCount = (int)[dictionary valueForKey:@"required_count"];
        _count = 0;
        if ([dictionary valueForKey:@"count"]) {
            _count = (int) [dictionary valueForKey:@"count"];
        }
        
        _type = NORMAL;
        if ([@"incremental" isEqualToString:[dictionary valueForKey:@"type"]]) {
            _type = INCREMENTAL;
        }
        _state = VISIBLE;
        if ([@"hidden" isEqualToString:[dictionary valueForKey:@"state"]]) {
            _state = HIDDEN;
        } else if ([@"secret" isEqualToString:[dictionary valueForKey:@"state"]]) {
            _state = SECRET;
        }
        
        if ([dictionary valueForKey:@"completed_at"]) {
            _completedAt = (int) [dictionary valueForKey:@"completed_at"];
        }
        if ([dictionary valueForKey:@"progress_at"]) {
            _progressAt = (int) [dictionary valueForKey:@"progress_at"];
        }
    }
    return self;
}

- (NSDictionary*)toDictionary
{
    [NSException raise:@"Cannot be converted to NSDictionary" format:nil];
    return nil;
}

- (BOOL)isAchievementUnlocked
{
    return (_completedAt || _completedAt > 0);
}
@end
