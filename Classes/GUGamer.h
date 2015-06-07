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
 Represents a gamer in the GameUp service.
 */
@interface GUGamer : NSObject <GUJSONSerialisableProtocol>

/** Nickname, intended for easy public display. */
@property(readonly) NSString* nickname;

/** Gamer Name. */
@property(readonly) NSString* name;

/** Time zone of the gamer. */
@property(readonly) NSString* timezone;

/** Location of the gamer. */
@property(readonly) NSString* location;

/** When the gamer first registered with GameUp. */
@property(readonly) NSInteger createdAt;

@end
