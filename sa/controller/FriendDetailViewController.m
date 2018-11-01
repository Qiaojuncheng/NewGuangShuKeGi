//
//  FriendDetailViewController.m
//  SanQiClound
//
//  Created by yu on 2017/11/8.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "DetailTableViewCell.h"
#import "friendDetailModel.h"
@interface FriendDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    UITableView *detailTable;
    CGRect contentHeight;
    NSString *pingLunNum;//评论数量
    NSString *dianZanNum;//点赞数量
    friendDetailModel *model;
    MWPhotoBrowser *photoBrower;
    NSArray *photoArr;
}

@end

@implementation FriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生活圈详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeAddDetailView];
    [self makeFriendDetail];
    
   
    // Do any additional setup after loading the view from its nib.
}

- (void)makeAddDetailView{
    detailTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)style:UITableViewStyleGrouped];
    detailTable.backgroundColor = [UIColor whiteColor];
    detailTable.separatorStyle = UITableViewCellSelectionStyleNone;
    detailTable.delegate = self;
    detailTable.dataSource = self;
    detailTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:detailTable];
}
#pragma mark  获取朋友圈内容
- (void)makeFriendDetail{
  
    NSArray *keysArray = @[@"id",@"cid"];
    NSArray *valuesArray = @[userIDStr,self.cid];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,friendDetail];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"获取朋友圈内容%@",data);
        NSString *code = [NSString stringWithFormat:@"%@",data[@"data"][@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:data[@"data"][@"obj"]];
            model = [friendDetailModel yy_modelWithJSON:dic];
            
        }
        [detailTable reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"获取朋友圈内容%@",error);
    }];
}

#pragma mark tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    HeaderView.backgroundColor = [UIColor whiteColor];
    UILabel *ContentLab = [[UILabel alloc]initWithFrame:CGRectMake(11, 10, ScreenWidth - 22, 0)];
    ContentLab.textColor = bleakColor;
    ContentLab.font = [UIFont systemFontOfSize:16];
    ContentLab.numberOfLines = 0;
    ContentLab.text = [NSString stringWithFormat:@"%@",model.content];
    ContentLab.text = [ContentLab.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    contentHeight = [ContentLab boundingRectWithInitSize:ContentLab.frame.size];
    ContentLab.frame = CGRectMake(11, 10, ScreenWidth - 22, contentHeight.size.height);
    [Utile addClickEvent:self action:@selector(didTitleString:) owner:ContentLab];
    [HeaderView addSubview:ContentLab];
    
    for (int a = 0; a < model.images.count; a ++ ) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10+ ((ScreenWidth - 30)/3 + 5)*(a%3), CGRectGetMaxY(ContentLab.frame) + 10 + ((ScreenWidth - 30)/3 + 5)*(a/3) , (ScreenWidth - 30)/3 , (ScreenWidth - 30)/3 )];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",requestUrl,model.images[a]]] placeholderImage:[UIImage imageNamed:@"朋友圈-img1"]];
        img.backgroundColor = [UIColor yellowColor];
        [HeaderView addSubview:img];
        img.tag = a;
        [Utile addClickEvent:self action:@selector(didImage:) owner:img];
    }
    return HeaderView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString *title = [NSString stringWithFormat:@"%@",model.content];
    CGFloat lableW = ScreenWidth - 20;
    CGFloat lableH = [Utile getStrSize:title andTexFont:[UIFont systemFontOfSize:14] andMaxSize:CGSizeMake(lableW, MAXFLOAT)].height;
    if (model.images.count%3 == 0) {
        return lableH  +(ScreenWidth - 30)/3 * (model.images.count/3) + 70;
    }else{
        return lableH  +(ScreenWidth - 30)/3 * ((model.images.count/3) + 1) + 70;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    DetailTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"DetailTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
    
        
    }
    cellTwo.model = model;
    cellTwo.zanTextFieldBlock = ^(NSString *zanString) {
        dianZanNum = zanString;
    };
    
    cellTwo.pingTextFieldBlock = ^(NSString *pingString) {
        pingLunNum = pingString;
    };
    
    [cellTwo.wanchengBtn addTarget:self action:@selector(didWanChengAnniu) forControlEvents:UIControlEventTouchUpInside];

    [cellTwo.tijiaoBtn addTarget:self action:@selector(didTiJiaoAnniu) forControlEvents:UIControlEventTouchUpInside];

    cellTwo.pingText.delegate = self;
    cellTwo.zanText.delegate = self;
    return cellTwo;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 图片点击方法
- (void)didImage:(UITapGestureRecognizer *)recognizr{
    
    photoArr = model.images;

    UIImageView *imgView = (UIImageView *)recognizr.view;
    photoBrower = [[MWPhotoBrowser alloc]initWithDelegate:self];
    photoBrower.hidesBottomBarWhenPushed = YES;
    photoBrower.displayActionButton = NO;
    photoBrower.displayNavArrows  = NO;
    photoBrower.displaySelectionButtons = NO;
    photoBrower.zoomPhotosToFill = NO;
    photoBrower.enableSwipeToDismiss = YES;
    [photoBrower setCurrentPhotoIndex:imgView.tag];
    [self.navigationController pushViewController:photoBrower animated:NO];
    
    
    NSLog(@"点击图片");
    
}
#pragma mark--MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return photoArr.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{

    NSString *imagePath = [NSString stringWithFormat:@"%@%@",requestUrl,photoArr[index]];
    MWPhoto *photot = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imagePath]]];
    
    return photot;
}
#pragma mark label上添加到手势 复制文字
- (void)didTitleString:(UITapGestureRecognizer *)gesture{
    
    UILabel *lab = (UILabel *)gesture.view;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = lab.text;
    //    pasteboard.string = friendArray[gesture.view.tag - 5][@"content"];
    NSLog(@"%@",pasteboard.string);
    if ([pasteboard.string isEqualToString:@""]) {
        
    }else{
        [self showHint:@"复制成功！"];
    }
    
}
#pragma mark 完成任务按钮
- (void)didWanChengAnniu{

    NSArray *keysArray = @[@"id",@"cid"];
    NSArray *valuesArray = @[userIDStr,self.cid];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,WanChengRenWu];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"完成任务%@",data);
        NSString *code = [NSString stringWithFormat:@"%@",data[@"data"][@"code"]];
        if ([code isEqualToString:@"1"]) {
            [self makeFriendDetail];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didRefreshFriendList" object:self];
            
            
            [self showHint:@"任务已完成！"];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"完成任务%@",error);
    }];
    
    
}
#pragma mark 提交按钮
- (void)didTiJiaoAnniu{
    NSLog(@"提交按钮");
    if ([Utile stringIsNilZero:pingLunNum]) {
        [self showHint:@"请输入评论数目！"];
        return;
    }
    
    if ([Utile stringIsNilZero:dianZanNum]) {
        [self showHint:@"请输入点赞数目！"];
        return;
    }
    
    NSArray *keysArray = @[@"id",@"cid",@"p_num",@"z_num"];
    NSArray *valuesArray = @[userIDStr,self.cid,pingLunNum,dianZanNum];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,TiJiaoPingLun];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"提交评论点赞数%@",data);
        NSString *code = [NSString stringWithFormat:@"%@",data[@"data"][@"code"]];
        if ([code isEqualToString:@"1"]) {
            
            [self makeFriendDetail];
            [self showHint:@"提交成功！"];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"提交评论点赞数%@",error);
    }];
    
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
