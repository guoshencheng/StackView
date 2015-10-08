//
//  StackViewController.m
//  StackView
//
//  Created by guoshencheng on 10/5/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "StackViewController.h"
#import "StackViewCell.h"

@interface StackViewController ()

@end

@implementation StackViewController {
    NSArray *texts;
}

+ (instancetype)create {
    return [[StackViewController alloc] initWithNibName:@"StackViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    texts = @[@"hehe", @"haha", @"hoho", @"xixi", @"lulu"];
    [self.stackView registerCellWithNibName:@"StackViewCell" forCellReuseIdentifier:@"StackViewCell"];
    self.stackView.datasource = self;
    [self.stackView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)stackViewNumberOfRow:(StackView *)stackView {
    return texts.count;
}

- (UIView *)stackView:(StackView *)stackView cellForIndex:(NSInteger)index {
    texts = @[@"hehe", @"haha", @"hoho", @"xixi", @"lulu"];
    StackViewCell *view = (StackViewCell *)[stackView dequeueReusableCellWithReuseIdentifier:@"StackViewCell" forIndex:index];
    view.backgroundColor = [UIColor whiteColor];
    [view updateLabelText:[texts objectAtIndex:index]];
    return view;
}

- (CGSize)stackViewCellSize:(StackView *)stackView {
    return CGSizeMake(240, 300);
}

@end
