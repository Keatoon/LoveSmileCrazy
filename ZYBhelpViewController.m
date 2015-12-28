
//
//  ZYBhelpViewController.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/11.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBhelpViewController.h"

@interface ZYBhelpViewController ()

@end

@implementation ZYBhelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"assadsas" style:UIBarButtonItemStyleDone target:self action:@selector(onclick:)];
    [self.navigationItem setBackBarButtonItem:item];
}
-(void)onclick:(UIBarButtonItem *)item{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
