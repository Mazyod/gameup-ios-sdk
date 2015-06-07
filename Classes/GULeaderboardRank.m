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

#import "GULeaderboardRank.h"

@implementation GULeaderboardRank

- (id)initWithDictionary:(NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        _name = [dictionary objectForKey:@"name"];
        _rank = [[dictionary objectForKey:@"rank"] integerValue];
        _rankAt = [[dictionary objectForKey:@"rank_at"] integerValue];
        _score = [[dictionary objectForKey:@"score"] integerValue];
        _scoreAt = [[dictionary objectForKey:@"score_at"] integerValue];
        _lastScore = [[dictionary objectForKey:@"last_score"] integerValue];
        _lastScoreAt = [[dictionary objectForKey:@"last_score_at"] integerValue];
        _lastRank = [[dictionary objectForKey:@"last_rank"] integerValue];
        _lastRankAt = [[dictionary objectForKey:@"last_rank_at"] integerValue];
        _bestRank = [[dictionary objectForKey:@"best_rank"] integerValue];
        _bestRankAt = [[dictionary objectForKey:@"best_rank_at"] integerValue];
    }
    return self;
}

-(BOOL)isNew
{
    return _lastRank == 0;
}
-(BOOL)isNewScore
{
    return _score != _lastScore;
}
-(BOOL)isNewRank
{
    return _rank != _lastRank;
}
-(BOOL)isNewBestRank
{
    return _rank == _bestRank && _rankAt == _bestRankAt;
}

- (NSDictionary*)toDictionary
{
    [NSException raise:@"Cannot be converted to NSDictionary" format:nil];
    return nil;
}
@end