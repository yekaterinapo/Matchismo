//
//  SetCardView.m
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetCardView.h"
#import "Grid.h"

enum properties {k_color, k_shading, k_shape, k_multiplicity};

@interface SetCardView()

@property (nonatomic) CGFloat faceCardScaleFactor;

@end

@implementation SetCardView

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#pragma mark - Drawing

- (void)drawFaceOfCard {
  NSInteger colorIndex = [[self.attributes objectAtIndex:(k_color)] integerValue];
  NSInteger patternIndex = [[self.attributes objectAtIndex:(k_shading)] integerValue];
  NSInteger multiplicity = [[self.attributes objectAtIndex:(k_multiplicity)] integerValue] + 1;
  
  for (int i = 0; i < multiplicity; i++) {
    int hight = 0.8*(self.frame.size.height/3);
    int width = 0.8*(self.frame.size.width);
    int x = (self.frame.size.width - width)/2;
    int y = (i*self.frame.size.height)/(multiplicity) +
    ((self.frame.size.height)/(multiplicity) - hight)/2;
    CGRect frame = CGRectMake(x, y, width, hight);
    UIBezierPath *shape = [self getOutlineOfShapeInRectangel:frame];
    UIColor* color = [[SetCardView shapeColors][colorIndex] colorWithAlphaComponent:
                      [[SetCardView shapeAlphas][patternIndex] floatValue]];
    [color setFill];
    [[UIColor blackColor ] setStroke];
    [shape fill];
    [shape stroke];
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

- (UIBezierPath*)getOutlineOfShapeInRectangel:(CGRect)rectangel {
  NSInteger shapeIndex = [[self.attributes objectAtIndex:(k_shape)] integerValue];
  switch (shapeIndex) {
    case 1:
      return [self outlineOfOValInRectangel:rectangel];
      break;
    case 2:
      return [self outlineOfDiamondInRectangel:rectangel];
      break;
    default:
      return [self outlineOfSquiggleInRectangel:rectangel];
      break;
  }
}

- (UIBezierPath*)outlineOfOValInRectangel:(CGRect)rectangel {
  UIBezierPath *oval = [UIBezierPath bezierPathWithRoundedRect:rectangel
                                                  cornerRadius:rectangel.size.width];
  return oval;
}

- (UIBezierPath*)outlineOfDiamondInRectangel:(CGRect)rectangel {
  UIBezierPath *diamond = [[UIBezierPath alloc] init];
  [diamond moveToPoint:CGPointMake(rectangel.origin.x + rectangel.size.width/2, rectangel.origin.y)];
  [diamond addLineToPoint :CGPointMake(rectangel.origin.x + rectangel.size.width,rectangel.origin.y + rectangel.size.height/2)];
  [diamond addLineToPoint :CGPointMake(rectangel.origin.x + rectangel.size.width/2, rectangel.origin.y + rectangel.size.height)];
  [diamond addLineToPoint :CGPointMake(rectangel.origin.x, rectangel.origin.y + rectangel.size.height/2)];
  [diamond closePath];
  return diamond;
}

#define SYMBOL_WIDTH_RATIO 1
#define SYMBOL_HEIGHT_RATIO 0.5
- (UIBezierPath *)outlineOfSquiggleInRectangel:(CGRect)rectangel {
  CGSize size = CGSizeMake(rectangel.size.width * SYMBOL_WIDTH_RATIO,
                           rectangel.size.height * SYMBOL_HEIGHT_RATIO);
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path moveToPoint:CGPointMake(104, 15)];
  [path addCurveToPoint:CGPointMake(63, 54) controlPoint1:CGPointMake(112.4, 36.9)
          controlPoint2:CGPointMake(89.7, 60.8)];
  [path addCurveToPoint:CGPointMake(27, 53) controlPoint1:CGPointMake(52.3, 51.3)
          controlPoint2:CGPointMake(42.2, 42)];
  [path addCurveToPoint:CGPointMake(5, 40) controlPoint1:CGPointMake(9.6, 65.6)
          controlPoint2:CGPointMake(5.4, 58.3)];
  [path addCurveToPoint:CGPointMake(36, 12) controlPoint1:CGPointMake(4.6, 22)
          controlPoint2:CGPointMake(19.1, 9.7)];
  [path addCurveToPoint:CGPointMake(89, 14) controlPoint1:CGPointMake(59.2, 15.2)
          controlPoint2:CGPointMake(61.9, 31.5)];
  [path addCurveToPoint:CGPointMake(104, 15) controlPoint1:CGPointMake(95.3, 10)
          controlPoint2:CGPointMake(100.9, 6.9)];
  [path applyTransform:CGAffineTransformMakeScale(0.9524*size.width/100, 0.9524*size.height/50)];
  [path applyTransform:CGAffineTransformMakeTranslation(rectangel.origin.x, rectangel.origin.y)];

  return path;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  [self setup];
  return self;
}

- (void)setup {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

+ (NSArray *)shapeAlphas {
  return @[@0.1, @0.7, @1.];
}

+ (NSArray *) shapeColors {
  return @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
}

-(NSArray *)attributes {
  if (!_attributes) {
    _attributes = @[@0, @0, @0, @0];
  }
  return _attributes;
}

@end
