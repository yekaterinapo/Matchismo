//
//  SetCard.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 11/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCard.h"

enum properties {k_color, k_shading, k_shape, k_multiplicity};
//enum color_options {color1, color2, color3};
//enum shading_options {hsading, color2, color3};

@implementation SetCard

@synthesize contents = _contents;

- (int) getPropertyAsInt: (NSUInteger) idx {
  return (int)[(NSNumber *)[self.attributes objectAtIndex:(idx)] integerValue];
}

- (NSArray*) attributes {
  if (!_attributes) {
    _attributes = [[NSArray alloc] init];
  }
  return _attributes;
}

- (instancetype) initWithAtributes: (NSArray*) attributes {
  self = [super init];
  if (self) {
    self.attributes = attributes;
  }
  return self;
}

+ (NSArray *) ShapeColors {
  return @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
}

+ (NSArray *) ShapeBoarderThiknesses {
  return @[@-0, @3, @10];
}

+ (NSArray *) ShapeStrings {
  return @[@"▲", @"●", @"■"];
}

- (NSAttributedString*) contents {
  // get all atributes from card
  if (!_contents) {
    UIColor *color = [SetCard ShapeColors][[self getPropertyAsInt: k_color]];
    NSString *shape = [SetCard ShapeStrings][[self getPropertyAsInt: k_shape]];
    NSNumber *thickness = [SetCard ShapeBoarderThiknesses][[self getPropertyAsInt: k_shading]];
    int multiplicity = [self getPropertyAsInt: k_multiplicity] + 1;
    // create contents string
    NSMutableAttributedString *mutableContent = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i<multiplicity; i++) {
      NSMutableAttributedString *attributedSymbol = [[NSMutableAttributedString alloc] initWithString:shape attributes: @{NSForegroundColorAttributeName:color, NSStrokeWidthAttributeName:thickness} ];
      [mutableContent appendAttributedString:attributedSymbol];
    }
    _contents = [mutableContent copy];
  }
  return _contents;
}

@end
