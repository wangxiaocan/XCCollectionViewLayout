//
//  WaterViewController.m
//  PageTest
//
//  Created by xiao can on 2019/6/16.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import "WaterViewController.h"
#import "XCWaterCollectionViewLayout.h"
#import "WaterHorizontalCell.h"

@interface WaterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,XCWaterCollectionViewLayoutDelegate>

@property (nonatomic, strong) UICollectionView  *collectView;
@property (nonatomic, strong) NSMutableArray    *sections;

@end

@implementation WaterViewController

- (NSMutableArray *)sections{
    if (!_sections) {
        _sections = [NSMutableArray arrayWithCapacity:0];
    }
    return _sections;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTitle:@"瀑布流"];
    
    XCWaterCollectionViewLayout *layout = [[XCWaterCollectionViewLayout alloc] init];
    layout.scrollDirection = XCWaterCollectionViewScrollDirectionVertical;
    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame)) collectionViewLayout:layout];
    _collectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _collectView.backgroundColor = [UIColor whiteColor];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    [_collectView registerNib:[UINib nibWithNibName:@"WaterHorizontalCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WaterHorizontalCell class])];
    [_collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:_collectView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 8.0;
    btn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 100.0 - 15.0, CGRectGetHeight(self.view.frame) - 30 - 40.0, 100, 40);
    [btn setTitle:@"增加数据" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:15];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)btnClick:(UIButton *)sender{
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 10; i++) {
        [datas addObject:@([@[@(25),@(40),@(55),@(70),@(85)][rand() % 5] floatValue] + 140)];
    }
    [self.sections addObject:datas];
//    [_collectView reloadData];
    [_collectView insertSections:[NSIndexSet indexSetWithIndex:self.sections.count - 1]];
}

- (NSInteger)itemColumns{
    return 2;
}

- (CGFloat)itemSpaceAtSectioin:(NSInteger)section{
    return 20.0;
}
- (CGFloat)itemLineSpaceAtSection:(NSInteger)section{
    return 15.0;
}

- (UIEdgeInsets)sectionInsetsAtSection:(NSInteger)section{
    return UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
}

- (CGFloat)itemHeightAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *datas = [self.sections objectAtIndex:indexPath.section];
    return [datas[indexPath.item] floatValue];
}
- (CGSize)headerViewSizeAtSection:(NSInteger)section{

    return CGSizeMake(CGRectGetWidth(self.view.frame), 50.0);
}
- (CGSize)footerViewSizeAtSection:(NSInteger)section{
    return CGSizeZero;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *datas = [self.sections objectAtIndex:section];
    return datas.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:([kind isEqualToString:UICollectionElementKindSectionHeader]?@"header":@"footer") forIndexPath:indexPath];
    UILabel *label = [view viewWithTag:101];
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"Marker Felt" size:20];
        label.textColor = [UIColor blackColor];
        label.tag = 101;
        label.numberOfLines = 0;
        label.frame = view.bounds;
        [view addSubview:label];
    }
    label.textAlignment = NSTextAlignmentLeft;
    label.text = [NSString stringWithFormat:@"　　section %ld",(long)indexPath.section];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WaterHorizontalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WaterHorizontalCell class]) forIndexPath:indexPath];
    cell.coverTitle.text = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.item];
    cell.coverImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",rand() % 4 + 1]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"click cell at section: %ld  at item: %ld",(long)indexPath.section,(long)indexPath.item);
}

@end
