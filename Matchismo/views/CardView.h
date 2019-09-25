//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)drawFaceOfCard; // protected

- (void)drawBackOfCard; // protected

@property (nonatomic) BOOL faceUp;

@end

