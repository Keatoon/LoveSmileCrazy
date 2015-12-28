//
//  ZYBMengViewController.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/1.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBBaseViewController.h"
#import "HMWaterflowView.h"
#import "HMWaterflowViewCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "ZYBImageModel.h"
#import "ZYBImageCell.h"
#import "ZYBHelper.h"
#import "JHRefresh.h"

@interface ZYBMengViewController : ZYBBaseViewController<HMWaterflowViewDataSource ,HMWaterflowViewDelegate>
{
    NSMutableArray *_dataArry;
    AFHTTPRequestOperationManager *_manager;
    HMWaterflowView *_wf;
    //是否刷新
    BOOL _isRefreshing;
    BOOL _isLoadMore;
    
}
@property(nonatomic,strong)NSMutableArray *dataArry;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)HMWaterflowView *wf;
@property(nonatomic,copy)NSString *behot_time;//加载更多地时候为上一页的最后一个时间
@property(nonatomic)BOOL isRefreshing;
@property(nonatomic)BOOL isLoadMore;

@end
