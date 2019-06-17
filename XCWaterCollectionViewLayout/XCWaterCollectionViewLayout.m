//
//  XCWaterCollectionViewLayout.m
//  PageTest
//
//  Created by 王文科 on 2019/6/15.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import "XCWaterCollectionViewLayout.h"

@interface XCWaterCollectionViewLayout()


@property (nonatomic, weak)   id<XCWaterCollectionViewLayoutDelegate> delegate;

@property (nonatomic, strong) NSMutableArray    *allAttribures;
@property (nonatomic, strong) NSMutableArray    *sectionAttribures;
@property (nonatomic, strong) NSMutableArray    *headerOrFooterAttribures;
@property (nonatomic, assign) CGSize            contentSize;

@end

@implementation XCWaterCollectionViewLayout

- (NSMutableArray *)allAttribures{
    if (!_allAttribures) {
        _allAttribures = [NSMutableArray arrayWithCapacity:0];
    }
    return _allAttribures;
}

- (NSMutableArray *)sectionAttribures{
    if (!_sectionAttribures) {
        _sectionAttribures = [NSMutableArray arrayWithCapacity:0];
    }
    return _sectionAttribures;
}

- (NSMutableArray *)headerOrFooterAttribures{
    if (!_headerOrFooterAttribures) {
        _headerOrFooterAttribures = [NSMutableArray arrayWithCapacity:0];
    }
    return _headerOrFooterAttribures;
}

- (instancetype)init{
    if (self = [super init]) {
        self.scrollDirection = XCWaterCollectionViewScrollDirectionVertical;
        self.itemColumns = 2;
        self.itemSpace       = 0.f;
        self.lineSpace       = 0.f;
        self.headerViewSize  = CGSizeZero;
        self.footerSize      = CGSizeZero;
        self.sectioinInsets  = UIEdgeInsetsZero;
        self.itemWidthOrHeight = 0.f;
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    if (self.scrollDirection == XCWaterCollectionViewScrollDirectionHorizontal) {
        [self generateHorizontalLayouts];
    }else{
        [self generateVerticalLayouts];
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.allAttribures;
}

- (CGSize)collectionViewContentSize{
    return _contentSize;
}

- (void)generateVerticalLayouts{
    
    self.delegate = self.collectionView.delegate;
    
    NSInteger columns = self.itemColumns;
    if ([self.delegate respondsToSelector:@selector(itemColumns)]) {
        columns = [self.delegate itemColumns];
    }
    if (columns <= 0) {
        columns = 1;
    }
    
    
    NSInteger sections = self.collectionView.numberOfSections;
    
    
    [self.allAttribures removeAllObjects];
    [self.sectionAttribures removeAllObjects];
    [self.headerOrFooterAttribures removeAllObjects];
    
    NSMutableArray *columnsHeight = [NSMutableArray arrayWithCapacity:columns];
    for (int i = 0; i < columns; i++) {
        [columnsHeight addObject:[NSNumber numberWithFloat:0.f]];
    }
        
    for (NSInteger section = 0; section < sections; section++) {

        UIEdgeInsets sectionInsets = self.sectioinInsets;
        CGFloat itemSpace = self.itemSpace;
        CGFloat lineSpace = self.lineSpace;
        
        if ([self.delegate respondsToSelector:@selector(sectionInsetsAtSection:)]) {
            sectionInsets = [self.delegate sectionInsetsAtSection:section];
        }
        if ([self.delegate respondsToSelector:@selector(itemSpaceAtSectioin:)]) {
            itemSpace = [self.delegate itemSpaceAtSectioin:section];
        }
        if ([self.delegate respondsToSelector:@selector(itemLineSpaceAtSection:)]) {
            lineSpace = [self.delegate itemLineSpaceAtSection:section];
        }
        
        
        
        UICollectionViewLayoutAttributes *headerAttribure = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        CGSize headerSize = self.headerViewSize;
        if ([self.delegate respondsToSelector:@selector(headerViewSizeAtSection:)]) {
            headerSize = [self.delegate headerViewSizeAtSection:section];
        }
        
        CGFloat maxHeight = [self getMaxHeight:columnsHeight];
        headerAttribure.frame = CGRectMake(0, maxHeight, headerSize.width, headerSize.height);
        [self.headerOrFooterAttribures addObject:headerAttribure];
        [self.allAttribures addObject:headerAttribure];
        for (NSInteger i = 0;i < columnsHeight.count; i++) {
            [columnsHeight replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:CGRectGetMaxY(headerAttribure.frame) + sectionInsets.top]];
        }
        
        //单个区
        CGFloat itemWidth = floor((CGRectGetWidth(self.collectionView.frame) - sectionInsets.left - sectionInsets.right - itemSpace * (columns - 1)) / columns);
        NSInteger items = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray  *sectionAtributes = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger item = 0; item < items; item++) {
            CGFloat itemHeight = self.itemWidthOrHeight;
            if ([self.delegate respondsToSelector:@selector(itemHeightAtIndexPath:)]) {
                itemHeight = [self.delegate itemHeightAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            }
            
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            NSInteger minHeightIndex = [self getMineHeightIndex:columnsHeight];
            
            CGFloat itemX = 0;
            CGFloat itemY = 0;
            if (sectionAtributes.count < columns) {
                itemY = [columnsHeight[minHeightIndex] floatValue];
            }else{
                itemY = [columnsHeight[minHeightIndex] floatValue] + lineSpace;
            }
            itemX = sectionInsets.left + minHeightIndex * (itemWidth + itemSpace);
            attribute.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
            [self.allAttribures addObject:attribute];
            [sectionAtributes addObject:attribute];
            [columnsHeight replaceObjectAtIndex:minHeightIndex withObject:[NSNumber numberWithFloat:CGRectGetMaxY(attribute.frame)]];
        }
        
        UICollectionViewLayoutAttributes *footerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        CGSize footerSize = self.footerSize;
        if ([self.delegate respondsToSelector:@selector(footerViewSizeAtSection:)]) {
            footerSize = [self.delegate footerViewSizeAtSection:section];
        }
        maxHeight = [self getMaxHeight:columnsHeight];
        footerAttribute.frame = CGRectMake(0, maxHeight + sectionInsets.bottom, footerSize.width, footerSize.height);
        [self.headerOrFooterAttribures addObject:footerAttribute];
        [self.sectionAttribures addObject:sectionAtributes];
        [self.allAttribures addObject:footerAttribute];
        for (NSInteger i = 0;i < columnsHeight.count; i++) {
            [columnsHeight replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:CGRectGetMaxY(footerAttribute.frame)]];
        }
    }
    _contentSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), [self getMaxHeight:columnsHeight]);
}

- (void)generateHorizontalLayouts{
    
    self.delegate = self.collectionView.delegate;
    
    NSInteger columns = self.itemColumns;
    if ([self.delegate respondsToSelector:@selector(itemColumns)]) {
        columns = [self.delegate itemColumns];
    }
    if (columns <= 0) {
        columns = 1;
    }
    
    NSInteger sections = self.collectionView.numberOfSections;
    
    [self.allAttribures removeAllObjects];
    [self.sectionAttribures removeAllObjects];
    [self.headerOrFooterAttribures removeAllObjects];
    
    NSMutableArray *columnsHeight = [NSMutableArray arrayWithCapacity:columns];
    for (int i = 0; i < columns; i++) {
        [columnsHeight addObject:[NSNumber numberWithFloat:0.f]];
    }
    
    for (NSInteger section = 0; section < sections; section++) {
        
        UIEdgeInsets sectionInsets = self.sectioinInsets;
        CGFloat itemSpace = self.itemSpace;
        CGFloat lineSpace = self.lineSpace;
        
        if ([self.delegate respondsToSelector:@selector(sectionInsetsAtSection:)]) {
            sectionInsets = [self.delegate sectionInsetsAtSection:section];
        }
        if ([self.delegate respondsToSelector:@selector(itemSpaceAtSectioin:)]) {
            itemSpace = [self.delegate itemSpaceAtSectioin:section];
        }
        if ([self.delegate respondsToSelector:@selector(itemLineSpaceAtSection:)]) {
            lineSpace = [self.delegate itemLineSpaceAtSection:section];
        }
        
        UICollectionViewLayoutAttributes *headerAttribure = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        CGSize headerSize = self.headerViewSize;
        if ([self.delegate respondsToSelector:@selector(headerViewSizeAtSection:)]) {
            headerSize = [self.delegate headerViewSizeAtSection:section];
        }
        
        CGFloat maxHeight = [self getMaxHeight:columnsHeight];
        headerAttribure.frame = CGRectMake(maxHeight, 0, headerSize.width, headerSize.height);
        [self.headerOrFooterAttribures addObject:headerAttribure];
        [self.allAttribures addObject:headerAttribure];
        for (NSInteger i = 0;i < columnsHeight.count; i++) {
            [columnsHeight replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:CGRectGetMaxX(headerAttribure.frame) + sectionInsets.left]];
        }
        
        //单个区
        CGFloat itemHeight = floor((CGRectGetHeight(self.collectionView.frame) - sectionInsets.top - sectionInsets.bottom - lineSpace * (columns - 1)) / columns);
        NSInteger items = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray  *sectionAtributes = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger item = 0; item < items; item++) {
            CGFloat itemWidth = self.itemWidthOrHeight;
            if ([self.delegate respondsToSelector:@selector(itemHeightAtIndexPath:)]) {
                itemWidth = [self.delegate itemHeightAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            }
            
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            NSInteger minHeightIndex = [self getMineHeightIndex:columnsHeight];
            
            CGFloat itemX = 0;
            CGFloat itemY = 0;
            if (sectionAtributes.count < columns) {
                itemX = [columnsHeight[minHeightIndex] floatValue];
            }else{
                itemX = [columnsHeight[minHeightIndex] floatValue] + itemSpace;
            }
            itemY = sectionInsets.top + minHeightIndex * (itemHeight + lineSpace);
            attribute.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
            [self.allAttribures addObject:attribute];
            [sectionAtributes addObject:attribute];
            [columnsHeight replaceObjectAtIndex:minHeightIndex withObject:[NSNumber numberWithFloat:CGRectGetMaxX(attribute.frame)]];
        }
        
        UICollectionViewLayoutAttributes *footerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        CGSize footerSize = self.footerSize;
        if ([self.delegate respondsToSelector:@selector(footerViewSizeAtSection:)]) {
            footerSize = [self.delegate footerViewSizeAtSection:section];
        }
        maxHeight = [self getMaxHeight:columnsHeight];
        footerAttribute.frame = CGRectMake(maxHeight + sectionInsets.right, 0, footerSize.width, footerSize.height);
        [self.headerOrFooterAttribures addObject:footerAttribute];
        [self.sectionAttribures addObject:sectionAtributes];
        [self.allAttribures addObject:footerAttribute];
        for (NSInteger i = 0;i < columnsHeight.count; i++) {
            [columnsHeight replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:CGRectGetMaxX(footerAttribute.frame)]];
        }
    }
    _contentSize = CGSizeMake([self getMaxHeight:columnsHeight],CGRectGetHeight(self.collectionView.frame));
}



- (NSInteger)getMineHeightIndex:(NSArray<NSNumber *> *)heights{
    if (heights.count > 0) {
        CGFloat minHeight = [heights[0] floatValue];
        NSInteger index = 0;
        for (NSNumber *height in heights) {
            if ([height floatValue] < minHeight) {
                minHeight = [height floatValue];
                index = [heights indexOfObject:height];
            }
        }
        return index;
    }
    return 0;
}

- (CGFloat)getMaxHeight:(NSArray<NSNumber *> *)heights{
    CGFloat maxHeight = [[heights firstObject] floatValue];
    for (NSNumber *height in heights) {
        maxHeight = MAX(maxHeight, [height floatValue]);
    }
    return maxHeight;
}

- (CGFloat)getMinHeight:(NSArray<NSNumber *> *)heights{
    CGFloat minHeight = [[heights firstObject] floatValue];
    for (NSNumber *height in heights) {
        minHeight = MIN(minHeight, [height floatValue]);
    }
    return minHeight;
}

@end

