//
//  SanqIViewController.m
//  SanQiClound
//
//  Created by yu on 2017/11/8.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "SanqIViewController.h"
#import "FriendViewController.h"
#import "TongXunViewController.h"
#import "SanQiNavigationViewController.h"
@interface SanqIViewController ()<UITabBarDelegate>

@end

@implementation SanqIViewController
+(void)initialize
{
    UITabBar *tabbar = [UITabBar appearance];
    tabbar.barTintColor = lightBlueColor;
    CGFloat width = ScreenWidth / 2;
    CGFloat height = 49;
    if (kDevice_Is_iPhoneX) {
        height = 83;
    }else{
        height = 49;
    }
    UIImage *imgOne = [UIImage imageNamed:@"blueOne"];//点击
    UIImage *imgTwo = [UIImage imageNamed:@"bluetwo"];//没有点击
    
    UIImage *selectImg = [Utile resizeImage:imgOne rect:CGRectMake(0, 0, width, height)];
    
    UIImage *normalImg = [Utile resizeImage:imgTwo rect:CGRectMake(0, 0, width, height)];

   // [[UITabBar appearance]setBackgroundImage:normalImg];
    [[UITabBar appearance]setSelectionIndicatorImage:selectImg];
    
    
    

   // tabbar.selectionIndicatorImage =[Utile drawTabbarItemBackGroundImageWithSIze:indicatorImageSize];
    
    
    
    
    UITabBarItem *item = [UITabBarItem appearance];
    //设置选中后的字体颜色
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    UIColor *titleHighlightedColor = [UIColor whiteColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleHighlightedColor, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = 0;
    [self addController];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)addController{
    TongXunViewController *tong = [[TongXunViewController alloc]init];
    [self  addchildVC:tong andTitle:@"通讯录" andImage:@"首页-icon1" andSelectedImg:@"首页-icon1"];
    
    FriendViewController *friend = [[FriendViewController alloc]init];
    [self  addchildVC:friend andTitle:@"生活圈" andImage:@"首页-icon2w" andSelectedImg:@"首页-icon2w"];
    
    
}
- (void)addchildVC:(UIViewController *)childVC andTitle:(NSString *)title andImage:(NSString *)image andSelectedImg:(NSString *)selectedImage{
    childVC.title = title;
    childVC.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    
    SanQiNavigationViewController *yz = [[SanQiNavigationViewController alloc]initWithRootViewController:childVC];
    [self addChildViewController:yz];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
