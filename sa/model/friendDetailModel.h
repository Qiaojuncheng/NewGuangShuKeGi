//
//  friendDetailModel.h
//  sa
//
//  Created by yu on 2017/11/22.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface friendDetailModel : NSObject
/*
    "add_time" = "2017-10-26 08:32:44";
    brief = "\U60ca\U95fb\U4e0a\U6d77";
    content = "\U60ca\U95fb\U4e0a\U6d77\U963f\U59e8\U627e\U5973\U5a7f\U7684\U6807\U51c6\Uff0c\U6211\U771f\U662f\U5413\U5f97\U4e00\U53e3\U6c34\U55b7\U5728\U4e86\U5c4f\U5e55\U4e0a\Uff0c\U4f60\U4eec\U600e\U4e48\U770b\Uff1f[\U6342\U8138]";
    "fabu_time" = "2017-10-27 08:32:00";
    group = 0;
    id = 15541;
    images =             (
                          "/data/upload/59f12d280b71b.jpg"
                          );
    "img_con" = 1;
    move = "<null>";
    "move_type" = "<null>";
    num = 0;
    "p_num" = 0;
    status = "<null>";
    title = "\U7b2c\U516d\U6761";
    type = 1;
    uid = 0;
    "z_num" = 0;
*/
@property (nonatomic,strong)NSString *add_time;
@property (nonatomic,strong)NSString *brief;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *fabu_time;
@property (nonatomic,strong)NSString *group;
@property (nonatomic,strong)NSString *hadSubmit;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSString *img_con;
@property (nonatomic,strong)NSString *move;
@property (nonatomic,strong)NSString *move_type;
@property (nonatomic,strong)NSString *num;
@property (nonatomic,strong)NSString *p_num;
@property (nonatomic,strong)NSString *see;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *z_num;
@end
