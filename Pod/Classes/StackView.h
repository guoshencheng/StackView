//
//  StackView.h
//  StackView
//
//  Created by guoshencheng on 10/5/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackViewDefaultPile.h"

@protocol StackViewDatasource;

@interface StackView : UIView<UIGestureRecognizerDelegate>

/**
 * It's a property save cells and handle cell actions
 *
 */
@property (nonatomic, strong) StackViewDefaultPile *pile;

/**
 * The components datasource
 *
 */
@property (nonatomic, weak) id<StackViewDatasource> datasource;

/**
 * Reload data clear all cell and readd cells into component
 *
 */
- (void)reloadData;

/**
 * Get Cell with Reuseid
 *
 */
- (UIView *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

/**
 * regist cell with nibname and id
 *
 */
- (void)registerCellWithNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier;

@end

@protocol StackViewDatasource <NSObject>

@required

/**
 *
 *  Datasource for getting cell for index
 */
- (UIView *)stackView:(StackView *)stackView cellForIndex:(NSInteger)index;

/**
 * Datasource for getting cell Size for index
 *
 */
- (CGSize)stackViewCellSize:(StackView *)stackView;


/**
 * Datasource for getting cell Number for index
 *
 */
- (NSInteger)stackViewNumberOfRow:(StackView *)stackView;

@optional

@end
