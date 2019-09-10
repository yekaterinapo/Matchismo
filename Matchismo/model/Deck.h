//
//  Deck.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
NS_ASSUME_NONNULL_BEGIN

@interface Deck : NSObject
- (Card *) drawRandomCard;
- (void) addCardToDeck:(Card*) card;
- (NSUInteger) deckSize;
@end

NS_ASSUME_NONNULL_END
