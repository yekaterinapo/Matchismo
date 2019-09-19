//
//  PlayingCard.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCard : Card

+ (NSUInteger) maxRank;

+ (NSArray *) SuitStrings;

- (int) MatcheScore: (NSArray*) otherCards;

@property (nonatomic) NSUInteger rank;

@property (strong, nonatomic) NSString* suit;

@end

NS_ASSUME_NONNULL_END
