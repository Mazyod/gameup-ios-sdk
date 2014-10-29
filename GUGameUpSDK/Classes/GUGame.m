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

#import "GUGame.h"

@implementation GUGame

@synthesize name = _name;
@synthesize description = _description;
@synthesize createdAt = _createdAt;
@synthesize updatedAt = _updatedAt;

- (id)initWithDictionary:(NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:@"name"];
        self.description = [dictionary objectForKey:@"description"];
        self.createdAt = [[dictionary objectForKey:@"created_at"] integerValue];
        self.updatedAt = [[dictionary objectForKey:@"updated_at"] integerValue];
    }
    return self;
}
- (NSDictionary*)toDictionary
{
    NSDictionary *dict = @{@"name" : self.name,
                    @"description" : self.description,
                    @"created_at" :  [NSString stringWithFormat: @"%d", (int)self.createdAt],
                    @"updated_at" : [NSString stringWithFormat: @"%d", (int)self.updatedAt]};
    
    return dict;
}
@end
