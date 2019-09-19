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

@property (strong, nonatomic) NSMutableAttributedString *comentery;

@property (strong, nonatomic) NSMutableArray *selectedCards; //Card

@property (strong, nonatomic, readwrite) NSAttributedString *history;

+(NSMutableArray*)dealCards: (NSUInteger) numOfCards UsingDeck: (Deck*) deck;

+(NSMutableAttributedString*)getStringOfCards:(NSMutableArray*) cards;

-(void)handleMatch;

-(void)handleMismatch: (Card*) currentCard;

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

- (NSMutableAttributedString*) comentery {
  if(!_comentery){
    _comentery = [[NSMutableAttributedString alloc] init];
  }
  return _comentery;
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
      self.cards = cards;
      self.enableModeChange = YES;
      self.matchSize = 2;
    }
  }
  self.comentery = [[NSMutableAttributedString alloc] init];
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

- (void) resetGameWithCardCount: (NSUInteger) numOfCards UsingDeck: (Deck*) deck {
  NSMutableArray* cards = [MatchingGame dealCards:numOfCards UsingDeck:deck];
  self.score = 0;
  self.cards = cards;
  self.currentChosenCount = 0;
  self.matchSize = 2;
  self.enableModeChange = YES;
  self.comentery = [[NSMutableAttributedString alloc] init];
  //    [[self.comentery mutableString] appendString:@"\n"];
  self.selectedCards = [[NSMutableArray alloc] init];
}

- (Card*) getCardAtIndex: (NSUInteger) index {
  return (index < [self.cards count])? self.cards[index] : nil;
}

- (void) FlipCardAtIndex: (NSUInteger) index {
  
  // if we make a move, disable mode change
  self.enableModeChange = NO;
  // init commentery string
  self.comentery = [[NSMutableAttributedString alloc] init];
  // get chosen card
  Card* currentCard = [self getCardAtIndex:index];
  
  if (currentCard.matched) {
    [self.comentery appendAttributedString: currentCard.contents];
    [self.comentery appendAttributedString:[[NSAttributedString alloc] initWithString:@" is already matched\n"]];
  }
  else if (currentCard.chosen) {
    [self.selectedCards removeObject:currentCard];
    currentCard.chosen = NO;
    [self.comentery appendAttributedString:[[NSAttributedString alloc] initWithString:@"you just unselected "]];
    [self.comentery appendAttributedString: currentCard.contents];
    [self.comentery appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
  }
  else {
    // first select card
    currentCard.chosen = YES;
    [self.selectedCards addObject:currentCard];
    self.score -= STEP_PENALTY;
    [self.comentery appendAttributedString:[[NSAttributedString alloc] initWithString:@"you just selected "]];
    [self.comentery appendAttributedString: currentCard.contents];
    [self.comentery appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
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
    [self.comentery appendAttributedString:[[NSAttributedString alloc] initWithString:@"The currently selected cards are: "]];
    [self.comentery appendAttributedString: [MatchingGame getStringOfCards: self.selectedCards]];
  }
  
}

- (void) handleMatch {
  NSMutableAttributedString *comment = [MatchingGame getStringOfCards:self.selectedCards];
  [comment appendAttributedString:[[NSAttributedString alloc] initWithString: @"were a match!\n"]];
  [self.comentery appendAttributedString: comment];
  [self appendToHistory: comment];
  
  for(Card* card in self.selectedCards){
    card.chosen = NO;
    card.matched = YES;
  }
  [self.selectedCards removeAllObjects];
}

- (void) handleMismatch: (Card* ) currentCard {
  NSMutableAttributedString *comment = [[NSMutableAttributedString alloc] initWithString:@"sadly "];
  [comment appendAttributedString: [MatchingGame getStringOfCards:self.selectedCards]];
  [comment appendAttributedString:[[NSAttributedString alloc] initWithString:@"are NOT a match\n"]];
  [self.comentery appendAttributedString: comment];
  [self appendToHistory: comment];
  
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

- (NSAttributedString*) history {
  if (!_history){
    _history = [[NSAttributedString alloc] init];
  }
  return _history;
}

- (void) appendToHistory: (NSAttributedString*) event {
  NSMutableAttributedString *mutableHistory = [self.history mutableCopy];
  [mutableHistory appendAttributedString:event];
  self.history = [mutableHistory copy];
}

@end





















// for match of size two

//    PlayingCard* currentCard = [self getCardAtIndex:index];
//    // if we flip down or already matched do nothing
//    if(!currentCard.chosen && !currentCard.matched){
//        // deduct score for every peak
//        self.score -=STEP_PENALTY;
//        // go over all cards and look for a faceup card
//        for(PlayingCard* otherCard in self.cards){
//            if(otherCard.chosen && !otherCard.matched){
//                otherCard.chosen = NO;
//                int matchScore = [currentCard Matched:@[otherCard]];
//                self.score += (MATCH_BONUS*matchScore);
//                if (matchScore>0){
//                    otherCard.matched = YES;
//                    currentCard.matched = YES;
//                }
//                else{
//                    self.score-=MISMATCH_PENALTY;
//                }
//                break;
//            }
//        }
//    }
//    //flip chosen card
//    currentCard.chosen = !currentCard.chosen;


