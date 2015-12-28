//
//  ZYBImageCell.h
//  ZYBWaterFlow
//
//  Created by qianfeng001 on 15/8/12.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "HMWaterflowView.h"
#import "ZYBImageModel.h"
#import "HMWaterflowViewCell.h"
typedef void (^ShareBlock)(ZYBImageModel *model);
typedef void(^likeBlock)(void);
@class HMWaterflowView;

@interface ZYBImageCell :HMWaterflowViewCell
@property(nonatomic,strong)ZYBImageModel *model;
@property(nonatomic,copy)ShareBlock shareBlock;
@property(nonatomic,copy)likeBlock block;

+(instancetype)cellWithWaterflowView:(HMWaterflowView *)waterflowView;
-(void)showDataWithModel:(ZYBImageModel *)model withShareBlock:(ShareBlock)shareBlock withBlock:(likeBlock)likeBlock;
@end
