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
#import "GUGame.h"
#import "GUGamer.h"

@protocol GUResponderProtocol
@required
- (void)successfulPing;
- (void)failedPing:(NSInteger)statusCode
         withError:(NSError*) error;

- (void)retrievedGameData:(GUGame*)game;
- (void)failedToRetrievedGameData:(NSInteger)statusCode
                        withError:(NSError*) error;

- (void)retrievedGamerProfile:(GUGamer*)gamer;
- (void)failedToRetrievedGamerProfile:(NSInteger)statusCode
                            withError:(NSError*) error;

- (void)successfullyStoredData:(id)storageKey;
- (void)failedtoStoreData:(NSInteger)statusCode
                withError:(NSError*)error
           withStorageKey:(NSString*)storageKey
                 withData:(NSDictionary*)data;

- (void)retrievedStoredData:(NSString*)storageKey withData:(NSDictionary*)data;
- (void)failedtoRetrieveStoredData:(NSInteger)statusCode
                         withError:(NSError*)error
                    withStorageKey:(NSString*)storageKey;

- (void)successfullyDeletedData:(NSString*)storageKey;
- (void)failedtoDeleteStoredData:(NSInteger)statusCode
                       withError:(NSError*)error
                  withStorageKey:(NSString*)storageKey
                        withData:(NSDictionary*)data;

- (void)successfullyLoggedinWithGamerToken:(NSString*)gamerToken;
- (void)failedToLoginWithError:(NSError*) error;
- (void)loginCancelled;

@end
