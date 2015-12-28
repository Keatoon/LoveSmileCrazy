//
//  ZYBLoginViewController.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/8.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYBLoginViewController : UIViewController
- (IBAction)SinaLoginClick:(UIButton *)sender;
- (IBAction)TenXunLoginClick:(UIButton *)sender;
- (IBAction)WxLoginClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxbtn;
@property (weak, nonatomic) IBOutlet UILabel *qqLable;
@property (weak, nonatomic) IBOutlet UILabel *wxLable;

@end
