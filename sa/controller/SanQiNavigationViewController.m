//
//  SanQiNavigationViewController.m
//  SanQiClound
//
//  Created by yu on 2017/11/8.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "SanQiNavigationViewController.h"

@interface SanQiNavigationViewController ()

@end

@implementation SanQiNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor whiteColor];

    bar.tintColor = [UIColor blackColor];
    
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    // Do any additional setup after loading the view from its nib.
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
