//
//  FriendVideoViewController.m
//  SanQiClound
//
//  Created by yu on 2017/11/16.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "FriendVideoViewController.h"
#import "DetailTableViewCell.h"
#import "friendDetailModel.h"
#import "AFNetworking.h"
@interface FriendVideoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>{
    UITableView *detailTable;
    CGRect contentHeight;
    NSString *pingStr;//评论数量
    NSString *zanStr;//点赞数目
    friendDetailModel *model;
    MPMoviePlayerViewController *moviePlayerController;//视频播放页面
    
    NSString *urlString;
    NSString *veidoPath;
    NSString *veidoName;
    NSString *videoPaths;
    
    NSString *cachePath;
}
@property (nonatomic,strong)NSString *pathUrl;
@end

@implementation FriendVideoViewController

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
            model = [friendDetailModel yy_modelWithJSON:data[@"data"][@"obj"]];
            self.pathUrl = [NSString stringWithFormat:@"%@",model.move];
        }else{
            
        }
        [self hideHud];
        [detailTable reloadData];
    } failure:^(NSError *error) {
        NSLog(@"获取朋友圈内容%@",error);
        
    }];
}
#pragma mark tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
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
    
    
    UIImageView *videoImg = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 178, CGRectGetMaxY(ContentLab.frame)+ 10, 356, 208)];
    videoImg.layer.masksToBounds = YES;
    videoImg.layer.cornerRadius = 5;
    UIImage *img = [Utile imageWithMediaURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",requestUrl,model.move]]];
    videoImg.image = img;
    HeaderView.frame = CGRectMake(0, 0, ScreenWidth, contentHeight.size.height  +208 + 20);
    [HeaderView addSubview:videoImg];
    
    [Utile addClickEvent:self action:@selector(didVideo:) owner:videoImg];
    
    UIImageView *videoPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(356/2 - 25, 208/2 - 25, 50, 50)];
    videoPhoto.image = [UIImage imageNamed:@"详情-视频"];
    [videoImg addSubview:videoPhoto];
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
    return lableH  +208 + 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    DetailTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"DetailTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cellTwo.model = model;
    cellTwo.backgroundColor = [UIColor whiteColor];
    cellTwo.pingTextFieldBlock = ^(NSString *pingString) {
        pingStr = pingString;
    };
    
    cellTwo.zanTextFieldBlock = ^(NSString *zanString) {
        zanStr = zanString;
    };
    
    [cellTwo.tijiaoBtn addTarget:self action:@selector(didTiJiaoBtn) forControlEvents:UIControlEventTouchUpInside];
    [cellTwo.wanchengBtn addTarget:self action:@selector(didWanChengBtn) forControlEvents:UIControlEventTouchUpInside];
    
    cellTwo.pingText.delegate = self;
    cellTwo.zanText.delegate = self;
    return cellTwo;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark label上添加到手势 复制文字
- (void)didTitleString:(UITapGestureRecognizer *)gesture{
    
    UILabel *lab = (UILabel *)gesture.view;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = lab.text;

    NSLog(@"%@",pasteboard.string);
    if ([pasteboard.string isEqualToString:@""]) {
    }else{
        [self showHint:@"复制成功！"];
    }
    
}
#pragma mark 完成任务
- (void)didWanChengBtn{

    NSArray *keysArray = @[@"id",@"cid"];
    NSArray *valuesArray = @[userIDStr,self.cid];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,WanChengRenWu];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"完成任务%@",data);
        NSString *code = [NSString stringWithFormat:@"%@",data[@"data"][@"code"]];
        if ([code isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didRefreshFriendList" object:self];
            [self makeFriendDetail];
            [self showHint:@"任务已完成！" inView:self.view];
        }else{
            
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"完成任务%@",error);
    }];
}
#pragma mark 提交按钮
- (void)didTiJiaoBtn{
    NSLog(@"提交按钮");
    if ([Utile stringIsNilZero:pingStr]) {
        [self showHint:@"请输入评论数目！"];
        return;
    }
    
    if ([Utile stringIsNilZero:zanStr]) {
        [self showHint:@"请输入点赞数目！"];
        return;
    }
    
    NSArray *keysArray = @[@"id",@"cid",@"p_num",@"z_num"];
    NSArray *valuesArray = @[userIDStr,self.cid,pingStr,zanStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,TiJiaoPingLun];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"提交评论点赞数%@",data);
        NSString *code = [NSString stringWithFormat:@"%@",data[@"data"][@"code"]];
        if ([code isEqualToString:@"1"]) {
            [self makeFriendDetail];
        }else{
            
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"提交评论点赞数%@",error);
    }];
    
}
#pragma mark 点击视屏
- (void)didVideo:(UITapGestureRecognizer *)recognizr{
    NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",requestUrl,model.move]];
    moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    moviePlayerController.hidesBottomBarWhenPushed = YES;
    [moviePlayerController.moviePlayer prepareToPlay];
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveVideo:)];
    [moviePlayerController.view addGestureRecognizer:recognizer];
    [self presentViewController:moviePlayerController animated:NO completion:nil];
}

#pragma mark--保存视频到本地
-(void)saveVideo:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按以保存视频");
//        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存视频到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            [self makeDownload];
//
//        }];
//        UIAlertAction *cancalAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//        [actionSheet addAction:saveAction];
//        [actionSheet addAction:cancalAction];
//        [moviePlayerController presentViewController:actionSheet animated:NO completion:^{
//
//        }];
       
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"保存视频到相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alertView.alertViewStyle = UIAlertViewStyleDefault;
        [alertView show];
        
        
    }else{
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
      NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if ([btnTitle isEqualToString:@"取消"]) {
            
        }else if ([btnTitle isEqualToString:@"确定"] ) {
            [self makeDownload];

        }
 }

#pragma mark  文件下载
- (void)makeDownload{

    //保存至沙盒路径

    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    videoPaths = [NSString stringWithFormat:@"%@/%@.mp4",filePath,model.title];
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    //文件已存在
    if ([fileManager fileExistsAtPath:videoPaths]) {
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPaths]
                                    completionBlock:^(NSURL *assetURL, NSError *error) {
                                        if (error) {
                                            
                                            NSLog(@"Save video fail:%@",error);
                                        } else {
                                            [self showHint:@"下载完成！"];
                                            NSLog(@"Save video succeed.");
                                            
                                            // 清除沙盒中的内容，减少内存
                                            NSFileManager *fileManager = [NSFileManager defaultManager];
                                            [fileManager removeItemAtPath:videoPaths error:nil];
                                            
                                        }
                                    }];
        
     
     //   文件不存在  重新下载
    }else{
        
        //1.创建管理者对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //2.确定请求的URL地址
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",requestUrl,model.move]];
        
        //3.创建请求对象
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //下载任务
        NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//            //打印下下载进度
//            WKNSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            //下载地址
            NSLog(@"默认下载地址:%@",targetPath);
            
            //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
            NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
            videoPaths = [NSString stringWithFormat:@"%@/%@.mp4",filePath,model.title];
            
            
            
            return [NSURL fileURLWithPath:videoPaths];
            
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            //下载完成调用的方法
            NSLog(@"下载完成：");
            NSLog(@"%@--%@",response,filePath);
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeVideoAtPathToSavedPhotosAlbum:filePath
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                            if (error) {
                                                
                                                NSLog(@"Save video fail:%@",error);
                                            } else {
                                                [self showHint:@"下载完成！"];
                                                NSLog(@"Save video succeed.");
                                                
                                                // 清除沙盒中的内容，减少内存
                                                NSFileManager *fileManager = [NSFileManager defaultManager];
                                                [fileManager removeItemAtPath:videoPaths error:nil];
                                                
                                            }
                                        }];
            
            
        }];
        
        //开始启动任务
        [task resume];

    }

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
