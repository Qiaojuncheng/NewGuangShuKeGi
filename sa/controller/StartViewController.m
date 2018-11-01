//
//  StartViewController.m
//  sa
//
//  Created by yu on 2017/11/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "StartViewController.h"
#import "BeginViewController.h"
#import "SanqIViewController.h"
@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    img.image = [UIImage imageNamed:@"750"];
    [self.view addSubview:img];
    [self makeShouQuan];
    // Do any additional setup after loading the view from its nib.
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
            [UD setObject:@"-1" forKey:@"statusStr"];
            [UD synchronize];
            
            [[[UIApplication sharedApplication]delegate]window].rootViewController = [[BeginViewController alloc]init];
            
        }else if ([status isEqualToString:@"-2"]){

            [UD setObject:@"-2" forKey:@"statusStr"];
            [UD synchronize];
            
            [[[UIApplication sharedApplication]delegate]window].rootViewController = [[BeginViewController alloc]init];
            
        }else if ([status isEqualToString:@"-3"]){
            
        }else{
            [UD setObject:status forKey:@"userID"];
            [UD synchronize];
            
            [[[UIApplication sharedApplication]delegate]window].rootViewController = [[SanqIViewController alloc]init];
            
            
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
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
