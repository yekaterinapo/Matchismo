//
//  Card.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// Object that represents a card
@interface Card : NSObject
// Score of the quality of the match between this card and \otherCards
- (int)matcheScore:(NSArray*)otherCards;
// The contents of the Card
@property (strong, nonatomic) NSAttributedString* contents;
// Is the card matched
@property (nonatomic) BOOL matched;
// Is the card chosen
@property (nonatomic) BOOL chosen;

@end

NS_ASSUME_NONNULL_END
