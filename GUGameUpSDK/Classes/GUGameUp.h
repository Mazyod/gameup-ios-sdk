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

#import <Foundation/Foundation.h>
#import <GUResponderProtocol.h>
#import <GULoginViewController.h>

@interface GUGameUp : NSObject

-(id)initWithResponder:(id<GUResponderProtocol>)responder;

-(void)ping:(NSString*)apiKey;

-(void)ping:(id)apiKey withToken:(id)token;

-(void)requestToGetGameDetails:(id)apiKey;

-(void)requestToGetGamerProfile:(id)apiKey withToken:(id)token;

-(void)requestToGetStoredData:(id)apiKey withToken:(id)token storedWithKey:(NSString*)storageKey;

-(void)requestToStoreData:(id)apiKey withToken:(id)token storeWithKey:(NSString*)storageKey withValue:(NSDictionary*)value;

-(void)requestToDeleteStoredData:(id)apiKey withToken:(id)token storedWithKey:(NSString*)storageKey;

-(UIViewController*)requestSocialLogin:(id)apiKey;
@end
