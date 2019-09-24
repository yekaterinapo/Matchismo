//
//  MatchingGame.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 04/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchingGame : NSObject

@property (strong, nonatomic) NSMutableArray* cards; // of Card

@property (nonatomic, readonly) NSInteger score;

@property (nonatomic, readonly) BOOL enableModeChange;

@property (nonatomic, readwrite) NSUInteger matchSize;

@property (nonatomic, readonly) Deck *deck;

// designated initializer
- (instancetype) initWithCardCount: (NSUInteger) numOfCards UsingDeck: (Deck*) deck;

- (Card*) getCardAtIndex: (NSUInteger) index;

- (void) FlipCardAtIndex: (NSUInteger) index;

- (void) resetGameWithCardCount: (NSUInteger) numOfCards UsingDeck: (Deck*) deck;

- (NSInteger) matchScore: (NSArray*) cards;

- (NSArray *) dealThreeMoreCards;

@end

NS_ASSUME_NONNULL_END
