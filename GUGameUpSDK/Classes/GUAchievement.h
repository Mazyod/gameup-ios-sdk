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
 Represents an achievement's data, also contains gamer progress if applicable.
 */
@interface GUAchievement : NSObject <GUJSONSerialisableProtocol>

/**
 Achievement Type, referring to how gamer interaction must occur.
 */
typedef NS_ENUM(NSInteger, GUAchievementType)
{
    /** Standard earned/unearned achievement. */
    NORMAL,
    /**
     Incremental achievement, requiring some number of actions before it
     is awarded, subject to game logic.
     */
    INCREMENTAL
};

/**
 * Achievement State, referring to how display should be handled.
 */
typedef NS_ENUM(NSInteger, GUAchievementState)
{
    /** The achievement and all its details are available to the gamer. */
    VISIBLE,
    /**
     The name and description are replaced with "???", unless the gamer
     has completed the achievement.
     */
    SECRET,
    /**
     The achievement does not appear at all, unless the gamer has
     completed the achievement.
     */
    HIDDEN
};

/** Game-unique public identifier for this achievement. */
@property(readonly) NSString* publicId;

/** Achievement description or instructions. */
@property(readonly) NSString* desc;

/** Achievement name. */
@property(readonly) NSString* name;

/** The type of the achievement, referring to gamer interaction model. */
@property(readonly) GUAchievementType type;

/**
 Number of points that will be awarded for completing this achievement,
 or have already been awarded if it is already complete.
 */
@property(readonly) NSInteger points;

/** The state of this achievement, referring to display logic. */
@property(readonly) GUAchievementState state;

/**
 Required number of actions to complete this achievement, subject to game
 logic. For "normal"-type achievements this will always be 1.
 */
@property(readonly) NSInteger requiredCount;

/**
 UTC timestamp in milliseconds when the gamer last made any progress
 towards this achievement, or 0 if no progress ever.
 */
@property(readonly) NSInteger progressAt;

/**
 UTC timestamp in milliseconds when the gamer completed this achievement,
 or 0 if it has not yet been completed.
 */
@property(readonly) NSInteger completedAt;

/**
 Current gamer progress towards the required count of this achievement,
 subject to the same game logic as the requiredCount field.
 */
@property(readonly) NSInteger count;

/**
 @return true if the gamer has completed this achievement,
         false otherwise.
 */
- (BOOL)isAchievementUnlocked;

@end

