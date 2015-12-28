//
//  ZYBGodCommentViewController.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/5.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBBaseViewController.h"
#import "ZYBGodImageModel.h"
#import "ZYBLoginViewController.h"

@interface ZYBGodCommentViewController : ZYBBaseViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArry;
    ZYBGodImageModel *_godModel;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArry;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)ZYBGodImageModel *godModel;
@end
