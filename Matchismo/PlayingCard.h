//
//  PlayingCard.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN
/// Card that has a rank and a suit
/// playing cards match when they have the same rank or the same suite
/// matching by rank is 4 times more valuable then matching by suit
@interface PlayingCard : Card
// Returns the maximum possible rank
+ (NSUInteger)maxRank;
// Returns a list of all the possible suit strings
+ (NSArray *)suitStrings;
// the rank of the card
@property (nonatomic) NSUInteger rank;
// the suite of the card
@property (strong, nonatomic) NSString* suit;

@end

NS_ASSUME_NONNULL_END
