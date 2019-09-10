//
//  MatchingGame.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 04/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "MatchingGame.h"
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int STEP_PENALTY = 1;


@interface MatchingGame()
@property(nonatomic, readwrite) NSInteger score;
@property(nonatomic) NSUInteger currentChosenCount;
@property(nonatomic, readwrite) BOOL enableModeChange;
@property (strong, nonatomic) NSMutableString *comentery;
@property (strong, nonatomic) NSMutableArray *selectedCards; //PlayingCards
+(NSInteger) cardsMatchScore: (NSMutableArray*) cards;
+(NSMutableArray*)dealCards: (NSUInteger) numOfCards UsingDeck: (Deck*) deck;
+(NSMutableString*)getStringOfCards:(NSMutableArray*) cards;
-(void)handleMatch;
-(void)handleMismatch: (PlayingCard*) currentCard;


@end
@implementation MatchingGame

-(NSMutableArray*) cards{
    if(!_cards){
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

-(NSMutableArray*)selectedCards{
    if(!_selectedCards){
        _selectedCards = [[NSMutableArray alloc] init];
    }
    return _selectedCards;
}


-(NSMutableString*)comentery{
    if(!_comentery){
        _comentery = [@"" mutableCopy];
    }
    return _comentery;
}


-(instancetype)initWithCardCount: (NSUInteger) numOfCards UsingDeck: (Deck*) deck{
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
    self.comentery = [@"" mutableCopy];
    return self;
}


+(NSMutableArray*)dealCards: (NSUInteger) numOfCards UsingDeck: (Deck*) deck{
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



+(NSInteger) cardsMatchScore: (NSMutableArray*) cards {
    NSInteger score = 0;
    for(Card* card1 in cards){
        for(Card* card2 in cards){
            if([cards indexOfObject:card1 ] == [cards indexOfObject:card2]){
                continue;
            }
            else {
                score += MATCH_BONUS*[card1 Matched:@[card2]];
            }
        }
    }
    if(score == 0){
        score-=MISMATCH_PENALTY;
    }
    
    return score;
    
}


-(void)resetGameWithCardCount: (NSUInteger) numOfCards UsingDeck: (Deck*) deck{
    NSMutableArray* cards = [MatchingGame dealCards:numOfCards UsingDeck:deck];
    self.score = 0;
    self.cards = cards;
    self.currentChosenCount = 0;
    self.matchSize = 2;
    self.enableModeChange = YES;
    self.comentery = [@"" mutableCopy];
    self.selectedCards = [[NSMutableArray alloc] init];
}


-(PlayingCard*)getCardAtIndex: (NSUInteger) index{
    return (index < [self.cards count])? self.cards[index] : nil;
}




-(void)FlipCardAtIndex: (NSUInteger) index{

    // if we make a move, disable mode change
    self.enableModeChange = NO;
    // init commentery string
    self.comentery = [@"" mutableCopy];
    // get chosen card
    PlayingCard* currentCard = [self getCardAtIndex:index];
    
    if(currentCard.matched){
        [self.comentery appendFormat:@"%@ is already matched\n",currentCard.contents];
    }
    else if(currentCard.chosen){
        [self.selectedCards removeObject:currentCard];
        currentCard.chosen = NO;
        [self.comentery appendFormat:@"you just unselected %@\n",currentCard.contents];
    }else{
        // first select card
        currentCard.chosen = YES;
        [self.selectedCards addObject:currentCard];
        self.score -= STEP_PENALTY;
        [self.comentery appendFormat:@"you just selected %@\n",currentCard.contents];
        // if reached matchSize attempt to make a match
        if(self.matchSize == [self.selectedCards count]){
            NSInteger matchScore = [MatchingGame cardsMatchScore: self.selectedCards];
            self.score += matchScore;
            if(matchScore>0){ // if there was a match
                [self handleMatch];
            }
            else{
                [self handleMismatch: currentCard];
            }
        }
        
    }
    
    if([self.selectedCards count] > 0){
        [self.comentery appendFormat:@"The currently selected cards are:%@\n", [MatchingGame getStringOfCards:self.selectedCards]];
    }

}



-(void)handleMatch{
    
    [self.comentery appendFormat:@"%@ were a match!\n", [MatchingGame getStringOfCards:self.selectedCards]];
    for(PlayingCard* card in self.selectedCards){
        card.chosen = NO;
        card.matched = YES;
    }
    [self.selectedCards removeAllObjects];
    
}

-(void)handleMismatch: (PlayingCard* )currentCard{
    
    [self.comentery appendFormat:@"sadly %@ are NOT a match\n", [MatchingGame getStringOfCards:self.selectedCards]];
    for(Card* card in self.selectedCards){
        card.chosen = NO;
    }
    [self.selectedCards removeAllObjects];
    currentCard.chosen = YES;
    [self.selectedCards addObject:currentCard];
    
}




+(NSMutableString*)getStringOfCards:(NSMutableArray*) cards{
    NSMutableString* cardString = [@"" mutableCopy];
    for(PlayingCard *card in cards){
        [cardString appendFormat:@" %@",card.contents];
    }
    return cardString;
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





//-(void)FlipCardAtIndex: (NSUInteger) index{
//
//    // find all chosen cards
//    NSMutableArray* chosen = [self getChosenUnmatchedCards];
//    // if we make a move, disable mode change
//    self.enableModeChange = NO;
//
//    PlayingCard* currentCard = [self getCardAtIndex:index];
//
//    self.comentery = [@"" mutableCopy];
//
//    // if we flip down or already matched do nothing
//    if(!currentCard.chosen && !currentCard.matched){
//        [self.comentery appendFormat:@"you just selected %@\n",currentCard.contents];
//        // we will chose the currentCard
//        self.currentChosenCount++;
//        currentCard.chosen = YES;
//        chosen = [self getChosenUnmatchedCards];
//
//        // pay penalty for step
//        self.score -= STEP_PENALTY;
//
//
//        // if the current card was the last card, calculate score and unchoose all other cards
//        if(self.currentChosenCount == self.matchSize){
//
//            NSInteger matchScore = [MatchingGame cardsMatchScore: chosen];
//            self.score += matchScore;
//
//            // if there was a match
//            if(matchScore>0){
//                [self.comentery appendFormat:@"%@ were a match!\n", [MatchingGame getStringOfCards:chosen]];
//                self.currentChosenCount = 0;
//                for(Card* card in chosen){
//                    card.chosen = NO;
//                    card.matched=YES;
//                }
//            }
//            else{
//                [self.comentery appendFormat:@"sadly %@ are NOT a match\n", [MatchingGame getStringOfCards:chosen]];
//                self.currentChosenCount = 1;
//                for(Card* card in chosen){
//                    card.chosen = NO;
//                }
//                currentCard.chosen = YES;
//            }
//        }
//    }
//    else if(currentCard.chosen && !currentCard.matched){
//        currentCard.chosen = NO;
//        self.currentChosenCount--;
//        [self.comentery appendFormat:@"you just unselected %@\n",currentCard.contents];
//    }
//    else{
//        [self.comentery appendFormat:@"%@ is already matched\n",currentCard.contents];
//    }
//    chosen = [self getChosenUnmatchedCards];
//    if([chosen count] > 0){
//        [self.comentery appendFormat:@"The currently selected cards are:%@\n", [MatchingGame getStringOfCards:chosen]];
//    }
//
//
//}
