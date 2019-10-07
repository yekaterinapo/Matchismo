//
//  MatchingGame.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 04/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN
/// A Card Matching Game. Given a deck of cards, are randomly picked to be placed on the table.
/// the player may select\unselect cards from the cards on the table using \flipCardAtIndex.
/// selecting a selected card, unselects the card
/// when \matchSize cards are chosen, the match is evaluated and the \score is updated.
/// if there was a match the cards are marked as matched and are unselected
/// if there wasn't a match all cards are unselected except the last card that was selected
/// 3 additional cards may be added using \dealThreeMoreCards

@interface MatchingGame : NSObject
// designated initializer, numOfCards is the initial number of cards on the table
- (instancetype)initWithCardCount:(NSUInteger)numOfCards usingDeck:(Deck*)deck;
// returns a card from the table at index \index
- (Card*)getCardAtIndex:(NSUInteger)index;
// Change the selected state of the card at index and calculate the next state of the game
- (void)flipCardAtIndex:(NSUInteger)index;
// begin a new game with a new deck and initial number of cards to be placed on the table
- (void)resetGameWithCardCount:(NSUInteger)numOfCards usingDeck:(Deck*)deck;
// Return the score of the match of \cards
- (NSInteger)matchScore:(NSArray*)cards;
// Add 3 more cards to the table from the \deck. if there are no more cards in the deck, do nothing
- (NSArray *)dealThreeMoreCards;
// Change the selected state of the Card \card and calculate the next state of the game
- (void)flipCard:(Card *)card;
// The list of cards on the table
@property (strong, nonatomic) NSMutableArray* cards; // of Card
// the score of the game
@property (nonatomic, readonly) NSInteger score;
// enable changing the \matchSize
@property (nonatomic, readonly) BOOL enableModeChange;
// the number of cards that need to be selected to evaluate a match
@property (nonatomic, readwrite) NSUInteger matchSize;
// the deck from which cards are drawn to add to the table
@property (nonatomic, readonly) Deck *deck;

@end

NS_ASSUME_NONNULL_END
