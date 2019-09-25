//
//  ViewController.m
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ViewController.h"
#import "views/PlayingCardView.h"
#import "model/decks/PlayDeck.h"
#import "model/cards/PlayingCard.h"
#import "views/BasicShapeView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet BasicShapeView *basicShape;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.basicShape.color = [UIColor greenColor];
  self.basicShape.shape = 1;
  self.basicShape.pattern = 2;
  
  // Do any additional setup after loading the view, typically from a nib.
  //[self.playingCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.playingCardView action:@selector(pinch:)]];
}

@end
