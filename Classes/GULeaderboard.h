/*
 * Copyright 2014-2015 GameUp
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
#import "GUJSONSerialisableProtocol.h"

/**
 Represents a Leaderboards' metadata with leaderboard enteries.
 */
@interface GULeaderboard : NSObject <GUJSONSerialisableProtocol>

typedef NS_ENUM(NSInteger, GULeaderboardSort)
{
    ASCENDING,
    DESCENDING
};

typedef NS_ENUM(NSInteger, GULeaderboardType)
{
    RANKING
};

/** Leaderboard display name. */
@property(readwrite) NSString* name;

/** Leaderboard public identifier. */
@property(readwrite) NSString* publicId;

/** Sort order indicator. */
@property(readwrite) GULeaderboardSort sort;

/** Type indicator. */
@property(readwrite) GULeaderboardType type;

/**
 * The top ranked gamers on this board, up to 50. Already sorted according
 * to the leaderboard sort settings.
 *
 * @warning array containing GULeaderboardEntry objects
 */
@property(readwrite) NSArray* entries;

@end
