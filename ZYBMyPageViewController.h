//
//  ZYBMyPageViewController.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/8.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYBMyPageViewController : UIViewController
{
    NSMutableArray *_dataArry;
}
@property (weak, nonatomic) IBOutlet UIView *userViewBack;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;


@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArry;

@end
