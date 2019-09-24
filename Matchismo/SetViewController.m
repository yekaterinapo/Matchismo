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

@interface SetViewController ()

@end

@implementation SetViewController

@synthesize game = _game;

- (void) viewDidLoad {
  [super viewDidLoad];
  NSUInteger count = [self.game.cards count];
  Deck* deck = [self createDeck];
  [self.game resetGameWithCardCount: count UsingDeck: deck ];
  [self updateUI];
}

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

- (UIImage*) getImageForCard: (Card*) card {
  return [UIImage imageNamed:@"cardfront"];
}

- (NSAttributedString*) getTitleForCard:(Card*) card {
  return card.contents;
}

- (void) updateUI {
  [super updateUI];
  // hilight selected buttons
//  for (UIButton* cardButton in self.cardsButtons) {
//    // get the index of the button
//    NSUInteger cardIndex = [self.cardsButtons indexOfObject:cardButton];
//    Card *card = [self.game getCardAtIndex:cardIndex];
//    [cardButton.layer setBorderWidth:(card.chosen)?3.0:0];
//  }
}


- (CardView*) getViewForCard: (Card*) card WithFrame: (CGRect)aRect {
  
  SetCard *setCard = (SetCard *)card;
  SetCardView *setCardView = [[SetCardView alloc] initWithFrame:aRect];
  
  // update attributes using setCard
  setCardView.attributes = setCard.attributes;
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)];
  [setCardView addGestureRecognizer:tapGestureRecognizer];
  return (CardView *)setCardView;
  
}


@end
