//
//  ZYBImageCell.m
//  ZYBWaterFlow
//
//  Created by qianfeng001 on 15/8/12.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "ZYBImageCell.h"
#import "HMWaterflowView.h"
#import "ZYBHelper.h"
#import "UIImageView+WebCache.h"
@interface ZYBImageCell()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *textLable;
@property(nonatomic,strong)UIButton *likeBtn;
@property(nonatomic,strong)UIButton *shareBtn;
@property(nonatomic,strong)UILabel *likeCount;
//@property(nonatomic,strong)UIView *bgView;

@end
@implementation ZYBImageCell
+(instancetype)cellWithWaterflowView:(HMWaterflowView *)waterflowView
{
    static NSString *ID=@"imageCell";
    ZYBImageCell *cell=[waterflowView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil)
    {
        cell=[[ZYBImageCell alloc]init];
        cell.identifier=ID;
    }
    
    return cell;
}
-(void)showDataWithModel:(ZYBImageModel *)model withShareBlock:(ShareBlock)shareBlock withBlock:(likeBlock)likeBlock
{
    self.shareBlock=shareBlock;
    self.block=likeBlock;
    self.model=model;
    UIImage *image=[[UIImage imageNamed: @"loading_image"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];//图片拉伸
    //做边第6像素 上边第6 像素拉伸 其他的不变

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_url] placeholderImage:image];
    self.textLable.text=model.description;
    self.likeCount.text=[NSString stringWithFormat:@"%@",model.repin_count];
    
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=5;
        UIImageView *imageView=[[UIImageView alloc]init];
        [self addSubview:imageView];
        self.imageView=imageView;
        UILabel *label=[[UILabel alloc]init];
        label.numberOfLines=0;
        label.font=[UIFont systemFontOfSize:12];
        [self addSubview:label];
        self.textLable=label;
        
        UIButton *likeBut=[[UIButton alloc]init];
        [likeBut setImage:[UIImage imageNamed: @"like_normal_dark"] forState:UIControlStateNormal];
        [likeBut setImage:[UIImage imageNamed: @"like_clicked"] forState:UIControlStateSelected];
        [likeBut addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:likeBut];
        self.likeBtn=likeBut;
        UILabel *likeCount=[[UILabel alloc]init];
        likeCount.textColor=[UIColor grayColor];
        likeCount.font=[UIFont systemFontOfSize:12];
        [self addSubview:likeCount];
        self.likeCount=likeCount;
        
        UIButton *share=[[UIButton alloc]init];
        [share setImage:[UIImage imageNamed: @"share_icon_dark"] forState:UIControlStateNormal];
        [share addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:share];
         self.shareBtn=share;

           }
    return self;
}
-(void)likeClick:(UIButton *)btn{
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
    NSString *str=[[NSString stringWithFormat:@"%@",self.model.group_id] stringByAppendingString:[NSString stringWithFormat:@"%@",self.model.middle_url]];
    BOOL isLike=[[[NSUserDefaults standardUserDefaults] objectForKey:str]boolValue];
    if(isLike)
    {
        NSLog(@"已经点赞过了");
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:str];
    [[NSUserDefaults standardUserDefaults] synchronize];
    btn.selected=YES;
    self.likeCount.text=[NSString stringWithFormat:@"%ld",self.model.repin_count.integerValue+1];
    }

}
-(void)shareClick:(UIButton *)btn{
    
    if(self.shareBlock)
    {
        self.shareBlock(self.model);
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageView=self.imageView.frame;
    imageView.origin.x=10;
    imageView.origin.y=10;
    imageView.size.height=self.model.height;
    imageView.size.width=self.bounds.size.width-20;
    self.imageView.frame=imageView;
    CGRect textFrame=imageView;
     textFrame.origin.y=CGRectGetMaxY(self.imageView.frame)+5;
    if(self.model.description.length==0)
    {
        textFrame.size.height=0;
        self.model.description=nil;
    }else{
        textFrame.origin.x=10;
        textFrame.size.width=self.bounds.size.width-20;
        textFrame.size.height=[ZYBHelper textHeightFromTextString:self.model.description width:self.bounds.size.width-20 fontSize:12];
    }
    self.textLable.frame=textFrame;
    self.likeBtn.frame=textFrame;
    self.likeCount.frame=textFrame;
    self.shareBtn.frame=textFrame;
    CGRect likeBtnFrame=self.likeBtn.frame;
    CGRect likeCountFrame=self.likeCount.frame;
    CGRect shareBtnFrame=self.shareBtn.frame;
    CGFloat likeBtnY=CGRectGetMaxY(self.textLable.frame)+10;
    likeBtnFrame=CGRectMake(10, likeBtnY, 20, 20);
    self.likeBtn.frame=likeBtnFrame;
    CGFloat likeCountX=CGRectGetMaxX(self.likeBtn.frame)+10;
    likeCountFrame=CGRectMake(likeCountX, likeBtnY, 80, 20);
    self.likeCount.frame=likeCountFrame;
    CGFloat shareX=self.bounds.size.width-40;
    shareBtnFrame=CGRectMake(shareX, likeBtnY, 20, 20);
    self.shareBtn.frame=shareBtnFrame;
    
    
    
}










@end
