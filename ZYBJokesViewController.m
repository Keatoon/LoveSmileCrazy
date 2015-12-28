
//
//  ZYBJokesViewController.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/1.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBJokesViewController.h"
#define ZJokes @"ZYBJokesCell"
#import "ZYBJokesCell.h"
#import "ZYBJokesModel.h"
#import "ZYBAuthorModel.h"
#import "ZYBHelper.h"
#import "ZYBCommentViewController.h"
#import "UMSocial.h"
#import "ZYBLoginViewController.h"



@interface ZYBJokesViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>

@end

@implementation ZYBJokesViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotionCener:) name:@"loginOut" object:nil];
}




-(void)NotionCener:(NSNotification *)noti{
    NSLog(@"段子收到通知");
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
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [_tableView registerNib:[UINib nibWithNibName:ZJokes bundle:nil] forCellReuseIdentifier:ZJokes];
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
    NSString *url=[NSString stringWithFormat:zJokesUrl,page];
      __weak typeof(self) weakself=self;
    //加上缓存,有些时候我们的app界面 希望在离线情况下，浏览一页以前的数据，这时我们可以对这个界面把第一页数据做本地存储(不同需求做好可能一样)，这样的话可以节省流量，提高用户体验。
    //走本地满足3个条件 1.缓存文件存在2.不是刷新 3.没有超时
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[ZYBHelper getFullPathWithFile:url]];
    //文件是否超时 1小时
    BOOL isTimerOut = [ZYBHelper isTimeOutWithFile:[ZYBHelper getFullPathWithFile:url] timeOut:60*60];
    if ((isExist == YES)&&(self.isRefreshing == NO)&&(isTimerOut == NO)) {
        //满足三个条件走本地
        
        //读缓存
        NSData *data = [NSData dataWithContentsOfFile:[ZYBHelper getFullPathWithFile:url]];
        
        //json 解析
       NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               //数据源数组变了 刷新表格
        for (NSDictionary *itemDict in jsonArr) {
            ZYBJokesModel *model=[[ZYBJokesModel alloc]init];
            model.jId=itemDict[@"id"];
            //kvc进行赋值
            [model setValuesForKeysWithDictionary:itemDict];
            NSDictionary *auther=itemDict[@"author"];
            model.authorId=auther[@"id"];
            model.name=auther[@"name"];
            model.avatar=auther[@"avatar"];
            model.text=itemDict[@"content"][@"text"];
            
            //数据源
            [weakself.dataArry addObject:model];
        }

        [weakself.tableView reloadData];
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
                ZYBJokesModel *model=[[ZYBJokesModel alloc]init];
                //kvc进行赋值
                 model.jId=itemDict[@"id"];
                [model setValuesForKeysWithDictionary:itemDict];
                NSDictionary *auther=itemDict[@"author"];
                
                model.authorId=auther[@"id"];
                model.name=auther[@"name"];
                model.avatar=auther[@"avatar"];
                model.text=itemDict[@"content"][@"text"];
                
                //数据源
                [weakself.dataArry addObject:model];
                
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
    NSLog(@"===%ld",self.dataArry.count);
    return _dataArry.count;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYBJokesCell *cell=[tableView dequeueReusableCellWithIdentifier:ZJokes forIndexPath:indexPath];
    ZYBJokesModel *model=_dataArry[indexPath.row];
    [cell showDataWithModel:model jumpCommentblock:^{
        ZYBCommentViewController *comment=[[ZYBCommentViewController alloc]init];
        comment.jokesModel=_dataArry[indexPath.row];
        [self.navigationController pushViewController:comment animated:YES];
    } withShareBlock:^(ZYBJokesModel *model) {
        //实现回调方法（可选）：
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"55c71eabe0f55a757c009208"
                                          shareText:model.text
                                         shareImage:[UIImage imageNamed:@"icon"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                           delegate:self];

    } withLikeBlock:^{
        ZYBLoginViewController *login=[[ZYBLoginViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark-分享回调方法！
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYBCommentViewController *comment=[[ZYBCommentViewController alloc]init];
    comment.jokesModel=_dataArry[indexPath.row];
    [self.navigationController pushViewController:comment animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYBJokesModel *model=self.dataArry[indexPath.row];
    CGFloat h=77;
    h+=15+[ZYBHelper textHeightFromTextString:model.text width:kScreenSize.width-30 fontSize:15];
    h+=50;
    return h;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
