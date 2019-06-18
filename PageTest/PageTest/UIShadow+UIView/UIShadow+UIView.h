//
//  UIShadow+UIView.h
//  PageTest
//
//  Created by xiao can on 2019/6/11.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface  UIView(UIShadow_UIImageView)

@property (nonatomic, strong, nullable) CALayer   *shadow_layer;

@property (nonatomic, strong) UIColor   *shadow_color;//设置阴影色
@property (nonatomic, assign) CGSize    shadow_offset;//设置阴影偏移量
@property (nonatomic, assign) CGFloat   shadow_radius;//设置阴影半径
@property (nonatomic, assign) CGFloat   shadow_corner_radius;//设置阴影圆角
@property (nonatomic, assign) CGFloat   shadow_opacity;//设置阴影透明度
@property (nonatomic, assign) CGPathRef shadow_path;
@property (nonatomic, getter=isShowShadowLayer) BOOL showShadowLayer;

- (void)showDefaultShadow;

@end

NS_ASSUME_NONNULL_END
