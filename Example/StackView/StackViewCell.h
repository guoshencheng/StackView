//
//  StackViewCell.h
//  StackView
//
//  Created by guoshencheng on 10/7/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackViewCell : UIView

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
- (void)updateLabelText:(NSString *)text;

@end
