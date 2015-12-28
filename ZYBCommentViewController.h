//
//  ZYBCommentViewController.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/5.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBBaseViewController.h"
#import "ZYBJokesModel.h"

@interface ZYBCommentViewController : ZYBBaseViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArry;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArry;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)ZYBJokesModel *jokesModel;
@end
