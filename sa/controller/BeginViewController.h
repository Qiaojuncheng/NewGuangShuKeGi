//
//  BeginViewController.h
//  SanQiClound
//
//  Created by yu on 2017/11/8.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *shouquanBtn;
- (IBAction)didShouQuanButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *shebeiLab;

@end
