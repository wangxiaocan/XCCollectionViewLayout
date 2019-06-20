//
//  XCollectionViewLayout.h
//  PageTest
//
//  Created by 王文科 on 2019/6/17.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger,XCollectionViewLayoutTransformStyle){
    XCollectionViewLayout_LinerTransform,//线性放大
    XCollectionViewLayout_AffineTranform,//旋转放大
};

//滚动放大模式（只支持横向滚动，不支持多分区）
@interface XCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic) XCollectionViewLayoutTransformStyle transformStyle;
@property (nonatomic) CGFloat                             scaleCoefficient;//缩小系数，default 0.8,建议0.6~0.8



@end



@interface UICollectionViewLayout(AutoScrollToCenterClickCell)

/** 点击cell时判断cell是否在屏幕中央
 *  当前cell在屏幕正中央时返回 YES
 *  当前cell不在屏幕正中央时自动滚动到点击的cell
 */
- (BOOL)clickCellAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
