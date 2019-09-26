//
//  ViewController.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
// Abstract class, must implement methods as described below

#import <UIKit/UIKit.h>
#import "MatchingGame.h"
#import "CardView.h"

static const int CARDS_IN_GAME = 12;
static const float CARDS_ASPECT_RATIO = 0.7;

@interface MatchingGameViewController : UIViewController

- (void)updateUI;

- (MatchingGame*)game;

- (Deck*)createDeck; // overide with your deck

- (CardView *)viewForCard:(Card*)card withFrame:(CGRect)aRect; // overide to return view of your cards

- (IBAction)tapCard:(UITapGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UIView *gameView;

@property (strong, nonatomic) MatchingGame *game; //overide for your type of game

@property (strong, nonatomic) NSMutableArray *cardViewsOnTable; /// array of CardViews

@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchCards;

@end
