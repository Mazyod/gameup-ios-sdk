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
 * Represents a gamer's detailed standing on a leaderboard.
 */
@interface GULeaderboardRank : NSObject <GUJSONSerialisableProtocol>

/** Nickname, suitable for public display. */
@property(readonly) NSString* name;

/** Most up to date rank. */
@property(readonly) NSInteger rank;

/** When the latest rank was calculated. */
@property(readonly) NSInteger rankAt;

/** The best score the gamer has entered on this leaderboard. */
@property(readonly) NSInteger score;

/** When the best score was recorded. */
@property(readonly) NSInteger scoreAt;

/**
 * If this data is in response to a leaderboard submission, and the score
 * submitted replaces the previous one, this field will contain that
 * previous value.
 */
@property(readonly) NSInteger lastScore;

/** When the previous score was submitted. */
@property(readonly) NSInteger lastScoreAt;

/** What the rank on this leaderboard was when it was previously checked. */
@property(readonly) NSInteger lastRank;

/** When the previous rank was calculated. */
@property(readonly) NSInteger lastRankAt;

/** The highest rank this gamer has ever had on this leaderboard. */
@property(readonly) NSInteger bestRank;

 /** When the highest rank was recorded. */
@property(readonly) NSInteger bestRankAt;

/**
 * @return true if this is the first time the current gamer appears on this
 *         leaderboard, false otherwise.
 */
-(BOOL)isNew;

/**
 * @return true if the response indicates the gamer has a new best score on
 *         this leaderboard, false otherwise.
 */
-(BOOL)isNewScore;

/**
 * @return true if the rank has changed since it was last checked,
 *         regardless if it's now higher or lower, false otherwise.
 */
-(BOOL)isNewRank;


/**
 * @return true if this response contains a new all-time best rank on this
 *         leaderboard, false otherwise.
 */
-(BOOL)isNewBestRank;

@end
