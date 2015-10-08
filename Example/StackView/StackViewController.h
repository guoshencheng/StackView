//
//  StackViewController.h
//  StackView
//
//  Created by guoshencheng on 10/5/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackView.h"
@interface StackViewController : UIViewController<StackViewDatasource>

@property (weak, nonatomic) IBOutlet StackView *stackView;
+ (instancetype)create;

@end
