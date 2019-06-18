//
//  PageController.m
//  PageTest
//
//  Created by xiao can on 2019/5/21.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import "PageController.h"

@interface PageController ()

@property (nonatomic, strong) UILabel   *pageLabel;

@end

@implementation PageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:random() % 256 / 255.0 green:random() % 256 / 255.0 blue:random() % 256 / 255.0 alpha:1.0];
    
    _pageLabel = [[UILabel alloc] init];
    _pageLabel.font = [UIFont boldSystemFontOfSize:40];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    _pageLabel.textColor = [UIColor redColor];
    _pageLabel.frame = self.view.bounds;
    [self.view addSubview:_pageLabel];
    if (_page) {
        _pageLabel.text = _page;
    }
}


- (void)setPage:(NSString *)page{
    _page = [page copy];
    if (_pageLabel) {
        _pageLabel.text = _page;
    }
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
