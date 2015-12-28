
//
//  ZYBGodCommentViewController.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/5.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBGodCommentViewController.h"
#import "ZYBCommentViewCell.h"
#import "ZYBGodImageCell.h"
#import "ZYBCommentModel.h"
#import "AFNetworking.h"
#import "ZYBHelper.h"
#import "UMSocial.h"

@interface ZYBGodCommentViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
  AFHTTPRequestOperationManager *_manager;
}

@end

@implementation ZYBGodCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.currentPage=1;
    [self createTableView];
    [self createHttpRequest];
    [self loadDataWithJokeId:[self.godModel.id integerValue] withPage:1];

}
-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    
    [self.view addSubview:_tableView];
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
        [_tableView registerNib:[UINib nibWithNibName:@"ZYBGodImageCell" bundle:nil] forCellReuseIdentifier:@"ZYBGodImageCell"];
        ZYBGodImageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ZYBGodImageCell" forIndexPath:indexPath];
        
        [cell showDataWithModel:self.godModel  jumpBlock:nil withShareBlock:^(ZYBGodImageModel *model) {
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
        
        return cell;
    }
    else
    {
        [_tableView registerNib:[UINib nibWithNibName:@"ZYBCommentViewCell" bundle:nil] forCellReuseIdentifier:@"ZYBCommentViewCell"];
        ZYBCommentViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ZYBCommentViewCell" forIndexPath:indexPath];
        
        ZYBCommentModel *model=_dataArry[indexPath.row-1];
        [cell showDataWithModel:model withIndext:indexPath.row];
        return cell;
    }
}
-(void)createHttpRequest{
    _manager=[AFHTTPRequestOperationManager manager];
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    _dataArry=[[NSMutableArray alloc]init];
}
-(void)loadDataWithJokeId:(NSInteger)jokeID withPage:(NSInteger)page{
    NSString *url=[NSString stringWithFormat:zJokesCommentsUrl,jokeID,page];
    __weak typeof(self) weakself=self;
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject)
        {
            NSLog(@"下载成功！");
            if(weakself.currentPage==0)
            {
                [_dataArry removeAllObjects];
            }
            NSDictionary *resultDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr=resultDict[@"result"][@"all"];
            for (NSDictionary *contentDict in arr) {
                ZYBCommentModel *model=[[ZYBCommentModel alloc]init];
                model.content=contentDict[@"content"];
                model.name=contentDict[@"user"][@"name"];
                model.avatar=contentDict[@"user"][@"avatar"];
                [_dataArry addObject:model];
            }
            [weakself.tableView reloadData];
            NSLog(@"数组的长度：%ld",_dataArry.count);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        CGFloat h=70+20;
        CGSize imageSize=[ZYBHelper getImageSizeWithUrl:self.godModel.images[0]];
        //根据图片的实际大小  和显示  的宽等比例算出高度
        //h/w==h1/w1======>h*w1/
        h+=imageSize.height*(kScreenSize.width-20)/imageSize.width+20;
        h+=[ZYBHelper textHeightFromTextString:self.godModel.text width:kScreenSize.width-20 fontSize:15]+20;
        h+=40;
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
        return h+10;
    }
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
