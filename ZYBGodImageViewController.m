//
//  ZYBGodImageViewController.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/1.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBGodImageViewController.h"
#import "ZYBGodImageModel.h"

#define zGodImage @"ZYBGodImageCell"
#import "ZYBGodImageCell.h"
#import "ZYBGodCommentViewController.h"
#import "ZYBHelper.h"
#import "UMSocial.h"

@interface ZYBGodImageViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>

@end

@implementation ZYBGodImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
  
}


#pragma mark-初始化
-(void)initWithView{
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.currentPage=1;
    self.isRefreshing=NO;
    self.isLoadMore=NO;
    [self createTableView];
    [self createRequestNet];
    [self createRefreshTableView];
    [self DownLoadDataWithPage:self.currentPage];
}

#pragma mark- 上啦加载  下拉刷新

-(void)createRefreshTableView
{
    __weak typeof(self)weakself=self;
    [weakself.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if(weakself.isRefreshing)
        {
            return ;
        }
        weakself.isRefreshing=YES;
        weakself.currentPage=1;
        [weakself DownLoadDataWithPage:weakself.currentPage];
    }];
    [weakself.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if(weakself.isLoadMore)
        {
            return ;
        }
        weakself.isLoadMore=YES;
        weakself.currentPage++;
        [weakself DownLoadDataWithPage:weakself.currentPage];
    }];
}

#pragma mark-结束刷新
-(void)endRefresh{
    if(self.isRefreshing)
    {
        self.isRefreshing=NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if(self.isLoadMore)
    {
        self.isLoadMore=NO;
        [self.tableView footerEndRefreshing];
    }
}


#pragma mark-创建TableView
-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width,kScreenSize.height-64-50) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor colorWithRed:245/255.0 green:239/255.0 blue:236/255.0 alpha:1.0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //去掉tableView的分割线
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:zGodImage bundle:nil] forCellReuseIdentifier:zGodImage];
    [self.view addSubview:_tableView];
}
#pragma -mark 创建下载管理  下载数据
-(void)createRequestNet{
    _manager=[AFHTTPRequestOperationManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    _dataArry=[[NSMutableArray alloc]init];
}
#pragma mark-下载数据
-(void)DownLoadDataWithPage:(NSInteger)page{
    NSString *url=[NSString stringWithFormat:zGodImageUrl,page];
    __weak typeof(self) weakself=self;
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[ZYBHelper getFullPathWithFile:url]];
    //文件是否超时 1小时
    BOOL isTimerOut = [ZYBHelper isTimeOutWithFile:[ZYBHelper getFullPathWithFile:url] timeOut:60*60];
    if ((isExist == YES)&&(self.isRefreshing == NO)&&(isTimerOut == NO)) {
        //满足三个条件走本地
        
        //读缓存
        NSData *data = [NSData dataWithContentsOfFile:[ZYBHelper getFullPathWithFile:url]];
        
        //json 解析
        NSArray *jsonArr=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *itemDict in jsonArr) {
            ZYBGodImageModel *model=[[ZYBGodImageModel alloc]init];
            
            //kvc进行赋值
            [model setValuesForKeysWithDictionary:itemDict];
            NSDictionary *auther=itemDict[@"author"];
            
            model.authorId=auther[@"id"];
            model.name=auther[@"name"];
            model.avatar=auther[@"avatar"];
            model.text=itemDict[@"content"][@"text"];
            NSMutableArray *arry=[[NSMutableArray alloc]init];
            for (NSString *str in itemDict[@"tags"]) {
                [arry addObject:str];
            }
            model.tags=[NSMutableArray arrayWithArray:arry];
            
            NSMutableArray *imgArr=[[NSMutableArray alloc]init];
            for (NSString *imgurl in itemDict[@"content"][@"images"]) {
                [imgArr addObject:imgurl];
            }
            model.images=imgArr;
            BOOL isYes=NO;
            for (NSString *str in model.tags) {
                if([str isEqualToString:@"gif"])
                {
                    isYes=YES;
                }
            }
            if(!isYes)
            {
                //数据源
                [weakself.dataArry addObject:model];
            }
          
        }
          return;
    }

    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        //解析数据
        if(responseObject)
        {
            if(weakself.currentPage==1)
            {
                [weakself.dataArry removeAllObjects];
                //只缓存 第一页数据 保存到本地
                //普通文件缓存
                [[NSFileManager defaultManager] createFileAtPath:[ZYBHelper getFullPathWithFile:url] contents:responseObject attributes:nil];
            }
            NSArray *jsonArr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *itemDict in jsonArr) {
                ZYBGodImageModel *model=[[ZYBGodImageModel alloc]init];
                
                //kvc进行赋值
                    [model setValuesForKeysWithDictionary:itemDict];
                    NSDictionary *auther=itemDict[@"author"];
                    
                    model.authorId=auther[@"id"];
                    model.name=auther[@"name"];
                    model.avatar=auther[@"avatar"];
                    model.text=itemDict[@"content"][@"text"];
                    NSMutableArray *arry=[[NSMutableArray alloc]init];
                    for (NSString *str in itemDict[@"tags"]) {
                        [arry addObject:str];
                    }
                    model.tags=[NSMutableArray arrayWithArray:arry];
                
                    NSMutableArray *imgArr=[[NSMutableArray alloc]init];
                for (NSString *imgurl in itemDict[@"content"][@"images"]) {
                    [imgArr addObject:imgurl];
                }
                model.images=imgArr;
                BOOL isYes=NO;
                for (NSString *str in model.tags) {
                    if([str isEqualToString:@"gif"])
                    {
                        isYes=YES;
                    }
                }
                if(!isYes)
                {
                    //数据源
                    [weakself.dataArry addObject:model];
                }
            }
            //数据源变了 要刷新
            [weakself.tableView reloadData];
            //下载完成 结束刷新
            [weakself endRefresh];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        [weakself endRefresh];
    }];
    
}


#pragma mark-UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYBGodImageCell *cell=[tableView dequeueReusableCellWithIdentifier:zGodImage forIndexPath:indexPath];
    ZYBGodImageModel *model=_dataArry[indexPath.row];
    [cell showDataWithModel:model jumpBlock:^{
          ZYBGodCommentViewController*godComment=[[ZYBGodCommentViewController alloc]init];
        godComment.godModel=_dataArry[indexPath.row];
        [self.navigationController pushViewController:godComment animated:YES];
    } withShareBlock:^(ZYBGodImageModel *model) {
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:model.images[0]];
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"55c71eabe0f55a757c009208"
                                          shareText:model.text
                                         shareImage:[UIImage imageNamed:@"icon"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,nil] delegate:self];
        
    
    } withlike:^{
        ZYBLoginViewController *login=[[ZYBLoginViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h=70+20;
    ZYBGodImageModel *model=_dataArry[indexPath.row];
    CGSize imageSize=[ZYBHelper getImageSizeWithUrl:model.images[0]];
    //根据图片的实际大小  和显示  的宽等比例算出高度
    //h/w==h1/w1======>h*w1/
    h+=imageSize.height*(kScreenSize.width-20)/imageSize.width+20;
    h+=[ZYBHelper textHeightFromTextString:model.text width:kScreenSize.width-20 fontSize:15]+20;
    h+=40;
    return h;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYBGodCommentViewController*godComment=[[ZYBGodCommentViewController alloc]init];
    godComment.godModel=_dataArry[indexPath.row];
    [self.navigationController pushViewController:godComment animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
