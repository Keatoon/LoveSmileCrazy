//
//  ZTBComicCell.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/8.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYBImageModel.h"
typedef void (^ShareBlock)(ZYBImageModel *model);
typedef void (^likeBlock)(void);
@interface ZYBComicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contetImageView;
- (IBAction)likeClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
- (IBAction)commentClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
- (IBAction)shareClick:(UIButton *)sender;
@property(nonatomic,strong)ZYBImageModel *model;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property(nonatomic,copy)ShareBlock shareBlock;
@property(nonatomic,copy)likeBlock block;
@property (weak, nonatomic) IBOutlet UIView *btnView;
-(void)showDataWithModel:(ZYBImageModel *)model withShareBlock:(ShareBlock)shareBlock withBlock:(likeBlock)block;
@end
