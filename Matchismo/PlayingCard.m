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

- (NSAttributedString *)contents {
  return [[NSAttributedString alloc] initWithString: [self.suit stringByAppendingString: [PlayingCard rankStrings][self.rank]] ];
}

+ (NSArray *)rankStrings {
  return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7",
           @"8", @"9", @"J", @"Q", @"K"];
  //return @[@"?", @"A"];
  
}

+ (NSArray *)suitStrings {
  return @[@"♠", @"♥", @"♦", @"♣"];
}

- (void)setRank:(NSUInteger)rank {
  if (rank>0 && rank <= [PlayingCard maxRank]) {
    _rank = rank;
    self.contents = [[NSAttributedString alloc] initWithString: [[PlayingCard rankStrings][rank] stringByAppendingString: self.suit]];
  }
}

- (NSString*)suit {
  if (!_suit) {
    _suit = @"";
  }
  return _suit;
}

- (void)setSuit:(NSString*)suit {
  if ([[PlayingCard suitStrings] containsObject:suit]) {
    _suit = suit;
    NSString *s = [[PlayingCard rankStrings][self.rank] stringByAppendingString: suit];
    self.contents =[[NSAttributedString alloc] initWithString:s];
  }
}

+ (NSUInteger)maxRank {
  return [[PlayingCard rankStrings] count] - 1;
}

- (int)matcheScore:(NSArray*)otherCards {
  
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
