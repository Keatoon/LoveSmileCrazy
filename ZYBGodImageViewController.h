//
//  ZYBGodImageViewController.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/1.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBBaseViewController.h"
#import "AFNetworking.h"
#import "JHRefresh.h"
#import "ZYBLoginViewController.h"

@interface ZYBGodImageViewController : ZYBBaseViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArry;
    //是否刷新
    BOOL _isRefreshing;
    BOOL _isLoadMore;
    NSInteger _currentPage;
    
    AFHTTPRequestOperationManager *_manager;
}
@property(nonatomic,copy)UITableView *tableView;
@property(nonatomic,copy)NSMutableArray *dataArry;
@property(nonatomic)BOOL isRefreshing;
@property(nonatomic)BOOL isLoadMore;
@property(nonatomic)NSInteger currentPage;
@end
