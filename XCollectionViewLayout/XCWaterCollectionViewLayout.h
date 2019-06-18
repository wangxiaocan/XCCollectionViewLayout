//
//  XCWaterCollectionViewLayout.h
//  PageTest
//
//  Created by 王文科 on 2019/6/15.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XCWaterCollectionViewScrollDirection) {
    XCWaterCollectionViewScrollDirectionVertical,//垂直方向滚动
    XCWaterCollectionViewScrollDirectionHorizontal//水平方向滚动
};

@protocol XCWaterCollectionViewLayoutDelegate <NSObject>

/** 列数 */
- (NSInteger)itemColumns;

/** item与item之间 水平间距 */
- (CGFloat)itemSpaceAtSectioin:(NSInteger)section;

/** item与item之间 垂直间距 */
- (CGFloat)itemLineSpaceAtSection:(NSInteger)section;

- (UIEdgeInsets)sectionInsetsAtSection:(NSInteger)section;

/** item 高度，XCWaterCollectionViewScrollDirectionVertical模式下返回item宽度 */
- (CGFloat)itemHeightAtIndexPath:(NSIndexPath *)indexPath;

/** header view */
- (CGSize)headerViewSizeAtSection:(NSInteger)section;

/** footer view */
- (CGSize)footerViewSizeAtSection:(NSInteger)section;


@end

/** 瀑布流 */
@interface XCWaterCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) NSInteger itemColumns;/**< default 2 */
@property (nonatomic) CGFloat itemSpace;/**< itemSpaceAtSectioin: */
@property (nonatomic) CGFloat lineSpace;/**< itemLineSpaceAtSection: */
@property (nonatomic) CGSize  headerViewSize;/**< headerViewSizeAtSection: */
@property (nonatomic) CGSize  footerSize;/**< footerViewSizeAtSection: */
@property (nonatomic) UIEdgeInsets sectioinInsets;/**< sectionInsetsAtSection: */
@property (nonatomic) CGFloat itemWidthOrHeight;/**< itemHeightAtIndexPath */

@property (nonatomic) XCWaterCollectionViewScrollDirection scrollDirection;//default XCWaterCollectionViewScrollDirectionVertical

@end

NS_ASSUME_NONNULL_END
