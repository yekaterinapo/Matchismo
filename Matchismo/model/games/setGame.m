//
//  setGame.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 15/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "setGame.h"
#import "../cards/SetCard.h"

static const int MIS_MATCH_SCORE = 0;
static const int MATCH_SCORE = 1;
static const int NUM_OF_ATRIBUTES = 4;

@implementation setGame

- (NSInteger) matchScore: (NSArray*) cards {
  for (int CardAtributeIdx=0; CardAtributeIdx<NUM_OF_ATRIBUTES; CardAtributeIdx++) {
    NSArray *histogramForAttribute = [self historgamForAttribute: CardAtributeIdx forCards: cards];
    if (![self isAttributeOkayFromHistogram: histogramForAttribute]){
      return MIS_MATCH_SCORE;
    }
  }
  return MATCH_SCORE;
}

- (NSArray*) historgamForAttribute: (int) CardAtributeIdx forCards: (NSArray*) cards {
  NSMutableArray *atributeOptionsHistogram = [@[@0, @0, @0, @0] mutableCopy];
  for (SetCard* card in cards) {
    int attributeOption = [card getPropertyAsInt:CardAtributeIdx];
    NSNumber *currentAttributeCount = (NSNumber*) [atributeOptionsHistogram objectAtIndex: attributeOption] ;
    atributeOptionsHistogram[attributeOption] = @(currentAttributeCount.intValue+1);
  }
  return atributeOptionsHistogram;
}

- (BOOL) isAttributeOkayFromHistogram: (NSArray*) histogramForAttribute {
  BOOL hasOptionCountOfOne = NO, hasOptionCountOfMoreThenOne=NO;
  for (NSNumber* optionCount in histogramForAttribute) {
    hasOptionCountOfOne = (optionCount.intValue==1)? YES:hasOptionCountOfOne;
    hasOptionCountOfMoreThenOne = (optionCount.intValue>1)? YES:hasOptionCountOfMoreThenOne;
  }
  return !(hasOptionCountOfOne && hasOptionCountOfMoreThenOne);
}

- (instancetype) initWithCardCount: (NSUInteger) numOfCards UsingDeck: (Deck*) deck{
    self = [super initWithCardCount: numOfCards UsingDeck: deck];
    if (self) {
        self.matchSize = 3;
    }
    return self;
}

- (void) resetGameWithCardCount: (NSUInteger) numOfCards UsingDeck: (Deck*) deck {
    [super resetGameWithCardCount: numOfCards UsingDeck:deck];
    self.matchSize = 3;
}

@end
