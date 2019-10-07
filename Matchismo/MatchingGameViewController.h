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
// return a matching game
- (MatchingGame*)game;
// return a deck of cards
- (Deck*)createDeck; // overide with your deck
// return a view for a card
- (CardView *)viewForCard:(Card*)card withFrame:(CGRect)aRect; // overide to return view of your cards
// tap on a card on the table
- (IBAction)tapCard:(UITapGestureRecognizer *)sender;
// a view to contain all the cards on the table
//@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (weak, nonatomic) IBOutlet UIView *gameView;
// the matching game we play
@property (strong, nonatomic) MatchingGame *game; //overide for your type of game

@property (strong, nonatomic) NSMutableArray *cardViewsOnTable; /// array of CardViews

@end
