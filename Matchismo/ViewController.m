//
//  ViewController.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 02/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "ViewController.h"
#import "MatchingGame.h"

@interface ViewController ()


@property (strong, nonatomic) MatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardsButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLable;
@property (weak, nonatomic) IBOutlet UISwitch *threeMatchSwitch;
@property (weak, nonatomic) IBOutlet UILabel *comenteryLable;






@end

@implementation ViewController

+(Deck*)createDeck{
    return [[PlayDeck alloc] init];
}

- (IBAction)threeMatchSwitch:(id)sender {
    BOOL isOn = [sender isOn];
    
    self.game.matchSize = (isOn)? 3:2;
    [self updateUI];
}

- (IBAction)touchResetButton:(id)sender {
    NSUInteger count = [self.game.cards count];
    Deck* deck = [ViewController createDeck];
    [self.game resetGameWithCardCount: count UsingDeck: deck];
    [self.threeMatchSwitch setOn:NO];
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger buttonIndex = [self.cardsButtons indexOfObject:sender];
    [self.game FlipCardAtIndex:buttonIndex];
    [self updateUI];

    
}



- (MatchingGame*)game {
    if (!_game){
        _game = [[MatchingGame alloc] initWithCardCount:[self.cardsButtons count] UsingDeck:[ViewController createDeck]];
    }
    return _game;
}

-(void)updateUI{
    // update mode switch
    self.threeMatchSwitch.userInteractionEnabled = self.game.enableModeChange;
    // update all the buttons
    for(UIButton* cardButton in self.cardsButtons){
        // get the index of the button
        NSUInteger cardIndex = [self.cardsButtons indexOfObject:cardButton];
        PlayingCard *card = [self.game getCardAtIndex:cardIndex];
        
        [cardButton setBackgroundImage:[self getImageForCard:card] forState:UIControlStateNormal];
        [cardButton setTitle:[self getTitleForCard:card] forState:UIControlStateNormal];
        cardButton.alpha = (card.matched)? 0.6:1;
        [self.scoreLable setText: [NSString stringWithFormat:@"score: %d", (int)self.game.score]];
        
    }



    [self.comenteryLable setText:self.game.comentery];
    
}

-(NSString*) getTitleForCard: (PlayingCard*) card{
    return (card.chosen || card.matched)? card.contents:@"";
}

-(UIImage*) getImageForCard: (PlayingCard*) card{
    return [UIImage imageNamed:(card.chosen || card.matched)? @"cardfront": @"cardback"];
}



@end
