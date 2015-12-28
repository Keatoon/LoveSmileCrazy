//
//  ZYBCommentViewController.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/5.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBCommentViewController.h"
#import "ZYBCommentViewCell.h"
#import "ZYBJokesCell.h"
#import "ZYBCommentModel.h"
#import "AFNetworking.h"
#import "ZYBHelper.h"
#import "UMSocial.h"
#import "ZYBLoginViewController.h"

@interface ZYBCommentViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    AFHTTPRequestOperationManager *_manager;
    
}
@end

@implementation ZYBCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets=YES;
    self.currentPage=1;
    [self createTableView];
    [self createHttpRequest];
    [self loadDataWithJokeId:[self.jokesModel.jId integerValue] withPage:1];
    
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
    [_tableView registerNib:[UINib nibWithNibName:@"ZYBJokesCell" bundle:nil] forCellReuseIdentifier:@"ZYBJokesCell"];
        ZYBJokesCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ZYBJokesCell" forIndexPath:indexPath];
        [cell showDataWithModel:self.jokesModel jumpCommentblock:nil withShareBlock:^(ZYBJokesModel *model) {
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
    CGFloat h=77;
        h+=15+[ZYBHelper textHeightFromTextString:self.jokesModel.text width:290 fontSize:15];
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
        return h+10;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
