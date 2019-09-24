//
//  SetCardView.m
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetCardView.h"
#import "BasicShapeView.h"
#import "../model/Grid.h"

enum properties {k_color, k_shading, k_shape, k_multiplicity};

@interface SetCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation SetCardView

@synthesize faceCardScaleFactor = _faceCardScaleFactor;


-(NSArray *)attributes{
  if (!_attributes) {
    _attributes = @[@0, @0, @0, @0];
  }
  return _attributes;
}

#pragma mark - Drawing

- (void)drawFaceOfCard {
  [[self subviews]
   makeObjectsPerformSelector:@selector(removeFromSuperview)];
  
  int color = [self getPropertyAsInt:k_color];
  int shape = [self getPropertyAsInt:k_shape];
  int pattern = [self getPropertyAsInt:k_shading];
  int multiplicity = [self getPropertyAsInt:k_multiplicity] + 1;
  
  for (int i = 0; i < multiplicity; i++) {
    int hight = 0.8*(self.frame.size.height/3);
    int width = 0.8*(self.frame.size.width);
    int x = (self.frame.size.width - width)/2;
    int y = (i*self.frame.size.height)/(multiplicity) + ((self.frame.size.height)/(multiplicity) - hight)/2;
    CGRect frame = CGRectMake(x, y, width, hight);
    BasicShapeView *basicShape = [[BasicShapeView alloc] initWithFrame:frame];
    basicShape.shape = shape;
    basicShape.color = color;
    basicShape.pattern = pattern;
    [self addSubview:basicShape];
  }
  self.alpha = 1;
}

- (void)drawBackOfCard {
  [self drawFaceOfCard];
  self.alpha = 0.6;
}


- (int) getPropertyAsInt: (int) idx {
  return (int)[(NSNumber *)[self.attributes objectAtIndex:(idx)] integerValue];
}

#pragma mark - Initialization

- (void)setup
{
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  [self setup];
  return self;
}


@end

