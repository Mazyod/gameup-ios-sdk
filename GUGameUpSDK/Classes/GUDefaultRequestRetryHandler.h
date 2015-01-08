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
#import "GURequestRetryHandlerProtocol.h"

/**
 Default naive implementation of GURequestRetryHandler. It will simply retry a request X number of times.
 Default number of times is 3 currently.
 */
@interface GUDefaultRequestRetryHandler : NSObject <GURequestRetryHandlerProtocol>

/** Inititate this retry handler with a maximum of 3 retries for a given request */
-(id)initWithDefaultRetryAttempts;

/** Inititate this retry handler with a maximum of the given retries for a given request */
-(id)initWithMaximumRetryAttempt:(NSInteger)retryAttempCount;

@end