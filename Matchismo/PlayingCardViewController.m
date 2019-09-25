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

- (CardView*) ViewForCard: (Card*) card WithFrame: (CGRect)aRect {
  
  PlayingCard *playingCard = (PlayingCard *)card;
  PlayingCardView *playingCardView = [[PlayingCardView alloc] initWithFrame:aRect];

  playingCardView.suit = playingCard.suit;
  playingCardView.rank = playingCard.rank;
  playingCardView.faceUp = playingCard.chosen;
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)];
  [playingCardView addGestureRecognizer:tapGestureRecognizer];
  return (CardView *)playingCardView;
  
}

- (void) FlipCardView: (CardView *) cardView {
  UIViewAnimationOptions TransitionFlip = (cardView.faceUp)? UIViewAnimationOptionTransitionFlipFromLeft:UIViewAnimationOptionTransitionFlipFromRight;
  [UIView transitionWithView:cardView
                    duration:1
                     options:TransitionFlip
                  animations:^{cardView.faceUp = !cardView.faceUp;}
                  completion:^(BOOL finished) {}];
}

@end
