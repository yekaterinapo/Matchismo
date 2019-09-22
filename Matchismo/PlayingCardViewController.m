//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 15/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "views/PlayingCardView.h"
#import "model/cards/PlayingCard.h"

@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

@synthesize game = _game;

- (MatchingGame*) game {
  if (!_game) {
    _game = [[PlayingCardMatchingGame alloc] initWithCardCount:CARDS_IN_GAME UsingDeck:[self createDeck]];
  }
  return _game;
}

- (Deck*) createDeck {
  return [[PlayDeck alloc] init];
}

- (UIView*) getViewForCard: (Card*) card {
  PlayingCard *playingCard = card;
  PlayingCardView *playingCardView =  [[PlayingCardView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
  playingCardView.suit = playingCard.suit;
  playingCardView.rank = playingCard.rank;
  return playingCardView;
}

- (void)viewDidLoad {
  
}

@end
