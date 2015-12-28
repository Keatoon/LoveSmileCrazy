//
//  ZYBMyPageViewController.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/8.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBMyPageViewController.h"
#import "ZYBLoginViewController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "ZYBhelpViewController.h"
#define kScreenSize [UIScreen mainScreen].bounds.size

@interface ZYBMyPageViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@end

@implementation ZYBMyPageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initWithNavationUI];
    [self createContentUI];
    [self createDataSource];
    [self loginUser];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [self loginUser];
}

-(void)initWithNavationUI{
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 200, 10)];
    lable.text=@"我的主页";
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:lable];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *shutDown=[[UIButton alloc]initWithFrame:CGRectMake(kScreenSize.width-39, 5, 34, 34)];
    [shutDown setImage:[UIImage imageNamed: @"close_normal"] forState:UIControlStateNormal];
    [shutDown addTarget:self action:@selector(closeViewClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:shutDown];
    self.navigationItem.rightBarButtonItem=rightItem;
}
-(void)createContentUI{
    self.userViewBack.frame=CGRectMake(0, 64, self.view.frame.size.width, 220);
    CGRect userImageFrame=self.userImageView.frame;
    userImageFrame.size.width=80;
    userImageFrame.size.height=80;
    userImageFrame.origin.x=kScreenSize.width/2-40;
    userImageFrame.origin.y=30;
    self.userImageView.layer.masksToBounds=YES;
    self.userImageView.layer.cornerRadius=self.userImageView.frame.size.width/2;
    self.userImageView.userInteractionEnabled=YES;
    self.userImageView.frame=userImageFrame;
    CGRect userNameFrame=self.userImageView.frame;
    userNameFrame.origin.y=CGRectGetMaxY(self.userImageView.frame)+15;
    userNameFrame.origin.x=self.view.frame.size.width/2-100;
    userNameFrame.size.width=200;
    userNameFrame.size.height=20;
    self.userNameLable.frame=userNameFrame;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [self.userImageView addGestureRecognizer:singleTap];
}
-(void)tapImageView:(UIGestureRecognizer *)tap{
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]!=nil)
    {
        return;
    }else{

        ZYBLoginViewController *login=[[ZYBLoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }
}
-(void)loginUser{
    NSUserDefaults *userInfo=[NSUserDefaults standardUserDefaults];
    if([userInfo objectForKey:@"uid"]==nil)
    {
        self.userNameLable.text=@"未登录，点击登录";
    }else{
        NSURL *url=[NSURL URLWithString:[userInfo objectForKey:@"iconURL"]];
        [self.userImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed: @"default_user_head"]];
        self.userNameLable.text=[userInfo objectForKey:@"userName"];
    }
}
//关闭
-(void)closeViewClick:(UIButton*)closeBtn{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)createDataSource{
    _dataArry=[[NSMutableArray alloc]initWithObjects:@"联系我们",@"清除缓存",@"关注我们",@"帮助",nil];
    _tableView.delegate=self;
    _tableView.dataSource=self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=_dataArry[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYBhelpViewController *help=[[ZYBhelpViewController alloc]init];
    help.title=self.dataArry[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
 
            [self.navigationController pushViewController:help animated:YES];
        }
            break;
        case 1:
        {
            //清除缓存  1.自己做的缓存界面 2.SDWebImage的缓存 (自带清除功能)
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"清除缓存:%.6fM",[self getCachesSize]] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
            [actionSheet showInView:self.view];

        }
            break;
        case 2:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/lovesmilecrazy"]];
        }
            break;
        case 3:
        {
             [self.navigationController pushViewController:help animated:YES];
        }
            break;
        default:
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width,50)];
    NSUserDefaults *userInfo=[NSUserDefaults standardUserDefaults];
    but.backgroundColor=[UIColor colorWithRed:245/255.0 green:239/255.0 blue:236/255.0 alpha:1.0];
    if([userInfo objectForKey:@"uid"]!=nil)
    {
        [but setTitle:@"退出登录" forState:UIControlStateNormal];
        [but setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(OutLogin:) forControlEvents:UIControlEventTouchUpInside];
        return but;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
-(void)OutLogin:(UIButton *)button{
    //点击退出登录
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"退出登录" message:@"确定退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"iconURL"];
        self.userImageView.image=[UIImage imageNamed: @"default_user_head"];
        self.userNameLable.text=@"未登录，点击登录";
    }
}

//获取所有缓存大小
- (double)getCachesSize {
    //1.自定义的缓存 2.sd 的缓存
    NSUInteger sdFileSize = [[SDImageCache sharedImageCache] getSize];
    
    //先获取 系统 Library/Caches 路径
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] ;
    NSString *myCachesPath = [caches stringByAppendingPathComponent:@"MyCaches"];
    //遍历 自定义缓存文件夹
    //目录枚举器 ，里面存放着  文件夹中的所有文件名
    NSDirectoryEnumerator *enumrator = [[NSFileManager defaultManager] enumeratorAtPath:myCachesPath];
    
    NSUInteger mySize = 0;
    //遍历枚举器
    for (NSString *fileName in enumrator) {
        //文件路径
        NSString *filePath = [myCachesPath stringByAppendingPathComponent:fileName];
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //获取大小
        mySize += fileDict.fileSize;//字节大小
    }
    //1M == 1024KB == 1024*1024bytes
    return (mySize+sdFileSize)/1024.0/1024.0;
}
//点击 操作表单的按钮
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        //删除
        //1.删除sd
        [[SDImageCache sharedImageCache] clearMemory];//清除内存缓存
        //2.清除 磁盘缓存
        [[SDImageCache sharedImageCache] clearDisk];
        
        //清除自己的缓存
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] ;
        NSString *myCachesPath = [caches stringByAppendingPathComponent:@"MyCaches"];
        //删除
        [[NSFileManager defaultManager] removeItemAtPath:myCachesPath error:nil];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
