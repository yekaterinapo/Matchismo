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

- (Deck*) createDeck { //abstruct
  Deck *deck = [[Deck alloc] init];
  for(int i = 1; i<20; i++){
    [deck addCardToDeck:[[Card alloc] init]];
  }
  return deck;
//  return nil; // [[PlayDeck alloc] init];
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
  
  // add deck view
  CGRect deckFrame = CGRectMake(self.gameView.frame.origin.x, self.gameView.frame.size.height + self.gameView.frame.origin.y,
                                0.9*self.grid.cellSize.width, 0.9*self.grid.cellSize.height);
  self.deckView = [self getViewForDeckWithFrame:deckFrame];
  [self.view addSubview:self.deckView];
  [self.view setNeedsDisplay];
}

- (void) addCardsToTable:(NSArray *) cardsToAdd {
  for (Card *card in cardsToAdd) {
    [self.cardsOnTable addObject:card];
  }
  [self updateUI];
}

- (void)removeCardsFromTable:(NSArray *) cardsToRemove {
  for (Card *card in cardsToRemove) {
    [self.cardsOnTable removeObject:card];
  }
  [self updateUI];
}

- (void) updateUI {
  [self.scoreLable setText: [NSString stringWithFormat:@"score: %d", (int)self.game.score]];
  
  // update mode switch
  self.threeMatchSwitch.userInteractionEnabled = self.game.enableModeChange;

  self.grid.minimumNumberOfCells = [self.cardsOnTable count];
  [[self.gameView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self.cardViewsOnTable removeAllObjects];
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
  deckView.faceUp = NO;
  UITapGestureRecognizer *tapDeckGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDeck:)];
  [deckView addGestureRecognizer:tapDeckGestureRecognizer];
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
