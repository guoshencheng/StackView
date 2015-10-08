//
//  BaseStackViewPile.m
//  StackView
//
//  Created by guoshencheng on 10/8/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "BaseStackViewPile.h"

#define DEFAULT_RANGE_LENGTH 250
#define DEFAULT_CELLS_ALPHA @[@(1), @(2.0 / 3), @(1.0 / 3)]
#define DEFAULT_CELLS_ZTRANSFORM @[@(0), @(-10), @(-20)]

@implementation BaseStackViewPile

- (instancetype)init {
    if (self = [super init]) {
        self.alphaArray = DEFAULT_CELLS_ALPHA;
        self.zTransformArray = DEFAULT_CELLS_ZTRANSFORM;
        self.rangeLength = DEFAULT_RANGE_LENGTH;
        _cellTransform = CATransform3DIdentity;
        _cellTransform.m34 = (- 1.0f / 200.0f);
    }
    return self;
}

- (NSInteger)maxSize {
    NSAssert(false, @"the - (NSInteger)maxSize must be overwrite in SubClass");
    return 0;
}

- (UIView *)cellOfIndex:(NSInteger)index {
    NSAssert(false, @"the - (UIView *)cellOfIndex:(NSInteger)index must be overwrite in SubClass");
    return nil;
}

- (void)setCell:(UIView *)cell atIndex:(NSInteger)index {
    NSAssert(false, @"the - (void)setCell:(UIView *)cell atIndex:(NSInteger)index  must be overwrite in SubClass");
}

- (void)reset {
    self.previousCell = nil;
    self.nextCell = nil;
}

- (void)resetCell:(UIView *)cell atIndex:(NSInteger)index {
    cell.layer.transform = CATransform3DTranslate(self.cellTransform, 0, 2 * [[self.zTransformArray objectAtIndex:index] floatValue], [[self.zTransformArray objectAtIndex:index] floatValue]);
    cell.alpha = [[self.alphaArray objectAtIndex:index] floatValue];
}

- (UIView *)removeCellAtIndex:(NSInteger)index {
    UIView *removeCell = [self cellOfIndex:index];
    for (NSInteger i = index; i < [self maxSize]; i ++) {
        [self setCell:[self cellOfIndex:i + 1] atIndex:i];
    }
    return removeCell;
}

- (UIView *)bringPreviousCellToTop {
    UIView *removeCell = [self cellOfIndex:[self maxSize] - 1];
    for (NSInteger i = ([self maxSize] - 1); i >= 0; i --) {
        [self setCell:[self cellOfIndex:(i - 1)] atIndex:i];
        [self resetCell:[self cellOfIndex:i] atIndex:i];
    }
    self.previousCell = nil;
    return removeCell;
}

- (UIView *)bringNextCellToBottom {
    UIView *removeCell = [self cellOfIndex:0];
    for (int i  = 0; i < [self maxSize]; i ++) {
        if (i == ([self maxSize] - 1)) {
            [self setCell:self.nextCell atIndex:i];
        } else {
            [self setCell:[self cellOfIndex:i + 1] atIndex:i];
        }
        [self resetCell:[self cellOfIndex:i] atIndex:i];
    }
    self.nextCell = nil;
    return removeCell;
}

- (void)recover {
    if (self.previousCell) {
        [self.previousCell removeFromSuperview];
        [self.previousCell.layer removeAllAnimations];
        self.previousCell = nil;
    }
    for (int i = 0 ; i < [self maxSize]; i ++) {
        [self resetCell:[self cellOfIndex:i] atIndex:i];
    }
}

- (void)pushNextCell {
    for (int i = 0 ; i < [self maxSize] - 1; i ++) {
        [self resetCell:[self cellOfIndex:i + 1] atIndex:i];
    }
    UIView *cell = [self cellOfIndex:0];
    cell.layer.transform = CATransform3DTranslate(self.cellTransform, 0, 2 * self.rangeLength, 0);
    cell.alpha = 0;
}

- (void)pushPreviousCell {
    for (int i = 0 ; i < [self maxSize] - 1; i ++) {
        [self resetCell:[self cellOfIndex:i] atIndex:i + 1];
    }
    self.previousCell.layer.transform = CATransform3DTranslate(self.cellTransform, 0, 0, 0);
}


- (void)updateCellWithOffset:(CGFloat)offset {
    if (offset > 0) {
        CGFloat ztDif = [[self.zTransformArray objectAtIndex:0] floatValue] - [[self.zTransformArray objectAtIndex:1] floatValue];
        CGFloat alphaDif = [[self.alphaArray objectAtIndex:0] floatValue] - [[self.alphaArray objectAtIndex:1] floatValue];
        for (int i = 1; i < [self maxSize]; i ++) {
            UIView *cell = [self cellOfIndex:i];
            CGFloat tz = [[self.zTransformArray objectAtIndex:i] floatValue] + ztDif * offset / self.rangeLength;
            cell.layer.transform = CATransform3DTranslate(self.cellTransform, 0, 2 * tz, tz);
            cell.alpha = [[self.alphaArray objectAtIndex:i] floatValue] + alphaDif * offset / self.rangeLength;
        }
        UIView *cell1 = [self cellOfIndex:0];
        cell1.layer.transform = CATransform3DTranslate(self.cellTransform, 0, offset, 0);
    } else {
        CGFloat ztDif = [[self.zTransformArray objectAtIndex:0] floatValue] - [[self.zTransformArray objectAtIndex:1] floatValue];
        CGFloat alphaDif = [[self.alphaArray objectAtIndex:0] floatValue] - [[self.alphaArray objectAtIndex:1] floatValue];
        for (int i = 0; i < [self maxSize]; i ++) {
            UIView *cell = [self cellOfIndex:i];
            CGFloat tz = [[self.zTransformArray objectAtIndex:i] floatValue] + ztDif * offset / self.rangeLength;
            cell.layer.transform = CATransform3DTranslate(self.cellTransform, 0, 2 * tz, tz);
            cell.alpha = [[self.alphaArray objectAtIndex:i] floatValue] + alphaDif * offset / self.rangeLength;
        }
        if (self.previousCell) {
            self.previousCell.layer.transform = CATransform3DTranslate(self.cellTransform, 0, self.rangeLength + offset, 0);
        }
    }
}

@end
