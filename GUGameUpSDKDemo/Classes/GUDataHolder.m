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

#import "GUDataHolder.h"

@implementation GUDataHolder
-(id) init
{
    self = [super init];
    if (self) {
        
        _apiKey = @"6fb004d4289748199cb858ab0905f657";
        //for demo purposes, let's hardcode the storage key!
        _storageKey = @"profile_info";
        // we need to hardcode the Achievement Uid
        _achievementUids = [NSArray arrayWithObjects:
                            @"68d84ecd7c804f9ead0337cfc2babe63", // visible, 10, normal
                           @"70c99a8e6dff4a6fac7e517a8dd4e83f", // visible, 10, incremental (10)
                           @"ed8b639a8ab74aedaa0de7d182ca9175", // secret, 10, normal
                           @"468044087b5d45f2839e18537b4ddbe7", // hidden, 10, normal
                           nil];
    }
    return self;
}
@end
