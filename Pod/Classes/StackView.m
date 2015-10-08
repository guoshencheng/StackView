//
//  StackView.m
//  StackView
//
//  Created by guoshencheng on 10/5/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "StackView.h"
#import "Masonry.h"

@interface StackView ()

@property (nonatomic, assign) CGPoint panGestureStartLocation;
@property (nonatomic, strong) NSMutableDictionary *reusabelCellIdDictionary;
@property (nonatomic, strong) NSMutableDictionary *reusePoolDictionary;
@property (nonatomic, assign) NSInteger cellNumber;

@end

@implementation StackView {
    NSInteger currentIndex;
}

#pragma mark - LiveCycle

- (void)awakeFromNib {
    [self initProperties];
    [self configureViews];
}

#pragma mark - PublicMethod

- (void)setDatasource:(id<StackViewDatasource>)datasource {
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData {
    [self resetPile];
    [self layoutCells];
}

- (void)registerCellWithNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier {
    [self.reusabelCellIdDictionary setValue:nibName forKey:identifier];
}

- (UIView *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    NSString *nibName = [self.reusabelCellIdDictionary objectForKey:identifier];
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject];
    return view;
}

#pragma mark - GestureAction Handler

- (void)panGestureAction:(UIPanGestureRecognizer *)gesture {
    switch ([gesture state]) {
        case UIGestureRecognizerStateBegan:{
            [self panGestureDidBegin:gesture];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self panGestureDidMove:gesture];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self panGestureDidEnd:gesture];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
        default:
            break;
    }

}

- (void)panGestureDidBegin:(UIPanGestureRecognizer *)gesture {
    self.panGestureStartLocation = [gesture locationInView:self];
}

- (void)panGestureDidMove:(UIPanGestureRecognizer *)gesture {
    CGFloat yOffset = [gesture locationInView:self].y - self.panGestureStartLocation.y;
    if ([self isCellOver] && yOffset > 0) {
        return;
    }
    if (yOffset < 0) {
        if (!self.pile.previousCell) {
            [self generatePreviousCell];
        }
    } else {
        [self removeCell:self.pile.previousCell];
        self.pile.previousCell = nil;
    }
    [self.pile updateCellWithOffset:yOffset];
}

- (void)panGestureDidEnd:(UIPanGestureRecognizer *)gesture {
    CGFloat yOffset = [gesture locationInView:self].y - self.panGestureStartLocation.y;
    if ([self isCellOver] && yOffset > 0) {
        return;
    }
    if (yOffset > self.pile.rangeLength / 2) {
        [self handleIfNeedPushNextCell];
    } else if(yOffset < -self.pile.rangeLength / 2){
        [self handleIfNeedPushPreviousCell];
    } else {
        [self animateRecover];
    }
}

#pragma mark - PrivateMethod

#pragma mark -- BOOL juge function

- (BOOL)loadToEnd {
    return currentIndex < (self.cellNumber - 3);
}

- (BOOL)isCellOver {
    return currentIndex >= self.cellNumber;
}

#pragma mark -- insert && remove function

- (void)insertCell:(UIView *)cell {
    [self insertSubview:cell atIndex:0];
    [self addConstraintToCell:cell];
}

- (void)addConstraintToCell:(UIView *)cell {
    __weak typeof(self) weakSelf = self;
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf).centerOffset(CGPointMake(0, 0));
        CGSize size = [weakSelf.datasource stackViewCellSize:weakSelf];
        make.width.equalTo(@(size.width));
        make.height.equalTo(@(size.height));
    }];
}

- (void)removeCell:(UIView *)cell {
    [cell.layer removeAllAnimations];
    [cell removeFromSuperview];
    //TODO insert cell into reusepool
}

#pragma mark -- Configuration function

- (void)configureViews {
    [self addPanGesture];
}

- (void)addPanGesture {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    panRecognizer.delegate = self;
    [self addGestureRecognizer:panRecognizer];
}

- (void)initProperties {
    self.reusePoolDictionary = [[NSMutableDictionary alloc] init];
    self.reusabelCellIdDictionary = [[NSMutableDictionary alloc] init];
    self.pile = [StackViewDefaultPile new];
    currentIndex = 0;
}

- (void)layoutCells {
    [self updateCellNumber];
    NSInteger visibleCellCount = [self visibleCellCount];
    for (int i = 0; i < visibleCellCount; i ++) {
        UIView *cell = [self.pile cellOfIndex:i];
        if (!cell) {
            cell = [self.datasource stackView:self cellForIndex:(currentIndex + i)];
            [self insertCell:cell];
            [self.pile setCell:cell atIndex:i];
            [self.pile resetCell:cell atIndex:i];
        }
    }
}

- (void)resetPile {
    [self removeCell:self.pile.nextCell];
    for (int i = -1; i < [self.pile maxSize]; i ++) {
        [self removeCell:[self.pile cellOfIndex:i]];
    }
    [self.pile reset];
}

#pragma mark -- Cell push && generate handler

- (void)generateNextCell {
    UIView *nextCell = [self.datasource stackView:self cellForIndex:(currentIndex + [self.pile maxSize])];
    self.pile.nextCell = nextCell;
    nextCell.alpha = 0;
    [self insertCell:nextCell];
}

- (void)generatePreviousCell {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = (- 1.0f / 200.0f);
    if (currentIndex > 0) {
        UIView *previousCell = [self.datasource stackView:self cellForIndex:currentIndex - 1];
        self.pile.previousCell = previousCell;
        self.pile.previousCell.layer.transform = CATransform3DTranslate(transform, 0, self.pile.rangeLength, 0);
        [self addSubview:previousCell];
        [self addConstraintToCell:previousCell];
    }
}

- (void)handleIfNeedPushNextCell {
    if ([self loadToEnd]) {
        [self generateNextCell];
        [self animatePushNextCell];
    } else {
        [self animatePushNextCell];
    }
    currentIndex ++;
}

- (void)handleIfNeedPushPreviousCell {
    if (self.pile.previousCell) {
        [self animatePushPreviousCell];
        currentIndex --;
    } else {
        [self animateRecover];
    }
}

#pragma mark -- Tools

- (NSInteger)visibleCellCount {
    NSInteger count = self.cellNumber < currentIndex ? 0 : self.cellNumber - currentIndex;
    return (count < [self.pile maxSize]) ? count : [self.pile maxSize];
}

- (void)updateCellNumber {
    self.cellNumber = [self.datasource stackViewNumberOfRow:self];
}

#pragma mark -- Animation

- (void)animatePushNextCell {
    [UIView animateWithDuration:0.2 animations:^{
        [self.pile pushNextCell];
    } completion:^(BOOL finished) {
        UIView *removeView = [self.pile bringNextCellToBottom];
        [self removeCell:removeView];
    }];
}

- (void)animatePushPreviousCell {
    [UIView animateWithDuration:0.2 animations:^{
        [self.pile pushPreviousCell];
    } completion:^(BOOL finished) {
        UIView *removeView = [self.pile bringPreviousCellToTop];
        [self removeCell:removeView];
    }];
}

- (void)animateRecover {
    [UIView animateWithDuration:0.2 animations:^{
        [self.pile recover];
    } completion:^(BOOL finished) {
        
    }];
}

@end
