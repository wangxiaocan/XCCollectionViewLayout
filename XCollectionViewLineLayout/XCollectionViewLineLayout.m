//
//  XCollectionViewLineLayout.m
//  PageTest
//
//  Created by 王文科 on 2019/6/17.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import "XCollectionViewLineLayout.h"

@implementation XCollectionViewLineLayout


- (void)prepareLayout{
    [super prepareLayout];
    UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (attribute) {
        CGFloat offset = CGRectGetWidth(self.collectionView.frame) / 2.0 - CGRectGetWidth(attribute.frame) / 2.0;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, offset, 0, offset);
    }
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleFrame = CGRectMake(self.collectionView.contentOffset.x, 0, CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame));
    UICollectionViewLayoutAttributes *centerAttribute = nil;
    CGFloat distance = CGFLOAT_MAX;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        CGFloat centerDistance = ABS(attribute.frame.origin.x + attribute.frame.size.width / 2 - visibleFrame.origin.x - visibleFrame.size.width / 2);
        if (centerDistance < distance) {
            distance = centerDistance;
            centerAttribute = attribute;
        }
        CGFloat scale = 0.f;
        if (centerDistance / (CGRectGetWidth(centerAttribute.frame) * 2.0 + self.minimumLineSpacing) > 1.0) {
            scale = 1.0;
        }else{
            scale = 1.0 - centerDistance / (CGRectGetWidth(centerAttribute.frame) * 2.0 + self.minimumLineSpacing);
        }
        attribute.transform = CGAffineTransformMakeScale(1.0 + scale * 0.2, 1.0 + scale * 0.2);
    }
    return attributes;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGRect visibleFrame = CGRectMake(proposedContentOffset.x, 0, CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame));
    UICollectionViewLayoutAttributes *centerAttribute = nil;
    CGFloat distance = CGFLOAT_MAX;
    NSInteger sections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sections; section++) {
        NSInteger items = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < items; item++) {
            UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            if (attribute) {
                CGFloat centerDistance = ABS(attribute.frame.origin.x + attribute.frame.size.width / 2 - visibleFrame.origin.x - visibleFrame.size.width / 2);
                if (centerDistance < distance) {
                    distance = centerDistance;
                    centerAttribute = attribute;
                    proposedContentOffset = CGPointMake(CGRectGetMinX(attribute.frame) - CGRectGetWidth(self.collectionView.frame) / 2.0 + CGRectGetWidth(attribute.frame) / 2.0 , 0);
                }
            }
        }
    }
    return proposedContentOffset;
}

@end
