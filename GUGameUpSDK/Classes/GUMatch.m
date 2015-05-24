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

#import "GUMatch.h"

@implementation GUMatch

- (id)initWithDictionary:(NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        _whoami = [dictionary valueForKey:@"whoami"];
        _matchId = [dictionary valueForKey:@"match_id"];
        _turn_count = [[dictionary valueForKey:@"turn_count"] integerValue];
        _turn = [dictionary valueForKey:@"turn"];
        _createdAt = [[dictionary valueForKey:@"created_at"] integerValue];
        _active = [[dictionary valueForKey:@"active"] boolValue];
        _gamers = [dictionary valueForKey:@"gamers"];
    }
    return self;
}
- (NSDictionary*)toDictionary
{
    [NSException raise:@"Cannot be converted to NSDictionary" format:nil];
    return nil;
}
@end