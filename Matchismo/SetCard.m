//
//  SetCard.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 11/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCard.h"

@implementation SetCard

@synthesize contents = _contents;

- (NSInteger)propertyAtIndex:(NSUInteger)index {
  return [[self.attributes objectAtIndex:(index)] integerValue];
}

- (NSArray*)attributes {
  if (!_attributes) {
    _attributes = [[NSArray alloc] init];
  }
  return _attributes;
}

- (instancetype)initWithAtributes:(NSArray*) attributes {
  self = [super init];
  if (self) {
    self.attributes = attributes;
  }
  return self;
}

- (NSAttributedString*)contents {
  if (!_contents) {
    _contents = [[NSAttributedString alloc] init];
  }
  return _contents;
}

@end
