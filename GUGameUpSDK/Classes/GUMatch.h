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
#import "GUJSONSerialisableProtocol.h"

/**
 Represents a response containing GameUp Multiplayer Match with its metadata.
 */
@interface GUMatch : NSObject <GUJSONSerialisableProtocol>

/** 
 Nickname set for the current gamer in this given match
 If the current gamer's nickname is changed after the match is setup, 
 the old nickname is still used hence the use of this 'whoami' field.
 */
@property(readonly) NSString* whoami;

/** Match ID */
@property(readonly) NSString* matchId;

/** Current turn number */
@property(readonly) NSInteger turn_count;

/** Name of gamer for the given turn */
@property(readonly) NSString* turn;

/** Nickname of all the gamers in the current match */
@property(readonly) NSArray* gamers;

/** When the match was created */
@property(readonly) NSInteger createdAt;

/** Checks to see if the match is still ongoing or has ended. */
@property(readonly) BOOL active;

@end