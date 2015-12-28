//
//  ZYBDetailViewController.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/8.
//  Copyright (c) 2015年 ZYBin. All rights reserved.
//

#import "ZYBDetailViewController.h"
#import "AFNetworking.h"
#import "ZYBComicCell.h"
#import "ZYBCommentViewCell.h"
#import "ZYBImageCommentModel.h"
#import "JHRefresh.h"
#import "ZYBHelper.h"
#import "UMSocial.h"
#import "ZYBLoginViewController.h"

@interface ZYBDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@end

@implementation ZYBDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createHttpRequest];
    [self createRefreshTableView];
    self.allOffset=0;
    self.isLoadMore=NO;
    [self loadDataWithGroupId:_imageModel.group_id withOffset:self.allOffset withCount:20];
}
-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    
    [self.view addSubview:_tableView];
}
-(void)createRefreshTableView
{
    __weak typeof(self)weakself=self;
    [weakself.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if(weakself.isLoadMore)
        {
            return ;
        }
        weakself.isLoadMore=YES;
        weakself.allOffset+=20;
        [weakself loadDataWithGroupId:self.imageModel.group_id withOffset:self.allOffset withCount:20];
    }];
}

#pragma mark-结束刷新
-(void)endRefresh{
    if(self.isLoadMore)
    {
        self.isLoadMore=NO;
        [self.tableView footerEndRefreshing];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        
        [_tableView registerNib:[UINib nibWithNibName:@"ZYBComicCell" bundle:nil] forCellReuseIdentifier:@"ZYBComicCell"];
        ZYBComicCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ZYBComicCell" forIndexPath:indexPath];
        
        [cell showDataWithModel:self.imageModel withShareBlock:^(ZYBImageModel *model) {
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
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        [_tableView registerNib:[UINib nibWithNibName:@"ZYBCommentViewCell" bundle:nil] forCellReuseIdentifier:@"ZYBCommentViewCell"];
        ZYBCommentViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ZYBCommentViewCell" forIndexPath:indexPath];
        

        if(self.dataArry.count==0)
        {
            cell.textLable.text=@"暂时还咩有品论哦！";
        }else{
        ZYBImageCommentModel *model=_dataArry[indexPath.row-1];
            [cell showDataWithImageCommentModel:model withIndext:indexPath.row];
            return cell;
        }
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        CGFloat h=5;

        h+=self.imageModel.middle_height.doubleValue*(kScreenSize.width-20)/self.imageModel.middle_width.doubleValue;
        h+=50;
        return h;
        
        
    }else{
        CGFloat h=35;
        if(self.dataArry.count!=0)
        {
            ZYBCommentModel *model=self.dataArry[indexPath.row-1];
            
            h+=30+[ZYBHelper textHeightFromTextString:model.description width:kScreenSize.width-80 fontSize:16];
            if(h<70)
            {
                h=70;
            }
        }
        return h;
    }

}
-(void)createHttpRequest{
    _manager=[AFHTTPRequestOperationManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    _dataArry=[[NSMutableArray alloc]init];
}
-(void)loadDataWithGroupId:(NSString *)groupID withOffset:(NSInteger)offset withCount:(NSInteger)count{
    NSString *url=[NSString stringWithFormat:zComicDetailUrl,groupID,count,offset];
    __weak typeof(self) weakself=self;
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject)
        {
            NSLog(@"下载成功！");
            NSDictionary *resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *group_id=[NSString stringWithFormat:@"%@",resultDict[@"group_id"]];
            NSString *message=[NSString stringWithFormat:@"%@",resultDict[@"message"]];
            NSArray *arr=resultDict[@"data"];
            for (NSDictionary *dict in arr) {
                ZYBImageCommentModel *model=[[ZYBImageCommentModel alloc]init];
                model.group_id=group_id;
                model.message=message;
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArry addObject:model];
            }
            NSLog(@"arr%ld",self.dataArry.count);
            [weakself.tableView reloadData];
            [weakself endRefresh];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
         [weakself endRefresh];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
