//
//  ZYBCommentModel.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/5.
//  Copyright (c) 2015年 ZYBin. All rights reserved.
//

#import "ZYBBaseModel.h"

@interface ZYBCommentModel : ZYBBaseModel

@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,assign)NSInteger total;

@end
