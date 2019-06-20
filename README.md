# XCCollectionViewLayout
- UICollectionView瀑布流效果、滚动放大效果，支持水平、垂直滚动
- [https://www.jianshu.com/p/6fc45587f91b](https://www.jianshu.com/p/6fc45587f91b)


#### 使用pod导入文件或下载解压后将XCollectionViewLayout文件夹导入项目中
> pod 'XCollectionViewLayout'

##### 导入头文件
```Object-C
//瀑布流样式 UICollectionViewLayout
#import "XCWaterCollectionViewLayout.h"

//滑动放大、仿射放大样式 UICollectionViewLayout
#import "XCollectionViewLayout.h"

```

<img src='https://github.com/wangxiaocan/XCCollectionViewLayout/blob/master/Resources/all.gif' width=200/>

|样式|效果图|
|:-:|:-:|
|滚动仿射放大效果|<img src = "https://github.com/wangxiaocan/XCCollectionViewLayout/blob/master/Resources/affine.gif" width = "200px" alt="滚动仿射放大效果"/>|
|滚动放大效果|<img src = "https://github.com/wangxiaocan/XCCollectionViewLayout/blob/master/Resources/lineLayout.gif" width = "200px" alt="滚动放大效果"/>|
|瀑布流-垂直滚动|<img src = "https://github.com/wangxiaocan/XCCollectionViewLayout/blob/master/Resources/vertical.gif" width = "200px" alt="垂直滚动"/>|
|瀑布流-水平滚动|<img src = "https://github.com/wangxiaocan/XCCollectionViewLayout/blob/master/Resources/horizontal.gif" width = "400px" alt="水平滚动"/>|


<h3>导入<b>XCollectionViewLayout.h</b></h3>
<b>XCollectionViewLayout</b>属性及代理

```Object-C
typedef NS_ENUM(NSInteger,XCollectionViewLayoutTransformStyle){
XCollectionViewLayout_LinerTransform,//线性放大
XCollectionViewLayout_AffineTranform,//仿射旋转放大
};

//滚动放大模式（只支持横向滚动）
@interface XCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic) XCollectionViewLayoutTransformStyle transformStyle;
@property (nonatomic) CGFloat                             scaleCoefficient;//缩小系数，default 0.8,建议0.6~0.8

@end
```


<h4>滚动仿射放大效果</h4>

```Object-C
XCollectionViewLayout *layout = [[XCollectionViewLayout alloc] init];
layout.transformStyle = XCollectionViewLayout_AffineTranform;
_collectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
_collectView.backgroundColor = [UIColor whiteColor];
_collectView.delegate = self;
_collectView.dataSource = self;
[_collectView registerNib:[UINib nibWithNibName:@"LayoutControlCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LayoutControlCell class])];
[self.view addSubview:_collectView];
```

<h4>滚动放大效果</h4>

```Object-C
XCollectionViewLayout *layout = [[XCollectionViewLayout alloc] init];
layout.transformStyle = XCollectionViewLayout_LinerTransform;
_collectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
_collectView.backgroundColor = [UIColor whiteColor];
_collectView.delegate = self;
_collectView.dataSource = self;
[_collectView registerNib:[UINib nibWithNibName:@"LayoutControlCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LayoutControlCell class])];
[self.view addSubview:_collectView];
```



<h2>瀑布流效果</h2>
<h4>导入<b>XCWaterCollectionViewLayout.h</b></h4>

```Object-C
XCTransformFlowLayout *layout = [[XCTransformFlowLayout alloc] init];
_collectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
_collectView.backgroundColor = [UIColor lightGrayColor];
_collectView.delegate = self;
_collectView.dataSource = self;
[_collectView registerNib:[UINib nibWithNibName:@"LayoutControlCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LayoutControlCell class])];
    [self.view addSubview:_collectView];
```

```Object-C
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
```

<b>XCWaterCollectionViewLayout</b>属性及代理

```Object-C

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

```

