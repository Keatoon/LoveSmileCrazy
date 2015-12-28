//
//  ZYBGodImageCell.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/3.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBGodImageCell.h"
#import "UIImageView+WebCache.h"
#import "ZYBHelper.h"

@implementation ZYBGodImageCell

- (void)awakeFromNib {

    self.userImageView.layer.masksToBounds=YES;
    self.userImageView.layer.cornerRadius=self.userImageView.bounds.size.width/2;
}

-(void)showDataWithModel:(ZYBGodImageModel *)model jumpBlock:(JumpCommentBlock)myBlock withShareBlock:(ShareBlock)shareBlock withlike:(likeLoginBlock)likeBlock
{
    self.model=model;
    self.jumpCommentBlock=myBlock;
    self.shareBlock=shareBlock;
    self.likeBlock=likeBlock;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed: @"default_user_head"]];
    self.userNameLable.text=model.name;
    
    CGRect contentFrame=self.userImageView.frame;
    CGSize imageSize=[ZYBHelper getImageSizeWithUrl:model.images[0]];
    //根据图片的实际大小  和显示  的宽等比例算出高度
    //h/w==h1/w1======>h*w1/
    contentFrame.size.height=imageSize.height*(kScreenSize.width-20)/imageSize.width;
    contentFrame.size.width=kScreenSize.width-20;

    contentFrame.origin.y=CGRectGetMaxY(self.userImageView.frame)+10;
    
    //异步下载图片
    UIImage *image=[[UIImage imageNamed: @"card_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];//图片拉伸
    //做边第6像素 上边第6 像素拉伸 其他的不变

    [self.imagesView sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:image];
    self.imagesView.frame=contentFrame;
    
    CGRect textFrame=self.imagesView.frame;
    textFrame.size.height=[ZYBHelper textHeightFromTextString:model.text width:kScreenSize.width-20 fontSize:15];
    textFrame.origin.y=CGRectGetMaxY(self.imagesView.frame)+20;
    
    self.contentLable.text=model.text;
    self.contentLable.frame=textFrame;
    
    self.btnView.frame=self.contentLable.frame;
    CGRect btnViewFrame=self.btnView.frame;
    btnViewFrame.size.width=kScreenSize.width;
    btnViewFrame.origin.x=0;
    btnViewFrame.origin.y=CGRectGetMaxY(self.contentLable.frame)+20;
    self.btnView.frame=btnViewFrame;
    
    //判断是否被点过
    NSString *str=[[NSString stringWithFormat:@"%@",self.model.id] stringByAppendingString:[NSString stringWithFormat:@"%@",self.model.authorId]];
    BOOL isLike=[[[NSUserDefaults standardUserDefaults] objectForKey:str]boolValue];
    [self.likeBtn setImage:[UIImage imageNamed: @"like_clicked"] forState:UIControlStateSelected];
    
    if(isLike)
    {
        self.likeBtn.selected=YES;
        self.likeLable.text=[NSString stringWithFormat:@"%ld",self.model.like+1];
        
    }else
    {
        self.likeBtn.selected=NO;
        self.likeLable.text=[NSString stringWithFormat:@"%ld",model.like];
    }
    self.likeLable.text=[NSString stringWithFormat:@"%ld",model.like];
    self.commentLable.text=[NSString stringWithFormat:@"%ld",model.comment];
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
    NSString *str=[[NSString stringWithFormat:@"%@",self.model.id] stringByAppendingString:[NSString stringWithFormat:@"%@",self.model.authorId]];
    BOOL isLike=[[[NSUserDefaults standardUserDefaults] objectForKey:str]boolValue];
    if(isLike)
    {
        NSLog(@"已经点赞过了");
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:str];
    [[NSUserDefaults standardUserDefaults] synchronize];
    sender.selected=YES;
    self.likeLable.text=[NSString stringWithFormat:@"%ld",self.model.like+1];
    }

}
- (IBAction)commentClick:(UIButton *)sender {
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
