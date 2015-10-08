//
//  StackViewDefaultPile.m
//  StackView
//
//  Created by guoshencheng on 10/6/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "StackViewDefaultPile.h"

@implementation StackViewDefaultPile

- (NSInteger)maxSize {
    return 3;
}

- (void)reset {
    self.previousCell = nil;
    self.nextCell = nil;
    self.cell1 = nil;
    self.cell2 = nil;
    self.cell3 = nil;
}

- (UIView *)cellOfIndex:(NSInteger)index {
    switch (index) {
        case -1:
            return self.previousCell;
        case 0:
            return self.cell1;
        case 1:
            return self.cell2;
        case 2:
            return self.cell3;
        default:
            return nil;
    }
}

- (void)setCell:(UIView *)cell atIndex:(NSInteger)index {
    switch (index) {
        case -1:
            self.previousCell = cell;
            break;
        case 0:
            self.cell1 = cell;
            break;
        case 1:
            self.cell2 = cell;
            break;
        case 2:
            self.cell3 = cell;
            break;
        case 3:
            self.nextCell = cell;
            break;
        default:
            break;
    }
}

@end
