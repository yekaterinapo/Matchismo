//
//  Card.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Card : NSObject

- (int) MatcheScore: (NSArray*) otherCards;

@property (strong, nonatomic) NSAttributedString* contents;

@property (nonatomic) BOOL matched;

@property (nonatomic) BOOL chosen;

@end

NS_ASSUME_NONNULL_END
