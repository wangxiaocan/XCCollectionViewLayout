# XCCollectionViewLayout
UICollectionView瀑布流效果、滚动放大效果，支持水平、垂直滚动
[文章地址](https://www.jianshu.com/p/6fc45587f91b)


|样式|效果图|
|:-:|:-:|
|滚动放大效果|<img src = "https://github.com/wangxiaocan/XCCollectionViewLayout/blob/master/Resources/lineLayout.gif" width = "200px" alt="滚动放大效果"/>|
|垂直滚动|<img src = "https://github.com/wangxiaocan/XCCollectionViewLayout/blob/master/Resources/vertical.gif" width = "200px" alt="垂直滚动"/>|
|水平滚动|<img src = "https://github.com/wangxiaocan/XCCollectionViewLayout/blob/master/Resources/horizontal.gif" width = "400px" alt="水平滚动"/>|





<h2>滚动放大效果</h2>
<h4>导入<b>XCollectionViewLineLayout.h</b></h4>

```Object-C
XCollectionViewLineLayout *layout = [[XCollectionViewLineLayout alloc] init];
layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
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

