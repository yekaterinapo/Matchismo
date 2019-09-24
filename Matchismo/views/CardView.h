//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)tap: (UITapGestureRecognizer *) tapGestureRecognizer;

- (void)drawFaceOfCard;

@property (nonatomic) NSUInteger rank;

@property (strong, nonatomic) NSString *suit;

@property (nonatomic) BOOL faceUp;

@end

