//
//  HearderView.h
//  SanQiClound
//
//  Created by yu on 2017/11/9.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HearderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tongCountLab;//通讯录现有人数

@property (weak, nonatomic) IBOutlet UILabel *gengxinLab;//跟新通讯录条数
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;//刷新按钮
@property (weak, nonatomic) IBOutlet UIButton *xiazaiBtn;//下载按钮
@property (weak, nonatomic) IBOutlet UILabel *fuquqiBtn;



@end
