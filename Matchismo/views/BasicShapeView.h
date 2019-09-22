//
//  ovalsView.h
//  Matchismo
//
//  Created by Yekaterina Podiatchev on 19/09/2019.
//  Copyright © 2019 Yekaterina Podiatchev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BasicShapeView : UIView

@property (strong, nonatomic) UIColor* color;
@property (nonatomic) int pattern;
@property (nonatomic) int shape;

@end

NS_ASSUME_NONNULL_END
