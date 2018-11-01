//
//  FriendTableViewCell.m
//  SanQiClound
//
//  Created by yu on 2017/11/8.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redHiddenImg.layer.masksToBounds = YES;
    self.redHiddenImg.layer.cornerRadius = 3;
    // Initialization code
}
- (void)setModel:(friendListModel *)model{
    self.nameLab.text = [NSString stringWithFormat:@"%@",model.title];
    self.contentLab.text = [NSString stringWithFormat:@"%@",model.content];
    self.timeLab.text = [NSString stringWithFormat:@"%@",model.add_time];
    
    if ([model.see isEqualToString:@"1"]) {
        self.redHiddenImg.hidden = YES;
    }else{
        self.redHiddenImg.hidden = NO;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
