//
//  DetailTableViewCell.m
//  SanQiClound
//
//  Created by yu on 2017/11/8.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "DetailTableViewCell.h"


@interface DetailTableViewCell ()<UITextFieldDelegate>
@end

@implementation DetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.wanchengBtn.layer.masksToBounds = YES;
    self.wanchengBtn.layer.cornerRadius = 8;
    self.tijiaoBtn.layer.masksToBounds = YES;
    self.tijiaoBtn.layer.cornerRadius = 8;
    
    self.zanText.delegate = self;
    self.pingText.delegate = self;
    // Initialization code
}

- (void)setModel:(friendDetailModel *)model{
    if ([model.see isEqualToString:@"1"]) {
        self.wanchengBtn.backgroundColor = [UIColor lightGrayColor];
        self.wanchengBtn.userInteractionEnabled = NO;

    }else{
        self.wanchengBtn.backgroundColor = BlueColor;
        self.wanchengBtn.userInteractionEnabled = YES;
        
        self.zanText.userInteractionEnabled = YES;
        self.pingText.userInteractionEnabled = YES;

    }

    if ([model.hadSubmit isEqualToString:@"1"]) {
        self.tijiaoBtn.backgroundColor = [UIColor lightGrayColor];
        self.tijiaoBtn.userInteractionEnabled = NO;
        
        self.zanText.userInteractionEnabled = NO;
        self.pingText.userInteractionEnabled = NO;
        self.zanText.text = model.z_num;
        self.pingText.text = model.p_num;
        
    }else{
        self.tijiaoBtn.backgroundColor = BlueColor;
        self.tijiaoBtn.userInteractionEnabled = YES;
        self.zanText.userInteractionEnabled = YES;
        self.pingText.userInteractionEnabled = YES;
    }
    
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _pingText) {
        if (self.pingTextFieldBlock) {
            self.pingTextFieldBlock(textField.text);
        }
    }else{
        if (self.zanTextFieldBlock) {
            self.zanTextFieldBlock(textField.text);
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
