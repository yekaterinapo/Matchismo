//
//  SetDeck.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 11/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "SetDeck.h"

@implementation SetDeck

- (instancetype)init {
  self = [super init];
  if (self) {
    NSArray *shapeOfattributes = @[@3,@3,@3,@3];
    [self createDeckRecursive:shapeOfattributes withPrefix:[[NSArray alloc] init]];
  }
  return self;
}

- (void)createDeckRecursive:(NSArray*)ShapeOfAttributes withPrefix:(NSArray*)attributes {
  NSUInteger numOfAttributes = (ShapeOfAttributes)?[ShapeOfAttributes count]:0;
  if (numOfAttributes == 0) {
    SetCard *card = [[SetCard alloc] initWithAtributes: attributes];
    [self addCardToDeck:card];
    return;
  }
  NSNumber *attributeOptionsCount = (NSNumber*)ShapeOfAttributes[0];
  ShapeOfAttributes = [ShapeOfAttributes subarrayWithRange:NSMakeRange(0, numOfAttributes-1)];
  for (int attributeOption = 0; attributeOption < attributeOptionsCount.intValue; attributeOption++) {
    attributes = [attributes arrayByAddingObject: @(attributeOption)];
    [self createDeckRecursive:ShapeOfAttributes withPrefix:attributes];
    attributes = [attributes subarrayWithRange: NSMakeRange(0, ([attributes count] -1))];
  }
}

@end
