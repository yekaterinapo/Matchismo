//
//  SetCard.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 11/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN
/// Card that has a list of attributes
@interface SetCard : Card
// Initialize the set card with a list of attributes
-(instancetype)initWithAtributes:(NSArray*)attributes;
// Returns the value of the property at index \index
-(NSInteger)propertyAtIndex:(NSUInteger)index;
// The list of attributes of the set card
@property (strong, nonatomic) NSArray *attributes; // array of NSUint

@end

NS_ASSUME_NONNULL_END
