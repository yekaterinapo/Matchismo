//
//  PlayingCardView.m
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardView.h"

@interface CardView()
@property (nonatomic, readwrite) CGFloat faceCardScaleFactor;
@end

@implementation CardView

#pragma mark - Properties

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

- (CGFloat)faceCardScaleFactor
{
  if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
  return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
  _faceCardScaleFactor = faceCardScaleFactor;
  [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
  _faceUp = faceUp;
  [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  // Drawing code
  [self drawEmptyCard];
  if (self.faceUp) {
    [self drawFaceOfCard];
  }
  else {
    [self drawBackOfCard];
  }
}

- (void)drawEmptyCard {
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
  
  [roundedRect addClip];
  
  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);
  
  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
  return;
}

- (void)drawBackOfCard {
    [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
}

- (void)drawFaceOfCard {
  return;
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

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  [self setup];
  return self;
}

@end

