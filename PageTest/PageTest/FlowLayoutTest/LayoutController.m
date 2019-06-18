//
//  LayoutController.m
//  PageTest
//
//  Created by xiao can on 2019/6/12.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import "LayoutController.h"
#import "../XCollectionViewLayout/XCollectionViewLayout.h"
#import "LayoutControlCell.h"

@interface LayoutController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView  *collectView;
@property (nonatomic) BOOL affileTransformStyle;

@end

@implementation LayoutController

- (instancetype)initWithAffineStyle:(BOOL)affineTransform{
    self = [super init];
    if (self) {
        self.affileTransformStyle = affineTransform;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    XCollectionViewLayout *layout = [[XCollectionViewLayout alloc] init];
    layout.transformStyle = self.affileTransformStyle?XCollectionViewLayout_AffineTranform:XCollectionViewLayout_LinerTransform;
    _collectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectView.backgroundColor = [UIColor whiteColor];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    [_collectView registerNib:[UINib nibWithNibName:@"LayoutControlCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LayoutControlCell class])];
    [self.view addSubview:_collectView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(collectionView.frame) * 0.7, CGRectGetHeight(collectionView.frame) * 0.2);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(CGRectGetHeight(collectionView.frame) * 0.4, 0, CGRectGetHeight(collectionView.frame) * 0.4, 0);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LayoutControlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LayoutControlCell class]) forIndexPath:indexPath];
    cell.numlabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item];

    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
