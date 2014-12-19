/*
 * Copyright 2014 GameUp
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

#import "GUGamer.h"

@implementation GUGamer
- (id)initWithDictionary:(NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        _nickname = [dictionary objectForKey:@"nickname"];
        _givenName = [dictionary objectForKey:@"given_name"];
        _familyName = [dictionary objectForKey:@"family_name"];
        _timezone = [dictionary objectForKey:@"timezone"];
        _location = [dictionary objectForKey:@"location"];
        _createdAt = [[dictionary objectForKey:@"created_at"] integerValue];
        
        if (_timezone == nil)
            _timezone = @"";
        if (_location == nil)
            _location = @"";
    }
    return self;
}
- (NSDictionary*)toDictionary
{
    [NSException raise:@"Cannot be converted to NSDictionary" format:nil];
    return nil;
}
@end
