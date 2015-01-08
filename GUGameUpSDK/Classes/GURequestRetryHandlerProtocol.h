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

/**
 Protocol to setup a HTTP RequestRetryHandler. Retry Handlers are invoked when the server returns a 500 Error.
 Retry Handlers must manage the state of the request and attempt numbers.
 */
@protocol GURequestRetryHandlerProtocol
@required

/** 
 Whether the given request should be retried or not
 @returns True if this request to be retried,
          false otherwise
 */
-(BOOL)shouldRetryRequest:(NSURLRequest*)request;

/**
 Callback when the given request has successed (success is any HTTP status code < 500)
 */
-(void)requestSucceed:(NSURLRequest*)request;

/**
 Callback when the given request has failed (failure is any HTTP status code >= 500)
 */
-(void)requestFailed:(NSURLRequest*)request;
@end
