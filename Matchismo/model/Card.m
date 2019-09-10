//
//  Card.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "Card.h"

@implementation Card


-(int)Matched:(NSArray*)otherCards{
    for(Card* otherCard in otherCards){
        if([otherCard.contents isEqualToString:self.contents]){
            return 1;
        }
    }
    return 0;
}

@end
