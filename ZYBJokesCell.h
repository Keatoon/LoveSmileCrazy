//
//  ZYBJokesCell.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/1.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYBJokesModel.h"
typedef void(^JumpCommentBlock)(void);
typedef void (^ShareBlock)(ZYBJokesModel *model);
typedef void(^likeLoginBlock)(void);
@interface ZYBJokesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIconImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
- (IBAction)likeClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLable;
- (IBAction)CommentClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLable;
- (IBAction)shareClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *likebtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIView *btnView;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property(nonatomic,strong)ZYBJokesModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *firstLine;

@property(nonatomic,copy)JumpCommentBlock jumpCommentBlock;
@property(nonatomic,copy)ShareBlock shareBlock;
@property(nonatomic,copy)likeLoginBlock likeBlock;

-(void)showDataWithModel:(ZYBJokesModel *)model jumpCommentblock:(JumpCommentBlock)myBlock withShareBlock:(ShareBlock)shareBlock withLikeBlock:(likeLoginBlock)likeBlock;

@end