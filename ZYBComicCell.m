//
//  ZTBComicCell.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/8.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBComicCell.h"
#import "UIImageView+WebCache.h"
#import "ZYBHelper.h"

@implementation ZYBComicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)showDataWithModel:(ZYBImageModel *)model withShareBlock:(ShareBlock)shareBlock withBlock:(likeBlock)block
{
    self.shareBlock=shareBlock;
    self.block=block;
    self.model=model;
    
    CGRect contentFrame=self.contetImageView.frame;
    //根据图片的实际大小  和显示  的宽等比例算出高度
    //h/w==h1/w1======>h*w1/
    contentFrame.size.height=model.middle_height.doubleValue*(kScreenSize.width-20)/model.middle_width.doubleValue;
    contentFrame.size.width=kScreenSize.width-20;
    contentFrame.origin.y=10;
    contentFrame.origin.x=10;

    //异步下载图片
    UIImage *image=[[UIImage imageNamed: @"card_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];//图片拉伸
    //做边第6像素 上边第6 像素拉伸 其他的不变
        [self.contetImageView sd_setImageWithURL:[NSURL URLWithString:model.middle_url] placeholderImage:image];
    self.contetImageView.frame=contentFrame;
    
    self.btnView.frame=contentFrame;
    CGRect btnViewFrame=self.btnView.frame;
    btnViewFrame.origin.y=CGRectGetMaxY(self.contetImageView.frame)+10;
    self.btnView.frame=btnViewFrame;
    //判断是否被点过
    NSString *str=[NSString stringWithFormat:@"%@",self.model.group_id];
    BOOL isLike=[[[NSUserDefaults standardUserDefaults] objectForKey:str]boolValue];
    [self.likeBtn setImage:[UIImage imageNamed: @"like_clicked"] forState:UIControlStateSelected];
    
    if(isLike)
    {
        self.likeBtn.selected=YES;
        self.likeCount.text=[NSString stringWithFormat:@"%ld",self.model.repin_count.integerValue+1];
        
    }else
    {
        self.likeBtn.selected=NO;
        self.likeCount.text=[NSString stringWithFormat:@"%@",model.repin_count];
    }

    self.commentCount.text=[NSString stringWithFormat:@"%@",model.comment_count];
}
- (IBAction)likeClick:(UIButton *)sender {
    NSUserDefaults *userInfo=[NSUserDefaults standardUserDefaults];
    if([userInfo objectForKey:@"uid"]==nil)
    {
        if(self.block)
        {
            self.block();
        }
    }else{

    //判断是否被点过
    //拼接key  段子id 和作者id 拼接一个key
    NSString *str=[NSString stringWithFormat:@"%@",self.model.group_id];
    BOOL isLike=[[[NSUserDefaults standardUserDefaults] objectForKey:str]boolValue];
    if(isLike)
    {
        NSLog(@"已经点赞过了");
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:str];
    [[NSUserDefaults standardUserDefaults] synchronize];
    sender.selected=YES;
    self.likeCount.text=[NSString stringWithFormat:@"%ld",self.model.repin_count.integerValue+1];
    
    }
}
- (IBAction)commentClick:(UIButton *)sender {
    
}
- (IBAction)shareClick:(UIButton *)sender {
    if(self.shareBlock)
    {
        self.shareBlock(self.model);
    }
}
@end
