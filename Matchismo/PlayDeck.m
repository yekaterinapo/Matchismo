//
//  PlayDeck.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "PlayDeck.h"
#import "PlayingCard.h"

@implementation PlayDeck

- (instancetype)init {
  self = [super init];
  if (self) {
    for (NSString* suit in [PlayingCard suitStrings]) {
      for (NSUInteger rank=1; rank<=[PlayingCard maxRank]; rank++) {
        PlayingCard *card = [[PlayingCard alloc] init];
        card.rank = rank;
        card.suit = suit;
        [self addCardToDeck:card];
      }
    }
  }
  return self;
}

@end
