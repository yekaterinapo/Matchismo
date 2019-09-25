//
//  PlayingCard.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize rank = _rank;
@synthesize suit = _suit;

- (NSAttributedString *) contents {
  return [[NSAttributedString alloc] initWithString: [self.suit stringByAppendingString: [PlayingCard RankStrings][self.rank]] ];
}

+ (NSArray *) RankStrings {
  return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7",
           @"8", @"9", @"J", @"Q", @"K"];
  //return @[@"?", @"A"];
  
}

+ (NSArray *) SuitStrings {
  return @[@"♠", @"♥", @"♦", @"♣"];
}

- (void) setRank:(NSUInteger) rank {
  if (rank>0 && rank <= [PlayingCard maxRank]) {
    _rank = rank;
    self.contents = [[NSAttributedString alloc] initWithString: [[PlayingCard RankStrings][rank] stringByAppendingString: self.suit]];
  }
}

- (NSString*) suit {
  if (!_suit) {
    _suit = @"";
  }
  return _suit;
}

- (void) setSuit: (NSString*) suit {
  if ([[PlayingCard SuitStrings] containsObject:suit]) {
    _suit = suit;
    NSString *s = [[PlayingCard RankStrings][self.rank] stringByAppendingString: suit];
    self.contents =[[NSAttributedString alloc] initWithString:s];
  }
}

+ (NSUInteger) maxRank {
  return [[PlayingCard RankStrings] count] - 1;
}

- (int) MatcheScore: (NSArray*) otherCards {
  
  for (PlayingCard* otherCard in otherCards) {
    if ([otherCard.suit isEqualToString:self.suit]) {
      return 1;
    }
    else if (otherCard.rank == self.rank) {
      return 4;
    }
  }
  return 0;
}

@end
