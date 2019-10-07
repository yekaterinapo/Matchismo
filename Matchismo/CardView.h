//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
/// View of an empty card, abstract class for \PlayingCardView and \SetCardView
@interface CardView : UIView
// Return an empty card view with frame
- (instancetype)initWithFrame:(CGRect)frame;
// Draw The Face of the Card
- (void)drawFaceOfCard; // protected
// Draw The Back of the Card
- (void)drawBackOfCard; // protected
// Change The side of the card to display with a flip animation
- (void)flip;
// Determines the side of the card to display
@property (nonatomic) BOOL faceUp;

@end

