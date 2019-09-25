//
//  SetDeck.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 11/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "SetDeck.h"

@implementation SetDeck

- (instancetype) initWithAttributeCount: (NSArray*) ShapeOfattributes {
  self = [super init];
  if (self) {
    [self createDeckRec:ShapeOfattributes WithPrefix:[[NSArray alloc] init]];
  }
  return self;
}

- (void) createDeckRec: (NSArray*) ShapeOfAttributes WithPrefix: (NSArray*) attributes {
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
    [self createDeckRec:ShapeOfAttributes WithPrefix:attributes];
    attributes = [attributes subarrayWithRange: NSMakeRange(0, ([attributes count] -1))];
  }
}

@end
