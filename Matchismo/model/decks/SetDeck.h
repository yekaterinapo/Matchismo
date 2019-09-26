//
//  SetDeck.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 11/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "Deck.h"
#import "SetCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetDeck : Deck
-(instancetype)initWithAttributeCount:(NSArray*) ShapeOfattributes;
@end

NS_ASSUME_NONNULL_END
