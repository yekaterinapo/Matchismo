//
//  Deck.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "Deck.h"
@interface Deck()
@property(strong, nonatomic) NSMutableArray *cards;
@end

@implementation Deck
- (Card *) drawRandomCard{
    Card * card = nil;
    NSUInteger deck_size = [self.cards count];
    if(deck_size != 0){
        NSUInteger random_index = arc4random_uniform(deck_size-1);
        card = [self.cards objectAtIndexedSubscript: random_index];
        [self.cards removeObjectAtIndex: random_index];
    }
    return card;
}

- (void) addCardToDeck:(Card*) card{
    [self.cards insertObject:card atIndex:0];
}

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (NSUInteger) deckSize{
    return [self.cards count];
}

@end
