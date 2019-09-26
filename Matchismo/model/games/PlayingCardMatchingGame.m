//
//  PlayingCardMatchingGame.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 11/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "PlayingCardMatchingGame.h"
#import "../cards/PlayingCard.h"

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;

@implementation PlayingCardMatchingGame

- (NSInteger) matchScore: (NSArray*) cards {
  NSInteger score = 0;
  for (PlayingCard* card1 in cards) {
    for (PlayingCard* card2 in cards) {
      if ([cards indexOfObject:card1 ] == [cards indexOfObject:card2]) {
        continue;
      }
      else {
        score += MATCH_BONUS*[card1 MatcheScore:@[card2]];
      }
    }
  }
  // we counted all pairs twice
  score = score/2;
  if (score == 0) {
    score-=MISMATCH_PENALTY;
  }
  return score;
}

@end

