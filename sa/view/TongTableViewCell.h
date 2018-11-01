//
//  TongTableViewCell.h
//  SanQiClound
//
//  Created by yu on 2017/11/9.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XiaZaiListModel.h"
@interface TongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gengxinLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (nonatomic,strong)XiaZaiListModel *model;
- (void)setModel:(XiaZaiListModel *)model;
@end
