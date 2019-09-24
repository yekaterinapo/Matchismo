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

@property (strong, nonatomic) NSMutableArray *cardViewsOnTable; /// array of CardViews

@property (strong, nonatomic) NSMutableArray *cardsOnTable; /// array of Cards

@property (strong, nonatomic) CardView *deckView;

@property (strong, nonatomic) Grid *grid;

@end

@implementation MatchingGameViewController

- (void)viewDidLoad {
  [self startNewGame];
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

- (NSMutableArray *)cardsOnTable {
  if(!_cardsOnTable) {
    _cardsOnTable = [[NSMutableArray alloc] init];
  }
  return _cardsOnTable;
}

- (Deck*) createDeck { //abstruct
  Deck *deck = [[Deck alloc] init];
  for(int i = 1; i<20; i++){
    [deck addCardToDeck:[[Card alloc] init]];
  }
  return deck;
//  return nil; // [[PlayDeck alloc] init];
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
  // remove all cards frome table
  [self removeCardsFromTable:[self.cardsOnTable copy]]; //copy because selector operates on cardsOnTable
  //deal new cards
  Deck* deck = [self createDeck];
  [self.game resetGameWithCardCount: CARDS_IN_GAME UsingDeck: deck];
  [self addCardsToTable:self.game.cards];
  [self.view setNeedsDisplay];
}

- (void)addCardsToTable:(NSArray *)cardsToAdd {
  for (Card *card in cardsToAdd) {
    [self.cardsOnTable addObject:card];
    NSUInteger index = [self.cardsOnTable indexOfObject:card];
    CGRect aRect = [self.grid frameOfCellAtIndex:index];
    aRect.size.height *= 0.9;
    aRect.size.width *= 0.9;
    CardView *cardView = [self getViewForCard:card WithFrame:aRect];
    [self.cardViewsOnTable addObject:cardView];
    [self.gameView addSubview:cardView];
  }
}

- (void)removeCardsFromTable:(NSArray *)cardsToRemove {
  // now we have to reassemble cards so we will remove all cardsViews and put them back in place
  [[self.gameView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self.cardViewsOnTable removeAllObjects];
  // remove cards from lists
  for (Card *card in cardsToRemove) {
    [self.cardsOnTable removeObject:card];
  }
  //create views
  for (Card *card in self.cardsOnTable) {
    NSUInteger index = [self.cardsOnTable indexOfObject:card];
    CGRect aRect = [self.grid frameOfCellAtIndex:index];
    aRect.size.height *= 0.9;
    aRect.size.width *= 0.9;
    CardView *cardView = [self getViewForCard:card WithFrame:aRect];
    [self.cardViewsOnTable addObject:cardView];
    [self.gameView addSubview:cardView];
  }
}


- (MatchingGame*) game {
  if (!_game) {
    _game = [[MatchingGame alloc] initWithCardCount:CARDS_IN_GAME UsingDeck:[self createDeck]];
  }
  return _game;
}

- (void) updateUI {
  [self.scoreLable setText: [NSString stringWithFormat:@"score: %d", (int)self.game.score]];
  
  
  // update mode switch
  self.threeMatchSwitch.userInteractionEnabled = self.game.enableModeChange;
  // update all the buttons
  /////////////////////////////////////////////////////////////
  for (CardView* cardView in self.cardViewsOnTable) {
    // get the index of the button
    NSUInteger cardIndex = [self.cardViewsOnTable indexOfObject:cardView];
    Card *card = [self.game getCardAtIndex:cardIndex];
    cardView.faceUp = card.chosen;
    cardView.alpha = (card.matched)? 0.6:1;
    [self.scoreLable setText: [NSString stringWithFormat:@"score: %d", (int)self.game.score]];
  }
}

// rename or split because this function also adds behaviour to cardview
- (CardView*) getViewForCard: (Card*) card WithFrame: (CGRect)aRect {
  CardView *cardView = [[CardView alloc] initWithFrame:aRect];
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)];
  [cardView addGestureRecognizer:tapGestureRecognizer];
  return cardView;
}

// rename or split because this function also adds behaviour to deckview
- (CardView*) getViewForDeckWithFrame: (CGRect)aRect {
  CardView *deckView = [[CardView alloc] initWithFrame:aRect];
  self.deckView.faceUp = NO;
  UITapGestureRecognizer *tapDeckGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDeck:)];
  [self.deckView addGestureRecognizer:tapDeckGestureRecognizer];
  return deckView;
}

- (IBAction)tapCard:(UITapGestureRecognizer *)sender {
  CardView *cardView = (CardView *)sender.view;
  NSUInteger cardIndex = [self.cardViewsOnTable indexOfObject:cardView];
//  Card *card = [self.game getCardAtIndex:cardIndex];
  [self.game FlipCardAtIndex:cardIndex];
  [self updateUI];
}

- (IBAction)tapDeck:(UITapGestureRecognizer *)sender {
  [self.game dealThreeMoreCards];
  [self addCardsToTable: [self.game dealThreeMoreCards]];
  [self updateUI];
}


@end
