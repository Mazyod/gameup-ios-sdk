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

#import "GUDemoResponderDelegate.h"
#import "GUAppDelegate.h"

@implementation GUDemoResponderDelegate

- (void)successfulPing
{
    NSLog(@"Ping successful!!");
    [_viewController setResultText:@"Ping Successful!"];
}
- (void)failedPing:(NSInteger)statusCode
         withError:(NSError*) error
{
    NSLog(@"Ping failed with error %@", error);
    [_viewController setResultText:@"Ping failed: \n"];
    [_viewController appendResultText:[error localizedDescription]];
}

- (void)retrievedGameData:(GUGame*)game
{
    [_viewController setResultText:@"Retrieved details: \n"];

    [self printDictionary:[game toDictionary]];
    
    NSLog(@"Game Name: %@",[game name]);
    NSLog(@"Game Description: %@",[game description]);
    NSLog(@"Game CreatedAt: %ld",[game createdAt]);
    NSLog(@"Game UpdatedAt: %ld",[game updatedAt]);
}
- (void)failedToRetrievedGameData:(NSInteger)statusCode
                        withError:(NSError*) error
{
    
    [_viewController setResultText:@"Game retrieval failed: \n"];
    [_viewController appendResultText:[error localizedDescription]];

    NSLog(@"Game failed with error %ld %@", statusCode, error);
}

- (void)retrievedGamerProfile:(GUGamer*)gamer
{
    [_viewController setResultText:@"Retrieved gamer profile: \n"];
    
    [self printDictionary:[gamer toDictionary]];
    
    NSLog(@"\n\nGamer Nick Name: %@",[gamer nickname]);
    NSLog(@"Gamer Given Name: %@",[gamer givenName]);
    NSLog(@"Gamer Family Name: %@",[gamer familyName]);
    NSLog(@"Gamer timezone: %@",[gamer timezone]);
    NSLog(@"Gamer location: %@",[gamer location]);
    NSLog(@"Gamer createdAt: %ld",[gamer createdAt]);
}
- (void)failedToRetrievedGamerProfile:(NSInteger)statusCode
                            withError:(NSError*) error
{
    
    [_viewController setResultText:@"Game profile retrieval failed: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    
    NSLog(@"Gamer failed with error %ld %@", statusCode, [error localizedRecoverySuggestion]);
}

- (void)successfullyStoredData:(id)storageKey
{
    [_viewController setResultText:@"Successfully stored data at "];
    [_viewController appendResultText:storageKey];

    NSLog(@"Successfully stored data %@", storageKey);
}
- (void)failedtoStoreData:(NSInteger)statusCode
                withError:(NSError*)error
           withStorageKey:(NSString*)storageKey
                 withData:(NSDictionary*)data
{
    
    [_viewController setResultText:@"Failed to store data: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    
    NSLog(@"failed to stored data with error %ld %@", statusCode, [error localizedRecoverySuggestion]);
}

- (void)retrievedStoredData:(NSString*)storageKey withData:(NSDictionary*)data
{
    [_viewController setResultText:@"Retrieved data at "];
    [_viewController appendResultText:storageKey];
    [_viewController appendResultText:@"\n"];
    
    [self printDictionary:data];
    
    NSLog(@"Successfully retrieved stored data key=%@ data=%@", storageKey, data);
}

- (void)failedtoRetrieveStoredData:(NSInteger)statusCode
                         withError:(NSError*)error
                    withStorageKey:(NSString*)storageKey
{
    [_viewController setResultText:@"Failed to retrieve stored data: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    
    NSLog(@"failed to retrieve stored data %ld key=%@ error=%@", statusCode, storageKey, [error localizedRecoverySuggestion]);
}

- (void)successfullyDeletedData:(NSString*)storageKey
{
    [_viewController setResultText:@"Successfully deleted data at "];
    [_viewController appendResultText:storageKey];
    
    NSLog(@"Successfully deleted data %@", storageKey);
}
- (void)failedtoDeleteStoredData:(NSInteger)statusCode
                       withError:(NSError*)error
                  withStorageKey:(NSString*)storageKey
                        withData:(NSDictionary*)data
{
    [_viewController setResultText:@"Failed to deleted stored data: \n"];
    [_viewController appendResultText:[error localizedDescription]];
    
    NSLog(@"failed to delete stored data %ld key=%@ data=%@ error=%@", statusCode, storageKey, data, [error localizedRecoverySuggestion]);
}

- (void)printDictionary:(NSDictionary*) data
{
    [_viewController appendResultText:@"!!Only showing NSString values"];
    
    for(id key in data) {
        NSMutableString *value = [[NSMutableString alloc] initWithString:key];
        [value appendString:@"="];
        id dicValue = [data objectForKey:key];
        if ([dicValue isKindOfClass:[NSString class]]) {
            [value appendString:dicValue];
            [_viewController appendResultText:value];
        }
    }
}

- (void)successfullyLoggedinWithGamerToken:(NSString*)gamerToken
{
    [_dataHolder setGamerToken:gamerToken];
    
    NSLog(@"Successfully logged in with token: %@", gamerToken);
    
    [_viewController backToMainView];
    [_viewController enableLoginDependantButtons];
    [_viewController appendResultText:@"Successfully logged in. Gamer Token:"];
    [_viewController appendResultText:gamerToken];
}
- (void)failedToLoginWithError:(NSError*) error
{
    [_viewController backToMainView];
    
    [_viewController appendResultText:@"Failed to logged in"];
    [_viewController appendResultText:[error localizedDescription]];
    NSLog(@"failed to login with error =%@", [error localizedDescription]);
}
- (void)loginCancelled
{
    [_viewController backToMainView];
    
    [_viewController appendResultText:@"User cancelled login"];
}
@end
