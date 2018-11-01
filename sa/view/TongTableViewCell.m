//
//  TongTableViewCell.m
//  SanQiClound
//
//  Created by yu on 2017/11/9.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "TongTableViewCell.h"

@implementation TongTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(XiaZaiListModel *)model{
    self.timeLab.text = [NSString stringWithFormat:@"%@",model.add_time,model.num];
    self.gengxinLab.text = [NSString stringWithFormat:@"更新%@条通讯录数据",model.num];
    [Utile setUILabel:self.gengxinLab data:@"更新" setData:[NSString stringWithFormat:@"%@",model.num] color:redColor font:14 underLine:NO];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
