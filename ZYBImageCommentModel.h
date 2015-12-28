//
//  ZYBImageCommentModel.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/8.
//  Copyright (c) 2015年 ZYBin. All rights reserved.
//

#import "ZYBBaseModel.h"

@interface ZYBImageCommentModel : ZYBBaseModel
@property(nonatomic,copy)NSString *group_id;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *user_name;
@property(nonatomic,copy)NSString *user_profile_image_url;

@end
