//
//  ViewController.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "MatchingGameViewController.h"
#import "Grid.h"

@interface MatchingGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLable;

@property (weak, nonatomic) IBOutlet UISwitch *threeMatchSwitch;

@property (strong, nonatomic) NSMutableArray *cardsOnTable; /// array of Cards

@property (weak, nonatomic) IBOutlet CardView *deckView;

@property (strong, nonatomic) Grid *grid;

@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehaviour;

@property (strong, nonatomic) UIView *collectedCardsView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapDeckGestureRecognizer;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapCardGestureRecognizer;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapCardCollectionGestureRecognizer;

@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchCardsGestureRecognizer;

@end

@implementation MatchingGameViewController

- (void)viewDidLoad {
  [self startNewGame];
  self.view.userInteractionEnabled = YES;
  self.gameView.userInteractionEnabled = YES;
  [self.view addGestureRecognizer:self.pinchCardsGestureRecognizer];
}

- (void)viewDidLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.grid.size = self.gameView.frame.size;
  if (self.collectedCardsView.frame.size.height == 0 && self.collectedCardsView.frame.size.width == 0 ) {
    for (Card *card in self.cardsOnTable) {
      NSUInteger index = [self.cardsOnTable indexOfObject:card];
      CardView *cardView = [self.cardViewsOnTable objectAtIndex:index];
      CGRect cardFrame = [self cardFrameFromGridAtIndex:index];
      [cardView setFrame:cardFrame];
      [cardView layoutIfNeeded];
    }
  }
  else {
    self.collectedCardsView.frame = [self cardFrameFromGridAtIndex:0];
    self.collectedCardsView.center  = CGPointMake(self.view.frame.size.width  / 2,
                                                  self.view.frame.size.height / 2);
    for (UIView *subView in self.collectedCardsView.subviews) {
      CGRect frame = CGRectMake(subView.frame.origin.x, subView.frame.origin.y, self.collectedCardsView.frame.size.width, self.collectedCardsView.frame.size.height);
      subView.frame = frame;
    }
  }
}

- (void)startNewGame {
  [self removeCardsFromTable:[self.cardsOnTable copy]]; //copy because removeCardsFromTable operates on cardsOnTable
  self.collectedCardsView = nil;
  Deck* deck = [self createDeck];
  [self.game resetGameWithCardCount: CARDS_IN_GAME usingDeck: deck];
  [self addCardsToTable:self.game.cards];
  [self.tapDeckGestureRecognizer setEnabled: YES];
  [self.tapCardGestureRecognizer setEnabled: YES];
}

- (void)removeCardsFromTable:(NSArray *)cardsToRemove {
  for (Card *card in cardsToRemove) {
    NSUInteger indexInCardsOnTable = [self.cardsOnTable indexOfObject:card];
    [self.cardsOnTable removeObject:card];
    [self.cardViewsOnTable removeObjectAtIndex:indexInCardsOnTable];
    [[self.gameView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
  }
}

#define ANIMATION_DURATION 3
- (void)updateUI {
  self.grid.size = self.gameView.frame.size;
  [self.scoreLable setText: [NSString stringWithFormat:@"score: %d", (int)self.game.score]];
  self.threeMatchSwitch.userInteractionEnabled = self.game.enableModeChange;
  for (CardView *cardView in self.cardViewsOnTable) {
    NSUInteger index = [self.cardViewsOnTable indexOfObject:cardView];
    Card *card = [self.cardsOnTable objectAtIndex:index];
    if (card.chosen != cardView.faceUp) {
      [cardView flip];
    }
  }
  [self animateRearangeCards]; //TODO rename
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

- (void)animateRearangeCards {
  NSArray *frames = [self calculateNewLocationsOfCards]; //array of frames (CGRect)
  [UIView animateWithDuration:ANIMATION_DURATION
                        delay:0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     for (Card *card in self.cardsOnTable) {
                       NSUInteger indexInCardsOnTable =
                          [self.cardsOnTable indexOfObject:card];
                       CardView *cardView =
                          [self.cardViewsOnTable objectAtIndex:indexInCardsOnTable];
                       CGRect destanationFrame =
                          [[frames objectAtIndex:indexInCardsOnTable] CGRectValue];
                       [cardView setFrame:destanationFrame];
                       [cardView layoutIfNeeded];
                     }
                   } completion:^(BOOL finished) {
                     for (Card *card in self.cardsOnTable) {
                       NSUInteger indexInCardsOnTable = [self.cardsOnTable indexOfObject:card];
                       CardView *cardView =
                          [self.cardViewsOnTable objectAtIndex:indexInCardsOnTable];
                       if (card.matched) {
                         [cardView removeFromSuperview];
                       }
                     }
                   }];
}

- (NSArray *)calculateNewLocationsOfCards {
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
      frame = [self cardFrameFromGridAtIndex:i];
      i++;
    }
    [frames addObject:[NSValue valueWithCGRect:frame]];
  }
  return frames;
}

- (NSUInteger)unmatchedCardsCount {
  NSUInteger minimumNumberOfCells = 0;
  for (Card *card in self.cardsOnTable) {
    if (!card.matched) {
      minimumNumberOfCells++;
    }
  }
  return minimumNumberOfCells;
}

- (IBAction)pinchCards:(UIPinchGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
    CGPoint pinchCenter = [sender locationInView:self.view];
    [self.tapDeckGestureRecognizer setEnabled: NO];
    [self.tapCardGestureRecognizer setEnabled: NO];
    [self collectCardsToPoint: pinchCenter];
  }
}

- (IBAction)panColectedCards:(UIPanGestureRecognizer *)sender {
  CGPoint gesturePoint = [sender locationInView:self.gameView];
  if (sender.state == UIGestureRecognizerStateBegan) {
    self.attachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:self.collectedCardsView attachedToAnchor:gesturePoint];
    [self.animator addBehavior:self.attachmentBehaviour];
  }
  else if (sender.state == UIGestureRecognizerStateChanged) {
    self.attachmentBehaviour.anchorPoint = gesturePoint;
  }
  else if (sender.state == UIGestureRecognizerStateEnded) {
    [self.animator removeBehavior:self.attachmentBehaviour];
  }
}

- (IBAction)tapOnColectedCards:(UITapGestureRecognizer *)sender {
  [self restoreCardsFropCenterOfTable];
  [self.tapDeckGestureRecognizer setEnabled: YES];
  [self.tapCardGestureRecognizer setEnabled: YES];
}

- (void)collectCardsToPoint:(CGPoint)pinchCenter {
  self.collectedCardsView.frame = ((CardView *)self.cardViewsOnTable.firstObject).frame;
  self.collectedCardsView.backgroundColor = UIColor.blueColor;
  [self.collectedCardsView setOpaque:NO];
  self.collectedCardsView.center = pinchCenter;
  [self.view addSubview:self.collectedCardsView];
  CardView *lastCard = [self.cardViewsOnTable lastObject];
  [lastCard addGestureRecognizer:self.tapCardCollectionGestureRecognizer];
  for (CardView *cardView in self.cardViewsOnTable) {
    [cardView removeGestureRecognizer:self.tapCardGestureRecognizer];
  }
  UIPanGestureRecognizer *panGestureRecognizer =
  [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panColectedCards:)];
  [self.collectedCardsView addGestureRecognizer:panGestureRecognizer];
  [self animateColectingCards];
}

- (void)animateColectingCards {
  CGRect destanationFrame =self.collectedCardsView.frame;
  [self releaseViews:self.cardViewsOnTable from:self.gameView To:self.view];
  [UIView animateWithDuration:ANIMATION_DURATION
                        delay:0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     for (CardView *cardView in self.cardViewsOnTable) {
                       [cardView setFrame:destanationFrame];
                     }
                   } completion:^(BOOL finished) {
                     [self encapsulateViews:self.cardViewsOnTable intoView:self.collectedCardsView];
                   }
   ];
}

- (void)restoreCardsFropCenterOfTable {
  [self releaseViews:self.cardViewsOnTable from:self.collectedCardsView To:self.view];
  [self encapsulateViews:self.cardViewsOnTable intoView:self.gameView];
  [self.collectedCardsView removeFromSuperview];
  self.collectedCardsView = nil;
  [UIView animateWithDuration:ANIMATION_DURATION
                        delay:0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     for (CardView *cardView in self.cardViewsOnTable) {
                       NSUInteger index = [self.cardViewsOnTable indexOfObject:cardView];
                       CGRect cardViewFrame = [self cardFrameFromGridAtIndex:index];
                       [cardView setFrame:cardViewFrame];
                     }
                   } completion:^(BOOL finished) {
                   }
   ];
}

// make \subViews be subviews of \EncapsulatingView without changing their position on story board.
// \EncapsulatingView must be a subview of the current superview of subViews
- (void)encapsulateViews:(NSArray *)subViews intoView:(UIView *)EncapsulatingView {
  for (UIView *subView in subViews) {
    subView.frame = CGRectMake(subView.frame.origin.x - EncapsulatingView.frame.origin.x,
                               subView.frame.origin.y - EncapsulatingView.frame.origin.y,
                               subView.frame.size.width,
                               subView.frame.size.height);
    [EncapsulatingView addSubview: subView];
  }
}

// make \subViews be subviews of \CommonSuperView without changing their position on story board.
// \EncapsulatingView must be a subview of CommonSuperView
// \EncapsulatingView must be a superview of \subViews
- (void)releaseViews:(NSArray *)subViews from:(UIView *)EncapsulatingView To:(UIView *)CommonSuperView {
  for (UIView *subView in subViews) {
    subView.frame = CGRectMake(subView.frame.origin.x + EncapsulatingView.frame.origin.x,
                               subView.frame.origin.y + EncapsulatingView.frame.origin.y,
                               subView.frame.size.width,
                               subView.frame.size.height);
    [CommonSuperView addSubview:subView];
  }
}

- (IBAction)threeMatchSwitch:(id)sender {
  BOOL isOn = [sender isOn];
  self.game.matchSize = (isOn)? 3:2;
  [self updateUI];
}

- (IBAction)touchResetButton:(id)sender {
  [self startNewGame];
  [self updateUI];
}

- (IBAction)tapDeck:(UITapGestureRecognizer *)sender {
  [self addCardsToTable: [self.game dealThreeMoreCards]];
  [self updateUI];
}

- (void)addCardsToTable:(NSArray *)cardsToAdd {
  for (Card *card in cardsToAdd) {
    [self.cardsOnTable addObject:card];
    CardView* cardView = [self viewForCard:card withFrame:self.deckView.frame];
    [self.cardViewsOnTable addObject:cardView];
    [self.gameView addSubview:cardView];
  }
}

- (CardView*)viewForCard:(Card*)card withFrame:(CGRect)aRect {
  CardView *cardView = [[CardView alloc] initWithFrame:aRect];
  [cardView addGestureRecognizer:self.tapCardGestureRecognizer];
  cardView.userInteractionEnabled = YES;
  return cardView;
}

- (NSMutableArray *)cardViewsOnTable {
  if(!_cardViewsOnTable){
    _cardViewsOnTable = [[NSMutableArray alloc] init];
  }
  return _cardViewsOnTable;
}

- (NSMutableArray *)cardsOnTable {
  if(!_cardsOnTable) {
    _cardsOnTable = [[NSMutableArray alloc] init];
  }
  return _cardsOnTable;
}

- (MatchingGame*)game {
  if (!_game) {
    _game = [[MatchingGame alloc] initWithCardCount:CARDS_IN_GAME usingDeck:[self createDeck]];
  }
  return _game;
}

- (Deck*)createDeck { //abstruct
  return nil;
}

- (UIDynamicAnimator *)animator {
  if (!_animator) {
    _animator = [[UIDynamicAnimator alloc] init];
  }
  return _animator;
}

- (UITapGestureRecognizer *)tapCardGestureRecognizer {
  if (!_tapCardGestureRecognizer) {
    _tapCardGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)];
  }
  return _tapCardGestureRecognizer;
}

- (IBAction)tapCard:(UITapGestureRecognizer *)sender {
  CardView *cardView = (CardView *)sender.view;
  NSUInteger cardIndex = [self.cardViewsOnTable indexOfObject:cardView];
  Card *card = [self.cardsOnTable objectAtIndex:cardIndex];
  [self.game flipCard: card];
  [self updateUI];
}

- (UITapGestureRecognizer *)tapCardCollectionGestureRecognizer {
  if (!_tapCardCollectionGestureRecognizer) {
    _tapCardCollectionGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnColectedCards:)];
  }
  return _tapCardCollectionGestureRecognizer;
}

- (UIPinchGestureRecognizer *)pinchCardsGestureRecognizer {
  if (!_pinchCardsGestureRecognizer) {
    _pinchCardsGestureRecognizer =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchCards:)];
  }
  return _pinchCardsGestureRecognizer;
}

- (UIView *)collectedCardsView {
  if (!_collectedCardsView) {
    _collectedCardsView = [[UIView alloc] init];
  }
  _collectedCardsView.backgroundColor = nil;
  [_collectedCardsView setOpaque:NO];
  return _collectedCardsView;
}

- (CGRect)cardFrameFromGridAtIndex:(NSUInteger)index {
  CGRect frame = [self.grid frameOfCellAtIndex:index];
  frame.size.height *= 0.9;
  frame.size.width *= 0.9;
  return frame;
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

@end
