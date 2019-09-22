//
//  ViewController.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "MatchingGameViewController.h"
#import "views/CardView.h"


@interface MatchingGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLable;

@property (weak, nonatomic) IBOutlet UISwitch *threeMatchSwitch;

@property (strong, nonatomic) NSMutableArray *cardViewsOnTable; /// array of CardViews

@end

@implementation MatchingGameViewController

- (void)viewDidLoad{
  [self startNewGame];
}

- (Deck*) createDeck { //abstruct
  return nil; // [[PlayDeck alloc] init];
}

- (NSMutableArray *)cardViewsOnTable {
  if(!_cardViewsOnTable){
    _cardViewsOnTable = [[NSMutableArray alloc] init];
  }
  return _cardViewsOnTable;
}

- (IBAction) threeMatchSwitch:(id)sender {
  BOOL isOn = [sender isOn];
  self.game.matchSize = (isOn)? 3:2;
  [self updateUI];
}

- (IBAction) touchResetButton:(id) sender {
  [self startNewGame];
  [self updateUI];
}

- (void) startNewGame {
  // remove all previouse cards from view;
  for (UIView* cardView in self.cardViewsOnTable) {
    [cardView removeFromSuperview];
  }
  // deal new cards
  Deck* deck = [self createDeck];
  [self.game resetGameWithCardCount: CARDS_IN_GAME UsingDeck: deck];
  for (Card* card in self.game.cards) {
    UIView *cardView = [self getViewForCard:card];
    [self.cardViewsOnTable addObject:cardView];
    [self.gameView addSubview: cardView];
  }
  [self.threeMatchSwitch setOn:NO];
  [self.gameView setNeedsDisplay];
}

//- (IBAction) touchCardButton: (UIButton *) sender {
//  NSUInteger buttonIndex = [self.cardsButtons indexOfObject:sender];
//  [self.game FlipCardAtIndex:buttonIndex];
//  [self updateUI];
//}


- (MatchingGame*) game {
  if (!_game) {
    _game = [[MatchingGame alloc] initWithCardCount:CARDS_IN_GAME UsingDeck:[self createDeck]];
  }
  return _game;
}

- (void) updateUI {
//  // update mode switch
//  self.threeMatchSwitch.userInteractionEnabled = self.game.enableModeChange;
//  // update all the buttons
//  for (UIButton* cardButton in self.cardsButtons) {
//    // get the index of the button
//    NSUInteger cardIndex = [self.cardsButtons indexOfObject:cardButton];
//    Card *card = [self.game getCardAtIndex:cardIndex];
////getViewForCard    cardButton.alpha = (card.matched)? 0.6:1;
//  }
  [self.scoreLable setText: [NSString stringWithFormat:@"score: %d", (int)self.game.score]];
}

- (UIView*) getViewForCard: (Card*) card {
  return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
}


@end
