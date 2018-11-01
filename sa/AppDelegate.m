//
//  AppDelegate.m
//  sa
//
//  Created by yu on 2017/11/16.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "AppDelegate.h"
#import "SanqIViewController.h"
#import "BeginViewController.h"
#import "StartViewController.h"
#import <AddressBook/AddressBook.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //获取设备标识符
    NSString *dev = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [UD setObject:dev forKey:@"deviceID"];
    [UD synchronize];

    [self.window makeKeyAndVisible];
   
    BeginViewController *login = [[BeginViewController alloc]init];
    self.window.rootViewController = login;

    //请求通讯录权限
    [self requestAuthorizationAddressBook];
    
    return YES;
}

- (void)requestAuthorizationAddressBook {
    // 判断是否授权
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus == kABAuthorizationStatusNotDetermined) {
        // 请求授权
        ABAddressBookRef addressBookRef = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) { // 授权成功
                
            } else {  // 授权失败
                NSLog(@"授权失败！");
            }
        });
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
    
    [self makeShouQuan];
    
    NSLog(@"huoyue");
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

#pragma mark 判断是否向后台申请授权
- (void)makeShouQuan{
    
    NSArray *keysArray = @[@"imei"];
    NSArray *valuesArray = @[devicedID];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,ShiFouShouQuan];
    
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *status = [NSString stringWithFormat:@"%@",data[@"data"][@"status"]];
        if ([status isEqualToString:@"-1"]) {
            
            
        }else if ([status isEqualToString:@"-2"]){
//            self.shouquanBtn.backgroundColor = [UIColor lightGrayColor];
//            [self.shouquanBtn setTitle:@"正在审核" forState:normal];
//            self.shouquanBtn.userInteractionEnabled = NO;
            
        }else if ([status isEqualToString:@"-3"]){
            
        }else{
//            [UD setObject:status forKey:@"userID"];
//            [UD synchronize];
//
//            [[[UIApplication sharedApplication]delegate]window].rootViewController = [[SanqIViewController alloc]init];
            
            
            
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SHENHESTATUS" object:status];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
