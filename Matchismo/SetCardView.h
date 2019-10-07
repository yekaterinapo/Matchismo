//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"
/// View of a Set Card
@interface SetCardView : CardView
// A list of length 4 where:
//  object 1: represents the color (red, green, blue)
//  object 2: represents the shading (3 options)
//  object 3: represents the shape (Oval, Diamond, Squiggle)
//  object 1: represents the multiplicity (1, 2, 3)
@property (strong, nonatomic) NSArray *attributes;

@end
