//
//  Define.h
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/1.
//  Copyright (c) 2015年 ZYBin. All rights reserved.
//

#ifndef LoveSmileCrazy_Define_h
#define LoveSmileCrazy_Define_h



#define kScreenSize [UIScreen mainScreen].bounds.size

#define APPKEY @"55c71eabe0f55a757c009208"

//段子界面接口

#define zJokesUrl @"http://jianstory.com/rest/images/new?page=%ld&type=2"


//段子评论接口
#define zJokesCommentsUrl @"http://jianstory.com/rest/stories/%ld/comments?page=%ld"

//神图 接口

#define zGodImageUrl @"http://jianstory.com/rest/images/new?page=%ld&type=4&type=3&like_count=7"




//漫画接口

#define zComicUrl @"http://ic.snssdk.com/2/image/recent/?tag=comic&count=%ld"
#define zComiclodmoreUrl @"http://ic.snssdk.com/2/image/recent/?tag=comic&max_behot_time=%@&count=%ld"
//漫画详情
#define zComicDetailUrl @"http://isub.snssdk.com/2/data/v4/get_comments/?group_id=%@&count=%ld&offset=%ld"



//狂笑接口
#define zSmileUrl @"http://ic.snssdk.com/2/image/recent/?tag=heavy&count=%ld"
#define zSmileMoreUrl @"http://ic.snssdk.com/2/image/recent/?tag=heavy&max_behot_time=%@&count=%ld"

//萌图接口
#define zMengUrl @"http://ic.snssdk.com/2/image/recent/?tag=meng&count=%ld"
#define zMengMoreUrl @"http://ic.snssdk.com/2/image/recent/?tag=meng&max_behot_time=%@&count=%ld"


#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#endif
