//
//  ViewController.m
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardView.h"
#import "PlayDeck.h"
#import "PlayingCard.h"
#import "BasicShapeView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet BasicShapeView *basicShape;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.basicShape.color = 1;
  self.basicShape.shape = 1;
  self.basicShape.pattern = 2;
}

@end
