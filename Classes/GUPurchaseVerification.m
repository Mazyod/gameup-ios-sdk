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

#import "GUPurchaseVerification.h"

@implementation GUPurchaseVerification

- (id)initWithDictionary:(NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        _success = [[dictionary objectForKey:@"success"] boolValue];
        _seenBefore = [[dictionary objectForKey:@"seen_before"] boolValue];
        _message = [dictionary objectForKey:@"message"];
        _data = [dictionary objectForKey:@"data"];
    }
    return self;
}
- (NSDictionary*)toDictionary
{
    [NSException raise:@"Cannot be converted to NSDictionary" format:nil];
    return nil;
}
@end
