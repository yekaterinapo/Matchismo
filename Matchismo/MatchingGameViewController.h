//
//  ViewController.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
// Abstract class, must implement methods as described below

#import <UIKit/UIKit.h>
#import "MatchingGame.h"

@interface MatchingGameViewController : UIViewController

- (void) updateUI;

- (MatchingGame*) game;

- (Deck*) createDeck; // overide with your deck

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardsButtons;

@property (strong, nonatomic) MatchingGame *game; //overide for your type of game

@end
