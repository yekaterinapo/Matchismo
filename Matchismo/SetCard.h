//
//  SetCard.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 11/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCard : Card

-(NSInteger)propertyAtIndex:(NSUInteger)index;

-(instancetype)initWithAtributes:(NSArray*)attributes;

@property (strong, nonatomic) NSArray *attributes; // array of NSUint

@end

NS_ASSUME_NONNULL_END
