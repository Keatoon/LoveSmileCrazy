//
//  ZYBLoginViewController.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/8.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBLoginViewController.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocial.h"


@interface ZYBLoginViewController ()<UIAlertViewDelegate>

@end

@implementation ZYBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        self.qqBtn.hidden=YES;
        self.qqLable.hidden=YES;
    }
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wx://"]]) {
        self.wxbtn.hidden=YES;
        self.wxLable.hidden=YES;
    }

    UIButton *shutDown=[[UIButton alloc]initWithFrame:CGRectMake(kScreenSize.width-39,20, 34, 34)];
    [shutDown setImage:[UIImage imageNamed: @"close_normal"] forState:UIControlStateNormal];
    [shutDown addTarget:self action:@selector(closeViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shutDown];

 }
//关闭
-(void)closeViewClick:(UIButton*)closeBtn{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)SinaLoginClick:(UIButton *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            NSUserDefaults *userInfo=[NSUserDefaults standardUserDefaults];
            [userInfo setObject:snsAccount.userName forKey:@"userName"];
            [userInfo setObject:snsAccount.usid forKey:@"uid"];
            [userInfo setObject:snsAccount.accessToken forKey:@"accessToken"];
            [userInfo setObject:snsAccount.iconURL forKey:@"iconURL"];
            
        }});
  
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)TenXunLoginClick:(UIButton *)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {

        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQzone];
                NSUserDefaults *userInfo=[NSUserDefaults standardUserDefaults];
                [userInfo setObject:snsAccount.userName forKey:@"userName"];
                [userInfo setObject:snsAccount.usid forKey:@"uid"];
                [userInfo setObject:snsAccount.accessToken forKey:@"accessToken"];
                [userInfo setObject:snsAccount.iconURL forKey:@"iconURL"];
                
            }});

         [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"你没有安装QQ" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alerView show];
    }
}

- (IBAction)WxLoginClick:(UIButton *)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSUserDefaults *userInfo=[NSUserDefaults standardUserDefaults];
            [userInfo setObject:snsAccount.userName forKey:@"userName"];
            [userInfo setObject:snsAccount.usid forKey:@"uid"];
            [userInfo setObject:snsAccount.accessToken forKey:@"accessToken"];
            [userInfo setObject:snsAccount.iconURL forKey:@"iconURL"];
        }
    });
    [self.navigationController popViewControllerAnimated:YES];
}
@end
