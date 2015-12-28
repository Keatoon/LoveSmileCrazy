//
//  AppDelegate.m
//  LoveSmileCrazy
//
//  Created by qianfeng001 on 15/8/1.
//  Copyright (c) 2015年 fq. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYBNavgationViewController.h"
#import "UMSocialData.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

#import "UMSocialConfig.h"
#import "UMSocial.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)initUI{
    [UMSocialData setAppKey:@"55c71eabe0f55a757c009208"];
    
    [UMSocialQQHandler setQQWithAppId:@"1104808732" appKey:@"olyOX3LSQuTkf2ZK" url:@"http://www.baidu.com"];
    [UMSocialWechatHandler setWXAppId:@"wx0276d31730b7e2f9" appSecret:@"5d4c446f125a252de77239c49a70e105" url:@"http://www.baidu.com"];

    
    }

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    [self initUI];
    self.window.rootViewController=[[ZYBNavgationViewController alloc]init];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
