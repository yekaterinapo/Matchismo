//
//  MatchingGame.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 04/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayDeck.h"
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchingGame : NSObject
@property(strong, nonatomic) NSMutableArray* cards; // of Card
@property(nonatomic, readonly) NSInteger score;
@property(nonatomic, readonly) BOOL enableModeChange;
@property(nonatomic, readwrite) NSUInteger matchSize;
@property (strong, nonatomic, readonly) NSMutableString *comentery;

// designated initializer
-(instancetype)initWithCardCount: (NSUInteger) numOfCards UsingDeck: (Deck*) deck;
-(PlayingCard*)getCardAtIndex: (NSUInteger) index;
-(void)FlipCardAtIndex: (NSUInteger) index;
-(void)resetGameWithCardCount: (NSUInteger) numOfCards UsingDeck: (Deck*) deck;


@end

NS_ASSUME_NONNULL_END
