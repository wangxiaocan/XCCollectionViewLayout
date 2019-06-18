//
//  WaterHorizontalCell.m
//  PageTest
//
//  Created by xiao can on 2019/6/17.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import "WaterHorizontalCell.h"

@implementation WaterHorizontalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 8.0;
    
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.cornerRadius = 8.0;
    shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
    shadowLayer.shadowColor = [UIColor lightGrayColor].CGColor;
    shadowLayer.shadowRadius = 3.0;
    shadowLayer.shadowOpacity = 1.0;
    shadowLayer.shadowOffset = CGSizeZero;
    shadowLayer.frame = self.contentView.frame;
    [self.layer insertSublayer:shadowLayer atIndex:0];
    self.shadowLayer = shadowLayer;
    
    self.clipsToBounds = NO;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.shadowLayer.frame = self.bounds;
}


@end
