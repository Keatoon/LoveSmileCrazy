//
//  ZYBGodImageCell.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYBGodImageModel.h"
typedef void (^JumpCommentBlock)(void);
typedef void (^ShareBlock)(ZYBGodImageModel *model);
typedef void(^likeLoginBlock)(void);

@interface ZYBGodImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UIImageView *imagesView;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
- (IBAction)likeClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *likeLable;

- (IBAction)commentClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *commentLable;
- (IBAction)shareClick:(UIButton *)sender;

@property(nonatomic,strong)ZYBGodImageModel *model;
@property(nonatomic,copy)JumpCommentBlock jumpCommentBlock;
@property(nonatomic,copy)ShareBlock shareBlock;
@property(nonatomic,copy)likeLoginBlock likeBlock;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (weak, nonatomic) IBOutlet UIView *btnView;

-(void)showDataWithModel:(ZYBGodImageModel *)model jumpBlock:(JumpCommentBlock)myBlock withShareBlock:(ShareBlock)shareBlock withlike:(likeLoginBlock)likeBlock;



@end
