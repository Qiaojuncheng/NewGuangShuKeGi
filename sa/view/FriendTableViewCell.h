//
//  FriendTableViewCell.h
//  SanQiClound
//
//  Created by yu on 2017/11/8.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "friendListModel.h"
@interface FriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *redHiddenImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic,strong)friendListModel *model;
- (void)setModel:(friendListModel *)model;
@end
