//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"
/// view of a Playing Card
@interface PlayingCardView : CardView

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
// The rank of the playing card
@property (nonatomic) NSUInteger rank;
// The suite of the playing card
@property (strong, nonatomic) NSString *suit;

@end
