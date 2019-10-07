//
//  setGame.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 15/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "setGame.h"
#import "SetCard.h"

static const int MIS_MATCH_SCORE = 0;
static const int MATCH_SCORE = 1;
static const int NUM_OF_ATRIBUTES = 4;

@implementation setGame

- (NSInteger)matchScore:(NSArray*)cards {
  for (int CardAtributeIndex=0; CardAtributeIndex<NUM_OF_ATRIBUTES; CardAtributeIndex++) {
    NSArray *histogramForAttribute = [self historgamForAttribute: CardAtributeIndex forCards: cards];
    if (![self isAttributeOkayFromHistogram: histogramForAttribute]) {
      return MIS_MATCH_SCORE;
    }
  }
  return MATCH_SCORE;
}

- (NSArray*)historgamForAttribute:(NSInteger)CardAtributeIndex forCards:(NSArray*)cards {
  NSMutableArray *atributeOptionsHistogram = [@[@0, @0, @0] mutableCopy]; // three options for each attribute
  for (SetCard* card in cards) {
    NSInteger attributeOption = [card propertyAtIndex: CardAtributeIndex];
    atributeOptionsHistogram[attributeOption] = @([[atributeOptionsHistogram objectAtIndex:
                                                    attributeOption] integerValue]+1);
  }
  return atributeOptionsHistogram;
}

- (BOOL)isAttributeOkayFromHistogram:(NSArray*)histogramForAttribute {
  BOOL hasOptionCountOfOne = NO, hasOptionCountOfMoreThenOne=NO;
  for (NSNumber* optionCount in histogramForAttribute) {
    hasOptionCountOfOne = (optionCount.intValue==1)? YES:hasOptionCountOfOne;
    hasOptionCountOfMoreThenOne = (optionCount.intValue>1)? YES:hasOptionCountOfMoreThenOne;
  }
  return !(hasOptionCountOfOne && hasOptionCountOfMoreThenOne);
}

- (instancetype)initWithCardCount:(NSUInteger)numOfCards usingDeck:(Deck*)deck {
    self = [super initWithCardCount: numOfCards usingDeck: deck];
    if (self) {
        self.matchSize = 3;
    }
    return self;
}

- (void) resetGameWithCardCount:(NSUInteger) numOfCards usingDeck:(Deck*)deck {
    [super resetGameWithCardCount: numOfCards usingDeck:deck];
    self.matchSize = 3;
}

@end
