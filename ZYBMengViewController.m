//
//  ZYBMengViewController.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/1.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBMengViewController.h"
#import "ZYBDetailViewController.h"
#import "UMSocial.h"
#import "ZYBLoginViewController.h"
@interface ZYBMengViewController ()<UMSocialUIDelegate>

@end

@implementation ZYBMengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
}
-(void)initWithView{
    [self createHttpRequest];
    [self createWaterFlow];
    [self createRefreshwaterFlow];
    self.isRefreshing=NO;
    self.isLoadMore=NO;
    [self oneDownLoadDataWithCount:20];
}
-(void)createWaterFlow{
    _wf=[[HMWaterflowView alloc]initWithFrame:self.view.bounds];
    _wf.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _wf.dataSource=self;
    _wf.delegate=self;
    _wf.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [self.view addSubview:_wf];
}

-(void)createHttpRequest
{
    _manager=[AFHTTPRequestOperationManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    _dataArry=[[NSMutableArray alloc]init];
    
}
-(void)createRefreshwaterFlow
{
    __weak typeof(self)weakself=self;
    [weakself.wf addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if(weakself.isRefreshing)
        {
            return ;
        }
        weakself.isRefreshing=YES;
        [weakself oneDownLoadDataWithCount:20];
    }];
    [weakself.wf addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if(weakself.isLoadMore)
        {
            return ;
        }
        weakself.isLoadMore=YES;
        [weakself downLoadDataWithTime:self.behot_time withCount:20];
    }];
}
#pragma mark-结束刷新
-(void)endRefresh{
    if(self.isRefreshing)
    {
        self.isRefreshing=NO;
        [self.wf headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if(self.isLoadMore)
    {
        self.isLoadMore=NO;
        [self.wf footerEndRefreshing];
    }
}
-(void)oneDownLoadDataWithCount:(NSInteger) count{
    NSString *url=[NSString stringWithFormat:zMengUrl,count];
    __block typeof(self)blockself=self;
    //加上缓存,有些时候我们的app界面 希望在离线情况下，浏览一页以前的数据，这时我们可以对这个界面把第一页数据做本地存储(不同需求做好可能一样)，这样的话可以节省流量，提高用户体验。
    //走本地满足3个条件 1.缓存文件存在2.不是刷新 3.没有超时
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[ZYBHelper getFullPathWithFile:url]];
    //文件是否超时 1小时
    BOOL isTimerOut = [ZYBHelper isTimeOutWithFile:[ZYBHelper getFullPathWithFile:url] timeOut:60*60*60];
    if ((isExist == YES)&&(blockself.isRefreshing==NO)&&(isTimerOut == NO)) {
        //满足三个条件走本地
        
        //读缓存
        NSData *data = [NSData dataWithContentsOfFile:[ZYBHelper getFullPathWithFile:url]];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArr=dict[@"data"];
        
        for (int i=0;i<dataArr.count;i++) {
            NSDictionary *dict=dataArr[i];
            ZYBImageModel *model=[[ZYBImageModel alloc]init];
            model.thumbnail_url=dict[@"thumbnail_url"];
            CGSize imgSize=[ZYBHelper downloadImageSizeWithURL:model.thumbnail_url];
            model.height=imgSize.height;
            model.width=imgSize.width;
            
            [model setValuesForKeysWithDictionary:dict];
            self.behot_time=model.behot_time;
            [blockself.dataArry addObject:model];
        }
        [blockself.wf reloadData];
        return;
    }
    
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject)
        {
            if(self.dataArry.count>0)
            {
                [self.dataArry removeAllObjects];
            }
            [[NSFileManager defaultManager] createFileAtPath:[ZYBHelper getFullPathWithFile:url] contents:responseObject attributes:nil];
            NSLog(@"下载 成功");
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *data=dict[@"data"];
            
            for (int i=0;i<data.count;i++) {
                NSDictionary *dict=data[i];
                ZYBImageModel *model=[[ZYBImageModel alloc]init];
                model.thumbnail_url=dict[@"thumbnail_url"];
                CGSize imgSize=[ZYBHelper downloadImageSizeWithURL:model.thumbnail_url];
                model.height=imgSize.height;
                model.width=imgSize.width;
                
                [model setValuesForKeysWithDictionary:dict];
                self.behot_time=model.behot_time;
                
                [blockself.dataArry addObject:model];
            }
            [_wf reloadData];
            [blockself endRefresh];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        [blockself endRefresh];
    }];
}
-(void)downLoadDataWithTime:(NSString *)time withCount:(NSInteger)count
{
    NSString *url=[NSString stringWithFormat:zMengMoreUrl,time,count];
    __block typeof(self)blockself=self;
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *data=dict[@"data"];
        
        for (int i=0;i<data.count;i++) {
            NSDictionary *dict=data[i];
            ZYBImageModel *model=[[ZYBImageModel alloc]init];
            model.thumbnail_url=dict[@"thumbnail_url"];
            CGSize imgSize=[ZYBHelper downloadImageSizeWithURL:model.thumbnail_url];
            model.height=imgSize.height;
            model.width=imgSize.width;
            
            [model setValuesForKeysWithDictionary:dict];
            blockself.behot_time=model.behot_time;
            
            [blockself.dataArry addObject:model];
            
        }
        [blockself.wf reloadData];
         [blockself endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败！");
       [blockself endRefresh];
    }];
}

#pragma  mark-  数据源方法
-(NSUInteger)numberOfCellsInWaterflowView:(HMWaterflowView *)waterflowView
{
    return self.dataArry.count;
}
-(HMWaterflowViewCell *)waterflowView:(HMWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index
{
    ZYBImageCell *imgcell=[ZYBImageCell cellWithWaterflowView:waterflowView];
    ZYBImageModel *model=self.dataArry[index];
    [imgcell showDataWithModel:model withShareBlock:^(ZYBImageModel *model) {
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:model.middle_url];
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"55c71eabe0f55a757c009208"
                                          shareText:model.description
                                         shareImage:[UIImage imageNamed:@"icon"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                           delegate:self];

    } withBlock:^{
        ZYBLoginViewController *login=[[ZYBLoginViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];

    }];
    imgcell.backgroundColor=[UIColor whiteColor];
    return imgcell;
    
}
-(void)waterflowView:(HMWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index
{
    ZYBDetailViewController *detail=[[ZYBDetailViewController alloc]init];
    detail.imageModel=self.dataArry[index];
    [self.navigationController pushViewController:detail animated:YES];
}

-(CGFloat)waterflowView:(HMWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index
{
    CGFloat h=10;
    ZYBImageModel *model=self.dataArry[index];
      CGFloat w=self.view.frame.size.width/2-40;
    h+=w*model.height/model.width;
    if(model.description.length!=0)
    {
        h+=10+[ZYBHelper textHeightFromTextString:model.description width:w fontSize:12]+5;
    }else{
        h+=5;
    }
    return h+30;
}

-(NSUInteger)numberOfColumnsInWaterflowView:(HMWaterflowView *)waterflowView
{
    return 2;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
