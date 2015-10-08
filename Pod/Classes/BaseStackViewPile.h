//
//  BaseStackViewPile.h
//  StackView
//
//  Created by guoshencheng on 10/8/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseStackViewPile : NSObject

@property (nonatomic, strong) NSArray *alphaArray;
@property (nonatomic, strong) NSArray *zTransformArray;
@property (nonatomic, assign) CGFloat rangeLength;
@property (nonatomic, strong) UIView *previousCell;
@property (nonatomic, strong) UIView *nextCell;
@property (nonatomic, assign) CATransform3D cellTransform;

- (void)reset;
- (void)recover;
- (void)pushNextCell;
- (void)pushPreviousCell;
- (UIView *)cellOfIndex:(NSInteger)index;
- (void)setCell:(UIView *)cell atIndex:(NSInteger)index;
- (UIView *)removeCellAtIndex:(NSInteger)index;
- (UIView *)bringPreviousCellToTop;
- (UIView *)bringNextCellToBottom;
- (NSInteger)maxSize;
- (void)resetCell:(UIView *)cell atIndex:(NSInteger)index;
- (void)updateCellWithOffset:(CGFloat)offset;

@end
