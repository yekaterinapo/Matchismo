//
//  ovalsView.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 19/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "BasicShapeView.h"

@implementation BasicShapeView

- (void) setColor: (int) color {
  _color = color;
  [self setNeedsDisplay];
}

- (void) setPattern: (int) pattern {
  _pattern = pattern;
  [self setNeedsDisplay];
}

+ (NSArray *) ShapeColors {
  return @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  UIBezierPath *outline = [self getOutlineOfShape];
  UIColor* color = [[BasicShapeView ShapeColors][self.color] colorWithAlphaComponent:[[BasicShapeView ShapeAlphas][self.pattern] floatValue]];
  [color setFill];
  [[UIColor blackColor ] setStroke];
//  outline.lineWidth = ((NSNumber *)[BasicShapeView ShapeBoarderThiknesses][self.pattern]).integerValue;
  [outline fill];
  [outline stroke];
}

- (UIBezierPath*) getOutlineOfShape {
  switch (self.shape) {
    case 1:
      return [self outlineOfOVal];
      break;
    case 2:
      return [self outlineOfDiamond];
      break;
    default:
      return [self outlineOfSquiggle];
      break;
  }
}

- (UIBezierPath*) outlineOfOVal {
  UIBezierPath *oval = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                  cornerRadius:self.bounds.size.width];
  return oval;
}

- (UIBezierPath*) outlineOfDiamond {
  UIBezierPath *diamond = [[UIBezierPath alloc] init];
  [diamond moveToPoint:CGPointMake(self.bounds.size.width/2, 0)];
  [diamond addLineToPoint :CGPointMake(self.bounds.size.width,self.bounds.size.height/2)];
  [diamond addLineToPoint :CGPointMake(self.bounds.size.width/2, self.bounds.size.height)];
  [diamond addLineToPoint :CGPointMake(0, self.bounds.size.height/2)];
  [diamond closePath];
  return diamond;
}

#define SYMBOL_WIDTH_RATIO 1
#define SYMBOL_HEIGHT_RATIO 0.5
//- (UIBezierPath *) drawSquiggleAtPoint:(CGPoint)point {
- (UIBezierPath *) outlineOfSquiggle{
  CGSize size = CGSizeMake(self.bounds.size.width * SYMBOL_WIDTH_RATIO,
                           self.bounds.size.height * SYMBOL_HEIGHT_RATIO);
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
//  [path applyTransform:CGAffineTransformMakeTranslation(point.x - size.width/2 - 3 * size.width /100, point.y - size.height/2 - 8 * size.height/50)];
  return path;
}

- (void) setup {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void) awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  [self setup];
  return self;
}

+ (NSArray *) ShapeAlphas {
  return @[@0.1, @0.7, @1.];
}


@end
