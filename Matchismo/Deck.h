//
//  Deck.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "Card.h"
NS_ASSUME_NONNULL_BEGIN
// A collection of Cards
@interface Deck : NSObject
// Return a random Card which is present in the deck
- (Card *)drawRandomCard;
// Add the Card \card to the Deck
- (void)addCardToDeck:(Card*)card;
// Return the number of cards in the deck
- (NSUInteger)deckSize;

@end

NS_ASSUME_NONNULL_END
