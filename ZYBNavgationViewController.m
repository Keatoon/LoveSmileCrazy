//
//  ZYBNavgationViewController.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/7.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBNavgationViewController.h"

#import "WMPageController.h"
#import "ZYBBaseViewController.h"
#import "ZYBMyPageViewController.h"
#include "UIImageView+WebCache.h"
#define kScreenSize [UIScreen mainScreen].bounds.size

@interface ZYBNavgationViewController ()
{
    UIImageView *_userImageView;
}
@property(nonatomic,strong)UIImageView *userImageView;
@end

@implementation ZYBNavgationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLaunchImageAnimation];
    [self createUI];
    
    
    
}
- (void)createLaunchImageAnimation {
    //增加一个 程序加载时候的启动动画。下面使我们自己实现的一个 隐藏的动画效果

    UIView *lunchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
    lunchView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:lunchView];
    [UIView animateWithDuration:2 animations:^{
        lunchView.alpha = 0;
    } completion:^(BOOL finished) {
        [lunchView removeFromSuperview];
    }];

    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults *userInfo=[NSUserDefaults standardUserDefaults];
    if([userInfo objectForKey:@"uid"]!=nil)
    {
        NSURL *url=[NSURL URLWithString:[userInfo objectForKey:@"iconURL"]];
        [self.userImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed: @"default_user_head"]];
    }else{
        self.userImageView.image=[UIImage imageNamed: @"default_user_head"];
    }
    

    
}
-(void)createUI{
    WMPageController *pageView=[self getDefaultController];
    pageView.title=@"爱笑狂";
   
   self.userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 34, 34)];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UserClick:)];
    [self.userImageView addGestureRecognizer:singleTap];
    [self.userImageView setImage:[UIImage imageNamed: @"default_user_head"]];

    self.userImageView.layer.masksToBounds=YES;
    self.userImageView.layer.cornerRadius=self.userImageView.frame.size.width/2;
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:self.userImageView];
    pageView.navigationItem.leftBarButtonItem=leftItem;
    
    pageView.menuBGColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    pageView.menuHeight=50;
    self.viewControllers=@[pageView];
    
}
-(void)UserClick:(UIGestureRecognizer *)item{
        ZYBMyPageViewController *myPageView=[[ZYBMyPageViewController alloc]init];
    UINavigationController *mainPageNav=[[UINavigationController alloc]initWithRootViewController:myPageView];
    [self presentViewController:mainPageNav animated:YES completion:nil];
    
}

#pragma mark-创建主视图
- (WMPageController *)getDefaultController{
    NSArray *titles=@[@"段子",@"神图",@"狂笑",@"漫画",@"萌宠"];
    NSArray *ControllersArry=@[@"ZYBJokesViewController",@"ZYBGodImageViewController",@"ZYBSmileViewController",@"ZYBComicViewController",@"ZYBMengViewController"];
    NSMutableArray *controllers=[[NSMutableArray alloc]init];
    for(int i=0;i<ControllersArry.count;i++)
    {
        Class className=NSClassFromString(ControllersArry[i]);
        [controllers addObject:className];
    }
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:controllers andTheirTitles:titles];
    pageVC.pageAnimatable = YES;
    pageVC.menuItemWidth = 50;
    pageVC.postNotification = YES;
    return pageVC;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
