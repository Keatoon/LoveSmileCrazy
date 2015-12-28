//
//  ZYBCommentViewCell.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/5.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBCommentViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZYBHelper.h"
@implementation ZYBCommentViewCell

- (void)awakeFromNib {
    self.userIconImage.layer.masksToBounds=YES;
    self.userIconImage.layer.cornerRadius=self.userIconImage.frame.size.width/2;
}

-(void)showDataWithModel:(ZYBCommentModel *)model withIndext:(NSInteger)indext
{
    [self.userIconImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed: @"default_user_head"]];
    
    self.userNameLable.text=[NSString stringWithFormat:@"%ld楼:%@",indext,model.name];
    self.textLable.text=[NSString stringWithFormat:@"%@",model.content];
    self.textLabel.frame=self.userNameLable.frame;
    CGRect textFram=self.textLabel.frame;
    
    textFram.size.height=[ZYBHelper textHeightFromTextString:model.content width:kScreenSize.width-80 fontSize:16];
    textFram.origin.y=CGRectGetMaxY(self.userNameLable.frame)+5;
    textFram.origin.x=self.userNameLable.frame.origin.x;
    self.textLabel.frame=textFram;
    CGRect bgViewFrame=self.bgView.frame;
    bgViewFrame.size.height=textFram.size.height+50;
    self.bgView.frame=bgViewFrame;


}
-(void)showDataWithImageCommentModel:(ZYBImageCommentModel *)model withIndext:(NSInteger)indext
{
    [self.userIconImage sd_setImageWithURL:[NSURL URLWithString:model.user_profile_image_url] placeholderImage:[UIImage imageNamed: @"default_user_head"]];
    
    self.userNameLable.text=[NSString stringWithFormat:@"%ld楼:%@",indext,model.user_name];
    self.textLable.text=[NSString stringWithFormat:@"%@",model.text];
    self.textLabel.frame=self.userNameLable.frame;
    CGRect textFram=self.textLabel.frame;
    
    textFram.size.height=[ZYBHelper textHeightFromTextString:model.text width:kScreenSize.width-80 fontSize:16];
    textFram.origin.y=CGRectGetMaxY(self.userNameLable.frame)+5;
    textFram.origin.x=self.userNameLable.frame.origin.x;
    self.textLabel.frame=textFram;
    CGRect bgViewFrame=self.bgView.frame;
    bgViewFrame.size.height=textFram.size.height+50;
    self.bgView.frame=bgViewFrame;
    


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
