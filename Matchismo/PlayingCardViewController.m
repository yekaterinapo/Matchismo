//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 15/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "PlayingCardViewController.h"

@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

@synthesize game = _game;

- (MatchingGame*) game {
  if (!_game) {
    _game = [[PlayingCardMatchingGame alloc] initWithCardCount:[self.cardsButtons count] UsingDeck:[self createDeck]];
  }
  return _game;
}

- (Deck*) createDeck {
  return [[PlayDeck alloc] init];
}

@end
