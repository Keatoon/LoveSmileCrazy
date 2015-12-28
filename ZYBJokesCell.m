//
//  ZYBJokesCell.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/1.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBJokesCell.h"
#import "UIImageView+WebCache.h"
#import "ZYBHelper.h"
#import "UMSocial.h"

@implementation ZYBJokesCell

- (void)awakeFromNib {
    self.userIconImage.layer.masksToBounds=YES;
    self.userIconImage.layer.cornerRadius=self.userIconImage.bounds.size.width/2;
   
    
}
-(void)showDataWithModel:(ZYBJokesModel *)model jumpCommentblock:(JumpCommentBlock)myBlock withShareBlock:(ShareBlock)shareBlock withLikeBlock:(likeLoginBlock)likeBlock
{
    self.jumpCommentBlock=myBlock;
    self.shareBlock=shareBlock;
    self.likeBlock=likeBlock;
    self.model=model;

    [self.userIconImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed: @"default_user_head"]];
    
    self.userName.text=model.name;
    self.contentLable.text=model.text;
    CGRect textFram=self.contentLable.frame;
    textFram.size.height=[ZYBHelper textHeightFromTextString:model.text width:kScreenSize.width-30 fontSize:15];
    
    self.contentLable.frame=textFram;
    CGRect btnFram=self.btnView.frame;
    btnFram.origin.y=CGRectGetMaxY(self.contentLable.frame)+15;
    btnFram.origin.x=self.contentLable.frame.origin.x;
    btnFram.size.height=30;
    self.btnView.frame=btnFram;
    
    //判断是否被点过
    NSString *str=[[NSString stringWithFormat:@"%@",self.model.jId] stringByAppendingString:[NSString stringWithFormat:@"%@",self.model.authorId]];
    BOOL isLike=[[[NSUserDefaults standardUserDefaults] objectForKey:str]boolValue];
    [self.likebtn setImage:[UIImage imageNamed: @"like_clicked"] forState:UIControlStateSelected];
    
    if(isLike)
    {
        self.likebtn.selected=YES;
        self.likeCountLable.text=[NSString stringWithFormat:@"%ld",self.model.like+1];

    }else
    {
        self.likebtn.selected=NO;
        self.likeCountLable.text=[NSString stringWithFormat:@"%ld",model.like];
    }

    

    self.commentCountLable.text=[NSString stringWithFormat:@"%ld",model.comment];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeClick:(UIButton *)sender {
    NSUserDefaults *userInfo=[NSUserDefaults standardUserDefaults];
    if([userInfo objectForKey:@"uid"]==nil)
    {
        if(self.likeBlock)
        {
            self.likeBlock();
        }
    }else{

    //判断是否被点过
    //拼接key  段子id 和作者id 拼接一个key
     NSString *str=[[NSString stringWithFormat:@"%@",self.model.jId] stringByAppendingString:[NSString stringWithFormat:@"%@",self.model.authorId]];
    BOOL isLike=[[[NSUserDefaults standardUserDefaults] objectForKey:str]boolValue];
    if(isLike)
    {
        NSLog(@"已经点赞过了");
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:str];
    [[NSUserDefaults standardUserDefaults] synchronize];
    sender.selected=YES;
    self.likeCountLable.text=[NSString stringWithFormat:@"%ld",self.model.like+1];
    }
    
}
- (IBAction)CommentClick:(UIButton *)sender {
    if(self.jumpCommentBlock)
    {
        self.jumpCommentBlock();
    }
}
- (IBAction)shareClick:(UIButton *)sender {
    
    if(self.shareBlock)
    {
        self.shareBlock(self.model);
    }
   }
@end
