//
//  ZYBImageModel.h
//  ZYBUiCollectionView
//
//  Created by qianfeng001 on 15/8/6.
//  Copyright (c) 2015年 ZYBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYBBaseModel.h"
@interface ZYBImageModel :ZYBBaseModel
@property(nonatomic,copy)NSString *group_id;
@property(nonatomic,copy)NSString *description;
@property(nonatomic,copy)NSString *thumbnail_url;
@property(nonatomic,copy)NSString *middle_url;
@property(nonatomic,copy)NSString *comment_count;
@property(nonatomic,copy)NSString *repin_count;//喜欢收藏
@property(nonatomic,copy)NSString *middle_height;
@property(nonatomic,copy)NSString *middle_width;
@property(nonatomic,copy)NSString * is_gif;
@property(nonatomic,copy)NSString *share_url;
@property(nonatomic,copy)NSString *behot_time;
@property(nonatomic)CGFloat height;
@property(nonatomic)CGFloat width;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end
