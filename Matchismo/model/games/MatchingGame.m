//
//  MatchingGame.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 04/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "MatchingGame.h"
static const int STEP_PENALTY = 1;


@interface MatchingGame()

@property (nonatomic, readwrite) NSInteger score;

@property (nonatomic) NSUInteger currentChosenCount;

@property (nonatomic, readwrite) BOOL enableModeChange;

@property (strong, nonatomic) NSMutableArray *selectedCards; //Card

@property (nonatomic, readwrite) Deck *deck;

@end
@implementation MatchingGame

- (NSInteger) matchScore: (NSArray*) cards{
  NSInteger score = 0;
  for(Card* card1 in cards){
    for(Card* card2 in cards){
      if(card1 == card2){
        continue;
      }
      if([[card1.contents string] isEqualToString: [card2.contents string]]){
        score = 1;
        break;
      }
    }
  }
  return score;
}

- (NSMutableArray*) cards {
  if (!_cards) {
    _cards = [[NSMutableArray alloc] init];
  }
  return _cards;
}

- (NSMutableArray*) selectedCards {
  if (!_selectedCards) {
    _selectedCards = [[NSMutableArray alloc] init];
  }
  return _selectedCards;
}

- (instancetype) initWithCardCount: (NSUInteger) numOfCards UsingDeck: (Deck*) deck {
  self = [super init];
  if (self) {
    // draw an array of random cards from the deck
    NSMutableArray *cards = [MatchingGame dealCards: numOfCards UsingDeck: deck];
    if(!cards){
      self = nil;
    }
    else{
      self.deck = deck;
      self.cards = cards;
      self.enableModeChange = YES;
      self.matchSize = 2;
    }
  }
  return self;
}

+ (NSMutableArray*) dealCards: (NSUInteger) numOfCards UsingDeck: (Deck*) deck {
  // draw an array of random cards from the deck
  NSMutableArray* cards = [[NSMutableArray alloc] init];
  for(int i = 1; i<=numOfCards; i++){
    Card * card = [deck drawRandomCard];
    if(card){
      [cards addObject:card];
    }
    else{
      cards = nil;
      break;
    }
  }
  return cards;
}

- (NSArray *) dealThreeMoreCards {
  NSMutableArray *addedCards = [[NSMutableArray alloc] init];
  for(int i = 1; i<=3; i++){
    Card * card = [self.deck drawRandomCard];
    if(card){
      [addedCards addObject:card];
      [self.cards addObject:card];
    }
    else{
      break;
    }
  }
  return addedCards;
}

- (void) resetGameWithCardCount: (NSUInteger) numOfCards UsingDeck: (Deck*) deck {
  NSMutableArray* cards = [MatchingGame dealCards:numOfCards UsingDeck:deck];
  self.score = 0;
  self.cards = cards;
  self.currentChosenCount = 0;
  self.matchSize = 2;
  self.enableModeChange = YES;
  self.selectedCards = [[NSMutableArray alloc] init];
}

- (Card*) getCardAtIndex: (NSUInteger) index {
  return (index < [self.cards count])? self.cards[index] : nil;
}

- (void) FlipCard: (Card *) card {
  NSUInteger indexOfCard = [self.cards indexOfObject:card];
  [self FlipCardAtIndex: indexOfCard];
}

- (void) FlipCardAtIndex: (NSUInteger) index {
  
  // if we make a move, disable mode change
  self.enableModeChange = NO;
  // init commentery string
  // get chosen card
  Card* currentCard = [self getCardAtIndex:index];
  
  if (currentCard.matched) {
  }
  else if (currentCard.chosen) {
    [self.selectedCards removeObject:currentCard];
    currentCard.chosen = NO;
  }
  else {
    // first select card
    currentCard.chosen = YES;
    [self.selectedCards addObject:currentCard];
    self.score -= STEP_PENALTY;
    // if reached matchSize attempt to make a match
    if (self.matchSize == [self.selectedCards count]) {
      NSInteger matchScore = [self matchScore: self.selectedCards];
      self.score += matchScore;
      if (matchScore>0) { // if there was a match
        [self handleMatch];
      }
      else {
        [self handleMismatch: currentCard];
      }
    }
    
  }
  
  if ([self.selectedCards count] > 0) {
  }
  
}

- (void) handleMatch {
  for(Card* card in self.selectedCards){
    card.chosen = NO;
    card.matched = YES;
  }
  [self.selectedCards removeAllObjects];
}

- (void) handleMismatch: (Card* ) currentCard {
  for(Card* card in self.selectedCards){
    card.chosen = NO;
  }
  [self.selectedCards removeAllObjects];
  currentCard.chosen = YES;
  [self.selectedCards addObject:currentCard];
}

+(NSMutableAttributedString*)getStringOfCards: (NSMutableArray*) cards{
  NSMutableAttributedString* cardString = [[NSMutableAttributedString alloc] init];
  for(Card *card in cards){
    [cardString appendAttributedString:card.contents];
    [cardString appendAttributedString:[[NSAttributedString alloc] initWithString:@"   "]];
  }
  return cardString;
}

@end
