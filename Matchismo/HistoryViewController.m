//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 18/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation HistoryViewController

//- (void) setHistory: (NSAttributedString*) history {
//  _history = history;
//  if (self.view.window) [self updateUI];
//}

- (void) updateUI {
  [self.historyTextView setAttributedText:self.history];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self updateUI];
}

@end
