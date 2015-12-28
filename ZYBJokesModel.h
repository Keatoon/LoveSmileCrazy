//
//  ZYBJokesModel.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/1.
//  Copyright (c) 2015年 ZYBin. All rights reserved.
//

#import "ZYBBaseModel.h"

@interface ZYBJokesModel : ZYBBaseModel
@property(nonatomic,copy)NSString *jId;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *authorId;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSMutableArray *images;
@property(nonatomic,strong)NSMutableArray *tags;
@property(nonatomic,assign)NSInteger like;
@property(nonatomic,assign)NSInteger comment;
@property(nonatomic,assign)NSInteger shared;

@end
