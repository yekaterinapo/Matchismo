//
//  SetViewController.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 15/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "SetViewController.h"
#import "./model/cards/Card.h"
#import "./model/decks/SetDeck.h"
#import "./model/games/setGame.h"
#import "./views/SetCardView.h"

@implementation SetViewController

@synthesize game = _game;

- (MatchingGame*) game {
  if (!_game) {
    _game = [[setGame alloc] initWithCardCount:CARDS_IN_GAME UsingDeck:[self createDeck]];
  }
  return _game;
}

- (Deck*) createDeck {
  NSArray *ShapeOfattributes = @[@3,@3,@3,@3];
  return [[SetDeck alloc] initWithAttributeCount:ShapeOfattributes];
}

- (CardView*) getViewForCard: (Card*) card WithFrame: (CGRect)aRect {
  
  SetCard *setCard = (SetCard *)card;
  SetCardView *setCardView = [[SetCardView alloc] initWithFrame:aRect];
  
  setCardView.attributes = setCard.attributes;
  setCardView.faceUp = setCard.chosen;
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)];
  [setCardView addGestureRecognizer:tapGestureRecognizer];
  return (CardView *)setCardView;
  
}


@end
