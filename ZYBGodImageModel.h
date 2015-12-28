//
//  ZYBGodImageModel.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 ZYBin. All rights reserved.
//

#import "ZYBBaseModel.h"

@interface ZYBGodImageModel : ZYBBaseModel

@property(nonatomic,copy)NSString *id;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *authorId;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSMutableArray *images;
@property(nonatomic,assign)NSInteger like;
@property(nonatomic,assign)NSInteger comment;
@property(nonatomic,assign)NSInteger shared;
@property(nonatomic,strong)NSMutableArray *tags;
@end
