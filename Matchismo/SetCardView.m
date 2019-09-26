//
//  SetCardView.m
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetCardView.h"
#import "BasicShapeView.h"
#import "Grid.h"

enum properties {k_color, k_shading, k_shape, k_multiplicity};

@interface SetCardView()

@property (nonatomic) CGFloat faceCardScaleFactor;

@end

@implementation SetCardView

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

//-(instancetype)initWithFrame:(CGRect)frame {
//  if (self = [super initWithFrame:frame]) {
//    NSInteger color = [[self.attributes objectAtIndex:(k_color)] integerValue];
//    NSInteger shape = [[self.attributes objectAtIndex:(k_shape)] integerValue];
//    NSInteger pattern = [[self.attributes objectAtIndex:(k_shading)] integerValue];
//    NSInteger multiplicity = [[self.attributes objectAtIndex:(k_multiplicity)] integerValue] + 1;
//
//    for (int i = 0; i < multiplicity; i++) {
//      int hight = 0.8*(self.frame.size.height/3);
//      int width = 0.8*(self.frame.size.width);
//      int x = (self.frame.size.width - width)/2;
//      int y = (i*self.frame.size.height)/(multiplicity) +
//      ((self.frame.size.height)/(multiplicity) - hight)/2;
//      CGRect frame = CGRectMake(x, y, width, hight);
//      BasicShapeView *basicShape = [[BasicShapeView alloc] initWithFrame:frame];
//      basicShape.shape = shape;
//      basicShape.color = color;
//      basicShape.pattern = pattern;
//      [self addSubview:basicShape];
//      basicShape.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin);
//    }
//    self.alpha = 1;
//  }
//  return self;
//}

-(NSArray *)attributes {
  if (!_attributes) {
    _attributes = @[@0, @0, @0, @0];
  }
  return _attributes;
}

#pragma mark - Drawing

- (void)drawFaceOfCard {
  [[self subviews]
   makeObjectsPerformSelector:@selector(removeFromSuperview)];

  NSInteger color = [[self.attributes objectAtIndex:(k_color)] integerValue];
  NSInteger shape = [[self.attributes objectAtIndex:(k_shape)] integerValue];
  NSInteger pattern = [[self.attributes objectAtIndex:(k_shading)] integerValue];
  NSInteger multiplicity = [[self.attributes objectAtIndex:(k_multiplicity)] integerValue] + 1;

  for (int i = 0; i < multiplicity; i++) {
    int hight = 0.8*(self.frame.size.height/3);
    int width = 0.8*(self.frame.size.width);
    int x = (self.frame.size.width - width)/2;
    int y = (i*self.frame.size.height)/(multiplicity) +
        ((self.frame.size.height)/(multiplicity) - hight)/2;
    CGRect frame = CGRectMake(x, y, width, hight);
    BasicShapeView *basicShape = [[BasicShapeView alloc] initWithFrame:frame];
    basicShape.shape = shape;
    basicShape.color = color;
    basicShape.pattern = pattern;
    [self addSubview:basicShape];
    basicShape.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
  }
  self.alpha = 1;
}

- (void)drawBackOfCard {
  [self drawFaceOfCard];
  self.alpha = 0.6;
}

- (void)flip {
  [UIView transitionWithView:self
                    duration:1
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{self.faceUp = !self.faceUp;}
                  completion:^(BOOL finished) {}];
}

@end

