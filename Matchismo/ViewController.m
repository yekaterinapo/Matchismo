//
//  ViewController.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "ViewController.h"
#import "HistoryViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLable;

@property (weak, nonatomic) IBOutlet UISwitch *threeMatchSwitch;

@property (weak, nonatomic) IBOutlet UILabel *comenteryLable;

@end

@implementation ViewController

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
  if ( [segue.identifier isEqualToString:@"showHistory"] ) {
    if ( [segue.destinationViewController isKindOfClass: [HistoryViewController class]] ) {
      HistoryViewController* historyViewController = (HistoryViewController*) segue.destinationViewController;
      historyViewController.history = self.game.history;
    }
  }
}

- (Deck*) createDeck { //abstruct
  return nil; // [[PlayDeck alloc] init];
}

- (IBAction) threeMatchSwitch:(id)sender {
  BOOL isOn = [sender isOn];
  self.game.matchSize = (isOn)? 3:2;
  [self updateUI];
}

- (IBAction) touchResetButton: (id) sender {
  NSUInteger count = [self.game.cards count];
  Deck* deck = [self createDeck];
  [self.game resetGameWithCardCount: count UsingDeck: deck];
  [self.threeMatchSwitch setOn:NO];
  [self updateUI];
}

- (IBAction) touchCardButton: (UIButton *) sender {
  NSUInteger buttonIndex = [self.cardsButtons indexOfObject:sender];
  [self.game FlipCardAtIndex:buttonIndex];
  [self updateUI];
  
  
}

- (MatchingGame*) game {
  if (!_game) {
    _game = [[MatchingGame alloc] initWithCardCount:[self.cardsButtons count] UsingDeck:[self createDeck]];
  }
  return _game;
}

- (void) updateUI {
  // update mode switch
  self.threeMatchSwitch.userInteractionEnabled = self.game.enableModeChange;
  // update all the buttons
  for (UIButton* cardButton in self.cardsButtons) {
    // get the index of the button
    NSUInteger cardIndex = [self.cardsButtons indexOfObject:cardButton];
    Card *card = [self.game getCardAtIndex:cardIndex];
    [cardButton setBackgroundImage:[self getImageForCard:card] forState:UIControlStateNormal];
    [cardButton setAttributedTitle:[self getTitleForCard:card] forState:UIControlStateNormal];
    cardButton.alpha = (card.matched)? 0.6:1;
    [self.scoreLable setText: [NSString stringWithFormat:@"score: %d", (int)self.game.score]];
  }
  [self.comenteryLable setAttributedText:self.game.comentery];
}

- (NSAttributedString*) getTitleForCard: (Card*) card {
  return (card.chosen || card.matched)? [[NSAttributedString alloc] initWithString: card.contents.string]:[[NSAttributedString alloc] init];
}

- (UIImage*) getImageForCard: (Card*) card {
  return [UIImage imageNamed:(card.chosen || card.matched)? @"cardfront": @"cardback"];
}

@end
