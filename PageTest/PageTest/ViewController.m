//
//  ViewController.m
//  PageTest
//
//  Created by xiao can on 2019/5/21.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import "ViewController.h"
#import "PageController.h"
#import "XC_DeviceInfo.h"
#import "DeviceInfo/DeviceInfoDefine.h"
#import "LayoutController.h"
#import "WaterViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView   *coverImgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)jumpToControl:(UIButton *)sender{
    if (sender.tag == 1) {
        WaterViewController *control = [[WaterViewController alloc] init];
        [self presentViewController:control animated:YES completion:nil];
    }else if (sender.tag == 2) {
        LayoutController *control = [[LayoutController alloc] initWithAffineStyle:YES];
        [self presentViewController:control animated:YES completion:nil];
    }else if (sender.tag == 3) {
        LayoutController *control = [[LayoutController alloc] init];
        [self presentViewController:control animated:YES completion:nil];
    }
}

@end
