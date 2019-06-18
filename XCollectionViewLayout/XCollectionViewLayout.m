//
//  XCollectionViewLayout.m
//  PageTest
//
//  Created by 王文科 on 2019/6/17.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import "XCollectionViewLayout.h"


@implementation XCollectionViewLayout


- (instancetype)init{
    self = [super init];
    if (self) {
        self.scaleCoefficient = 0.8;
        self.transformStyle = XCollectionViewLayout_LinerTransform;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}


- (void)prepareLayout{
    [super prepareLayout];
    UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (attribute) {
        CGFloat offset = CGRectGetWidth(self.collectionView.frame) / 2.0 - CGRectGetWidth(attribute.frame) / 2.0;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, offset, 0, offset);
    }
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    CGFloat lineSpacing = [self getXCLineSpacing];
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleFrame = CGRectMake(self.collectionView.contentOffset.x, 0, CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame));
    UICollectionViewLayoutAttributes *centerAttribute = nil;
    CGFloat distance = CGFLOAT_MAX;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        CGFloat centerDistance = CGRectGetMidX(attribute.frame) - CGRectGetMidX(visibleFrame);
        if (ABS(centerDistance) < distance) {
            distance = ABS(centerDistance);
            centerAttribute = attribute;
        }
        CGFloat coefficient = 0.f;
        CGFloat baseSpace = ABS(CGRectGetWidth(centerAttribute.frame) + lineSpacing);
        if (ABS(centerDistance) / baseSpace >= 1.0) {
            coefficient = 0;
        }else{
            coefficient = 1.0 - ABS(centerDistance) / baseSpace;
        }
        if (self.transformStyle == XCollectionViewLayout_AffineTranform) {
            CGFloat roration = 0.f;
            if (centerDistance / baseSpace >= 1.0) {
                roration = -M_PI_4;
            }else if (centerDistance / baseSpace <= -1.0) {
                roration = M_PI_4;
            }else if (centerDistance == 0) {
                roration = 0.f;
            }else if (centerDistance < 0){//left
                roration = (1.0 - coefficient) * M_PI_4;
            }else if (centerDistance > 0){//right
                roration = -(1.0 - coefficient) * M_PI_4;
            }
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = -1.0 / 500.0;
            
            transform = CATransform3DScale(transform, self.scaleCoefficient + (1 - self.scaleCoefficient) * coefficient, self.scaleCoefficient + (1 - self.scaleCoefficient) * coefficient, 1.0);
            attribute.transform3D = CATransform3DRotate(transform, roration, 0, 1.0, 0);//CATransform3DMakeRotation(M_PI_4, roration, 0, 0);
        }else{
            attribute.transform = CGAffineTransformMakeScale(self.scaleCoefficient + (1 - self.scaleCoefficient) * coefficient, self.scaleCoefficient + (1 - self.scaleCoefficient) * coefficient);
        }
        
        
    }
    return attributes;
}

- (CGFloat)getXCLineSpacing{
    CGFloat lineSpacing = self.minimumLineSpacing;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        lineSpacing = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:0];
    }
    return lineSpacing;
}

- (CGFloat)getXCItemSpacing{
    CGFloat itemSpacing = self.minimumInteritemSpacing;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        itemSpacing = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:0];
    }
    return itemSpacing;
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

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection{
    [super setScrollDirection:UICollectionViewScrollDirectionHorizontal];
}

- (void)setTransformStyle:(XCollectionViewLayoutTransformStyle)transformStyle{
    _transformStyle = transformStyle;
    if (_transformStyle == XCollectionViewLayout_AffineTranform) {
        self.minimumLineSpacing = -70.0;
    }else{
        self.minimumLineSpacing = 0;
    }
}

@end
