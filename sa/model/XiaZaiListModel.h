//
//  XiaZaiListModel.h
//  sa
//
//  Created by yu on 2017/11/22.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiaZaiListModel : NSObject
/*
    "add_time" = "2017-11-22 14:18:59";
    date = 20171122;
    group = 0;
    id = 197138;
    num = 300;
    type = 1;
    uid = 7610;
    uname = "W12-24";
*/
@property (nonatomic,strong)NSString *add_time;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSString *group;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *num;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *uname;
@end
