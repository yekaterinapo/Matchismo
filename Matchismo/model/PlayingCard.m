//
//  PlayingCard.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "PlayingCard.h"
@interface PlayingCard()
- (NSString *) contents;
+ (NSArray *) RankStrings;





@end
@implementation PlayingCard
@synthesize rank = _rank;
@synthesize suit = _suit;

- (NSString *) contents{
    return [ self.suit stringByAppendingString: [PlayingCard RankStrings][self.rank] ];
}

+ (NSArray *) RankStrings{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7",
                       @"8", @"9", @"J", @"Q", @"K"];
//return @[@"?", @"A"];
    
}

+ (NSArray *) SuitStrings{
    return @[@"♠", @"♥", @"♦", @"♣"];
}

- (void) setRank:(NSUInteger)rank{
    if( rank>0 && rank <= [PlayingCard maxRank] ){
        _rank = rank;
        self.contents = [[PlayingCard RankStrings][rank] stringByAppendingString: self.suit];
    }
}

- (NSUInteger) setRank{
    if(!_rank){
        _rank = 0;
    }
    return _rank;
}

- (NSString*) suit{
    if(!_suit){
        _suit = @"";
    }
    return _suit;
}

- (void) setSuit:(NSString*)suit{
    if([[PlayingCard SuitStrings] containsObject:suit]){
        _suit = suit;
        self.contents = [[PlayingCard RankStrings][self.rank] stringByAppendingString: suit];
    }
}

+ (NSUInteger) maxRank{
    return [[PlayingCard RankStrings] count] - 1;
}

-(int) Matched:(NSArray*)otherCards{
    
    for(PlayingCard* otherCard in otherCards){
        if([otherCard.suit isEqualToString:self.suit]){
            return 1;
        }
        else if(otherCard.rank == self.rank){
            return 4;
        }
    }
    return 0;
}




@end
