//
//  ZYBCommentViewCell.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/5.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYBCommentModel.h"
#import "ZYBImageCommentModel.h"

@interface ZYBCommentViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIconImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *textLable;
@property (weak, nonatomic) IBOutlet UIView *bgView;



-(void)showDataWithModel:(ZYBCommentModel *)model withIndext:(NSInteger)indext;

-(void)showDataWithImageCommentModel:(ZYBImageCommentModel*)model withIndext:(NSInteger)indext;

@end
