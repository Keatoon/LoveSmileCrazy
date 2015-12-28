//
//  ZYBDetailViewController.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/8.
//  Copyright (c) 2015年 ZYBin. All rights reserved.
//

#import "ZYBBaseViewController.h"
#import "ZYBImageModel.h"

@interface ZYBDetailViewController : ZYBBaseViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArry;
    ZYBImageModel *_imageModel;
    BOOL _isLoadMore;
    NSInteger _allOffset;

}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArry;
@property(nonatomic,strong)ZYBImageModel *imageModel;
@property(nonatomic)BOOL isLoadMore;
@property(nonatomic,assign)NSInteger allOffset;

@end
