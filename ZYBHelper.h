//
//  ZYBHelper.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/4.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYBHelper : NSObject
//把一个秒字符串 转化为真正的本地时间
//@"1419055200" -> 转化 日期字符串
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;
//根据字符串内容的多少  在固定宽度 下计算出实际的行高
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;
//获取 当前设备版本
+ (double)getCurrentIOS;
//获取 一个文件 在沙盒沙盒Library/Caches/ 目录下的路径
+ (NSString *)getFullPathWithFile:(NSString *)urlName;
//检测 缓存文件 是否超时
+ (BOOL)isTimeOutWithFile:(NSString *)filePath timeOut:(double)timeOut;

+(CGSize)downloadImageSizeWithURL:(id)imageURL;
+(CGSize)getImageSizeWithUrl:(NSString *)url;
@end
