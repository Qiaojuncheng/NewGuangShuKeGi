//
//  BeginViewController.m
//  SanQiClound
//
//  Created by yu on 2017/11/8.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "BeginViewController.h"
#import "SanqIViewController.h"
@interface BeginViewController ()

@end

@implementation BeginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouquanBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];

    self.shouquanBtn.layer.masksToBounds = YES;
    self.shouquanBtn.layer.cornerRadius = 8;
    self.shebeiLab.text = [NSString stringWithFormat:@"我的手机ID\n%@",DeviceID];
//    [self makeShouQuan];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouquan:) name:@"SHENHESTATUS" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)shouquan:(NSNotification *)center{
    
    NSString *status = [NSString stringWithFormat:@"%@",center.object];
    if ([status isEqualToString:@"-1"]) {
        
        
    }else if ([status isEqualToString:@"-2"]){
        
        self.shouquanBtn.backgroundColor = [UIColor lightGrayColor];
        [self.shouquanBtn setTitle:@"正在审核" forState:normal];
        self.shouquanBtn.userInteractionEnabled = NO;
        
    }else if ([status isEqualToString:@"-3"]){
        
    }else{
        [UD setObject:status forKey:@"userID"];
        [UD synchronize];
        
        [[[UIApplication sharedApplication]delegate]window].rootViewController = [[SanqIViewController alloc]init];
        
        
        
    }
    
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
            
            self.shouquanBtn.backgroundColor = [UIColor lightGrayColor];
            [self.shouquanBtn setTitle:@"正在审核" forState:normal];
            self.shouquanBtn.userInteractionEnabled = NO;
            
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

- (IBAction)didShouQuanButton:(id)sender {
    
    NSArray *keysArray = @[@"type",@"imei"];
    NSArray *valuesArray = @[@"1",devicedID];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,ShengQingShouQuan];
    [self showHudInView:self.view hint:nil];
    
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        [self hideHud];
        NSLog(@"申请授权%@",data);
        NSString *status = [NSString stringWithFormat:@"%@",data[@"data"][@"status"]];
        if ([status isEqualToString:@"-1"]) {
            //未申请未授权
            
        }else if ([status isEqualToString:@"-2"]){
            //已申请未授权
            self.shouquanBtn.backgroundColor = [UIColor lightGrayColor];
            [self.shouquanBtn setTitle:@"正在审核" forState:normal];
            self.shouquanBtn.userInteractionEnabled = NO;
            [self showHint:@"后台正在审核！"];
        }else if ([status isEqualToString:@"-3"]){
            
        }else{
            //已申请已授权
            [UD setObject:status forKey:@"userID"];
            [UD synchronize];
            
            [[[UIApplication sharedApplication]delegate]window].rootViewController = [[SanqIViewController alloc]init];
            
            
            
        }
        
        
        
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"申请授权%@",error);
    }];
    
    
}
@end
