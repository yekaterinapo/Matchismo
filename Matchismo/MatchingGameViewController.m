//
//  ViewController.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "MatchingGameViewController.h"
#import "model/Grid.h"

@interface MatchingGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLable;

@property (weak, nonatomic) IBOutlet UISwitch *threeMatchSwitch;

@property (strong, nonatomic) NSMutableArray *cardsOnTable; /// array of Cards

@property (weak, nonatomic) IBOutlet CardView *deckView;

@property (strong, nonatomic) Grid *grid;

@end

@implementation MatchingGameViewController

- (void)viewDidLoad {
  [self startNewGame];
}

- (void) startNewGame {
  [self removeCardsFromTable:[self.cardsOnTable copy]]; //copy because selector operates on cardsOnTable
  Deck* deck = [self createDeck];
  [self.game resetGameWithCardCount: CARDS_IN_GAME UsingDeck: deck];
  [self addCardsToTable:self.game.cards];
  // set size of deck view
  CGRect deckFrame = CGRectMake(self.deckView.frame.origin.x, self.deckView.frame.origin.y,
                                0.9*self.grid.cellSize.width, 0.9*self.grid.cellSize.height);
  [self getViewForDeckWithFrame:deckFrame];
  [self.view setNeedsDisplay];
}

- (void)removeCardsFromTable:(NSArray *) cardsToRemove {
  for (Card *card in cardsToRemove) {
    NSUInteger indexInCardsOnTable = [self.cardsOnTable indexOfObject:card];
    [self.cardsOnTable removeObject:card];
    [self.cardViewsOnTable removeObjectAtIndex:indexInCardsOnTable];
    [[self.gameView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
  }
  [self updateUI];
}

#define ANIMATION_DURATION 3

- (void) updateUI {
  [self.scoreLable setText: [NSString stringWithFormat:@"score: %d", (int)self.game.score]];
  self.threeMatchSwitch.userInteractionEnabled = self.game.enableModeChange;
  [self animateRearangeCards];
  [self removeChosenCards];
}

- (void)removeChosenCards {
  NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
  NSMutableArray *viewsOfChosenCards = [[NSMutableArray alloc] init];
  
  for (Card *card in self.cardsOnTable) {
    if(card.matched) {
      NSUInteger indexInCardsOnTable = [self.cardsOnTable indexOfObject:card];
      CardView *cardView = [self.cardViewsOnTable objectAtIndex:indexInCardsOnTable];
      [chosenCards addObject:card];
      [viewsOfChosenCards addObject:cardView];
    }
  }
  [self.cardsOnTable removeObjectsInArray: chosenCards];
  [self.cardViewsOnTable removeObjectsInArray: viewsOfChosenCards];
}

- (void) animateRearangeCards {
  NSArray *frames = [self calculateNewLocationsOfCards]; //array of frames (CGRect)
  [UIView animateWithDuration:ANIMATION_DURATION
                        delay:0
                      options:UIViewAnimationOptionBeginFromCurrentState&UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     for (Card *card in self.cardsOnTable) {
                       NSUInteger indexInCardsOnTable = [self.cardsOnTable indexOfObject:card];
                       CardView *cardView = [self.cardViewsOnTable objectAtIndex:indexInCardsOnTable];{}
                       CGRect destanationFrame = [[frames objectAtIndex:indexInCardsOnTable] CGRectValue];
                       cardView.frame = destanationFrame;
                     }
                   } completion:^(BOOL finished) {
                     for (Card *card in self.cardsOnTable) {
                       NSUInteger indexInCardsOnTable = [self.cardsOnTable indexOfObject:card];
                       CardView *cardView = [self.cardViewsOnTable objectAtIndex:indexInCardsOnTable];
                       if (card.matched) {
                         [cardView removeFromSuperview];
                       }
                     }
                   }];
}

- (NSArray *) calculateNewLocationsOfCards {

  self.grid.minimumNumberOfCells = [self unmatchedCardsCount];

  NSMutableArray *frames = [[NSMutableArray alloc] init]; //array of frames (CGRect)
  int i = 0;
  for (Card *card in self.cardsOnTable) {
    NSUInteger indexInCardsOnTable = [self.cardsOnTable indexOfObject:card];
    CardView *cardView = [self.cardViewsOnTable objectAtIndex:indexInCardsOnTable];
    CGRect frame;
    if (card.matched) {
      frame = CGRectMake(-100, -100 , cardView.frame.size.width, cardView.frame.size.height);
    }
    else {
      frame = [self.grid frameOfCellAtIndex:i];
      frame.size.height *= 0.9;
      frame.size.width *= 0.9;
      i++;
    }
    [frames addObject:[NSValue valueWithCGRect:frame]];
  }
  return frames;
}

- (NSUInteger) unmatchedCardsCount {
  NSUInteger minimumNumberOfCells = 0;
  for (Card *card in self.cardsOnTable) {
    if (!card.matched) {
      minimumNumberOfCells++;
    }
  }
  return minimumNumberOfCells;
}

// rename or split because this function also adds behaviour to cardview
- (CardView*) ViewForCard: (Card*) card WithFrame: (CGRect)aRect {
  CardView *cardView = [[CardView alloc] initWithFrame:aRect];
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)];
  [cardView addGestureRecognizer:tapGestureRecognizer];
  return cardView;
}

// rename or split because this function also adds behaviour to deckview
- (void) getViewForDeckWithFrame: (CGRect)aRect {
  self.deckView.faceUp = NO;
  UITapGestureRecognizer *tapDeckGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDeck:)];
  [self.deckView addGestureRecognizer:tapDeckGestureRecognizer];
}

#pragma mark - actions

- (IBAction) threeMatchSwitch:(id)sender {
  BOOL isOn = [sender isOn];
  self.game.matchSize = (isOn)? 3:2;
  [self updateUI];
}

- (IBAction) touchResetButton:(id) sender {
  [self startNewGame];
  [self updateUI];
}

- (IBAction)tapCard:(UITapGestureRecognizer *)sender {
  CardView *cardView = (CardView *)sender.view;
  NSUInteger cardIndex = [self.cardViewsOnTable indexOfObject:cardView];
  Card *card = [self.cardsOnTable objectAtIndex:cardIndex];
  [self.game FlipCard: card];
  [self FlipCardView: cardView];
  [self updateUI];
}

- (void) FlipCardView: (CardView *) cardView { }

- (IBAction)tapDeck:(UITapGestureRecognizer *)sender {
//  [self.game dealThreeMoreCards];
  [self addCardsToTable: [self.game dealThreeMoreCards]];
  [self updateUI];
}

- (void) addCardsToTable:(NSArray *) cardsToAdd {
  for (Card *card in cardsToAdd) {
    [self.cardsOnTable addObject:card];
    CardView* cardView = [self ViewForCard:card WithFrame:self.deckView.frame];
    [self.cardViewsOnTable addObject:cardView];
    [self.gameView addSubview:cardView];
  }
  [self updateUI];
}

#pragma mark - geters lazy instantiation

- (NSMutableArray *)cardViewsOnTable {
  if(!_cardViewsOnTable){
    _cardViewsOnTable = [[NSMutableArray alloc] init];
  }
  return _cardViewsOnTable;
}

- (Grid *)grid {
  if(!_grid){
    _grid = [[Grid alloc] init];
    _grid.cellAspectRatio = CARDS_ASPECT_RATIO;
    _grid.size = self.gameView.bounds.size;
    _grid.minimumNumberOfCells = CARDS_IN_GAME;
  }
  return _grid;
}

- (Deck*) createDeck { //abstruct
  return nil;
}

- (NSMutableArray *)cardsOnTable {
  if(!_cardsOnTable) {
    _cardsOnTable = [[NSMutableArray alloc] init];
  }
  return _cardsOnTable;
}

- (MatchingGame*) game {
  if (!_game) {
    _game = [[MatchingGame alloc] initWithCardCount:CARDS_IN_GAME UsingDeck:[self createDeck]];
  }
  return _game;
}

@end
