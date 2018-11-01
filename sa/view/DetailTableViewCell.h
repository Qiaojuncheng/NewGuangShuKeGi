//
//  DetailTableViewCell.h
//  SanQiClound
//
//  Created by yu on 2017/11/8.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "friendDetailModel.h"
@interface DetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *wanchengBtn;
@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;
@property (weak, nonatomic) IBOutlet UITextField *pingText;
@property (weak, nonatomic) IBOutlet UITextField *zanText;
@property (copy,nonatomic)void (^pingTextFieldBlock)(NSString *pingString);
@property (copy,nonatomic)void (^zanTextFieldBlock)(NSString *zanString);
@property (nonatomic,strong)friendDetailModel *model;
- (void)setModel:(friendDetailModel *)model;
@end
