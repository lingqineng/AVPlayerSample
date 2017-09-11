//
//  AppDelegate.m
//  PlayerSample
//
//  Created by lingqineng on 2017/9/6.
//  Copyright © 2017年 lingqineng. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.playVC = [[PlayViewController alloc]init];
    self.window.rootViewController = self.playVC;
    //开启远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    return YES;
}
/**
 *  接受远程播放事件
 *
 *  @param receivedEvent UIevent 枚举播放、暂停、上一首、下一首的事件
 */
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"远程播放");
                if ([self.playVCDelegate respondsToSelector:@selector(clickPlayBtn)]) {
                    [self.playVCDelegate clickPlayBtn];
                }
                break;
                
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"远程暂停");
                if ([self.playVCDelegate respondsToSelector:@selector(clickPlayBtn)]) {
                    [self.playVCDelegate clickPlayBtn];
                }
                
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"远程下一首");
                if ([self.playVCDelegate respondsToSelector:@selector(playNextMusic)]) {
                    [self.playVCDelegate playNextMusic];
                }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"远程上一首");
                if ([self.playVCDelegate respondsToSelector:@selector(playPreviousMusic)]) {
                    [self.playVCDelegate playPreviousMusic];
                }
                break;
            default:
                break;
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
