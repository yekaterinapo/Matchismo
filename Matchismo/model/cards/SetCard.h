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

-(int)getPropertyAsInt:(NSUInteger) idx;

-(instancetype)initWithAtributes: (NSArray*) attributes;

//@property (nonatomic) NSUInteger *numberOfShapes;
//@property (nonatomic) NSInteger *shape;
//@property (nonatomic) NSInteger *shading;
//@property (nonatomic) NSInteger *color;

@property (strong, nonatomic) NSArray *attributes; // array of NSUint

@end

NS_ASSUME_NONNULL_END
