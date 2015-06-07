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

#import "GUDefaultRequestRetryHandler.h"
#import "NSURLRequest+GUURLRequest.h"

@implementation GUDefaultRequestRetryHandler
{
    NSInteger maximumRetryAttemptCount;
}

-(id)initWithDefaultRetryAttempts
{
    return [self initWithMaximumRetryAttempt:3];
}

-(id)initWithMaximumRetryAttempt:(NSInteger)retryAttempCount
{
    self = [super init];
    if (self) {
        maximumRetryAttemptCount = retryAttempCount;
    }
    return self;
}

-(BOOL)shouldRetryRequest:(NSURLRequest*)request
{
    if ([[request getRetryAttemptCount] intValue] < maximumRetryAttemptCount) {
        [request incrementRetryAttempCount];
        return YES;
    }
    
    return NO;
}

-(void)requestSucceed:(NSURLRequest*)request {}
-(void)requestFailed:(NSURLRequest*)request {}
@end