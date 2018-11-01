//
//  TongXunViewController.m
//  SanQiClound
//
//  Created by yu on 2017/11/8.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "TongXunViewController.h"
#import "HearderView.h"
#import "TongTableViewCell.h"
#import "XiaZaiListModel.h"

static int telCount = 0;
@interface TongXunViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tongTableview;
    HearderView *hear;
    NSString *x_conStr;//可下载条数
    NSString *g_conStr;//最新更新数
    NSString *z_conStr;//总条数
    BOOL isOK;//是否可以下载
    NSMutableArray *downloadArr;//通讯录
    NSMutableArray *xiazaiArr;//下载记录
    int downLoadCount;
    ABAddressBookRef iPhoneAddressBook;
    NSMutableArray *downLoadArry;
    
    BOOL isSucceed;
}
@property(nonatomic,strong)  NSTimer *timer;
@property(nonatomic,strong) CircularProgressView*CircleP;
@end

@implementation TongXunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"广晟科技";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //取得通讯录中联系人的所有属性
    iPhoneAddressBook = ABAddressBookCreate();
    
    ABAddressBookRequestAccessWithCompletion(iPhoneAddressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            //显示提示
        }
    });
    
    
    downloadArr = [NSMutableArray array];
    downLoadArry = [NSMutableArray array];
    xiazaiArr = [NSMutableArray array];
    [self makeAddTableview];
    [self touchesBegan];
    [self makeXiazai];
    [self makeShangChuanList];
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesBegan{
    // 1. 判读授权
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus != kABAuthorizationStatusAuthorized) {
        
        NSLog(@"没有授权");
        return;
    }
    
    // 2. 获取所有联系人
    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    long count = CFArrayGetCount(arrayRef);
    hear.tongCountLab.text = [NSString stringWithFormat:@"手机通讯录现有%ld人",count];
    
}
#pragma mark  获取可下载条数
- (void)makeXiazai{
    
    NSArray *keysArray = @[@"id"];
    NSArray *valuesArray = @[userIDStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,downloadNum];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        [self hideHud];
        NSLog(@"获取可下载条数%@",data);
        NSString *code = [NSString stringWithFormat:@"%@",data[@"data"][@"code"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:data[@"data"][@"obj"]];
            g_conStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"g_con"]];
            x_conStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"x_con"]];
            z_conStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"z_con"]];
            hear.gengxinLab.text = [NSString stringWithFormat:@"服务器更新%@条通讯录",x_conStr];
            NSString *isokStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isok"]];
            if ([isokStr isEqualToString:@"1"]) {
                isOK = YES;
            }else{
                isOK = NO;
            }
            
            if (isOK) {
                [hear.xiazaiBtn setTitle:@"一键下载" forState:normal];
                hear.xiazaiBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
                hear.xiazaiBtn.enabled = YES;
                downLoadCount = 0;
                self.CircleP.progressValue = 0;
                telCount = (int)downLoadArry.count;
                
            }else{
                [hear.xiazaiBtn setTitle:@"一键下载" forState:normal];
                hear.xiazaiBtn.enabled = NO;
                hear.xiazaiBtn.backgroundColor = [UIColor lightGrayColor];
            }
            
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"获取可下载条数%@",error);
    }];
}

#pragma mark  获取上传记录
- (void)makeShangChuanList{
    [xiazaiArr removeAllObjects];
    NSArray *keysArray = @[@"id"];
    NSArray *valuesArray = @[userIDStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,ShangChuanJiLu];

    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"获取上传记录%@",data);
        
        NSArray *array = [NSArray arrayWithArray:data[@"data"]];
        for (NSDictionary *dics in array) {
            XiaZaiListModel *model = [XiaZaiListModel yy_modelWithJSON:dics];
            [xiazaiArr addObject:model];
        }
        [tongTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"获取上传记录%@",error);
    }];
}

#pragma mark 下载手机号
- (void)makeDownloadPhone{
    
    [hear.xiazaiBtn setTitle:@"正在下载" forState:normal];
    hear.xiazaiBtn.enabled = NO;
    hear.xiazaiBtn.backgroundColor = [UIColor lightGrayColor];
    
    hear.refreshBtn.enabled = NO;

    [downLoadArry removeAllObjects];
    NSArray *keysArray = @[@"id",@"num"];
    NSArray *valuesArray = @[userIDStr,x_conStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,downloadPhone];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"下载手机号%@",data);
        
        [self hideHud];
        NSString *code = [NSString stringWithFormat:@"%@",data[@"data"][@"code"]];
        if ([code isEqualToString:@"1"]) {
            
            
            NSArray *array = [NSArray arrayWithArray:data[@"data"][@"obj"]];
           // [downloadArr addObject:array];
            for (int i = 0; i < array.count; i ++ ) {
                NSDictionary *dics = array[i];
                NSMutableDictionary *person = [[NSMutableDictionary alloc]init];
                [person setValue:dics[@"name"] forKey:@"name"];
                [person setValue:dics[@"phone"] forKey:@"phone"];
                [downLoadArry addObject:person];
            }
            self.CircleP.progressValue = 0;
            telCount = (int)downLoadArry.count;

            self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(storageTel:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [self.timer fire];
 
        }
        
    } failure:^(NSError *error) {
        
        [self hideHud];
        NSLog(@"下载手机号%@",error);
    }];
}

-(void)storageTel:(NSTimer *)timer
{
    
    
    
    
    
    [self addperson];
    downLoadCount ++;
    
    self.CircleP.progressValue =  downLoadCount*((100.00/telCount)/100.00);
 
    if (downLoadCount == telCount) {
        self.CircleP.progressValue = 1.0;
        [timer invalidate];
        timer = nil;
        telCount = 0;
        [self makeShangChuanList];
        [self touchesBegan];
        [self showHint:@"同步完成"];
        [self hideHud];
        
        [hear.xiazaiBtn setTitle:@"下载完成" forState:normal];
        hear.xiazaiBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        hear.xiazaiBtn.enabled = NO;
        
        hear.refreshBtn.enabled = YES;
        
        [self showHint:@"下载完成，请刷新之后再下载！"];
        
    }
    

}
#pragma mark 同步通讯录
-(void)addperson{
    NSDictionary *person = downLoadArry[downLoadCount];
    [self getTongXunLu:person];
    
}

- (void)getTongXunLu:(NSDictionary *)Contact{
    ABRecordRef newPerson = ABPersonCreate();
    CFErrorRef error = NULL;
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(Contact[@"name"]), &error);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, @"", &error);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, @"", &error);
    ABRecordSetValue(newPerson, kABPersonJobTitleProperty, @"", &error);
    
    //phone number
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone,(__bridge CFTypeRef)(Contact[@"phone"]), kABPersonPhoneMainLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhone, @"", kABPersonPhoneMobileLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhone, @"", kABOtherLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,&error);
    CFRelease(multiPhone);
    
    //email
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, @"", kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
    CFRelease(multiEmail);
    
    //address
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:@"" forKey:(NSString *) kABPersonAddressStreetKey];
    [addressDictionary setObject:@"" forKey:(NSString *)kABPersonAddressCityKey];
    [addressDictionary setObject:@"" forKey:(NSString *)kABPersonAddressStateKey];
    [addressDictionary setObject:@"" forKey:(NSString *)kABPersonAddressZIPKey];
    ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress,&error);
    CFRelease(multiAddress);
    
    
    
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    ABAddressBookSave(iPhoneAddressBook, &error);
    if (error != NULL)
    {
        NSLog(@"Danger Will Robinson! Danger!");
    }
    
    
}

#pragma mark add tableview
- (void)makeAddTableview{
    if (kDevice_Is_iPhoneX) {
        tongTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight - 49 - 86)];
    }else{
        tongTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight - 49 - 64)];
    }
    
   // [tongTableview setContentOffset:CGPointMake(ScreenWidth, ScreenHeight - 49)];
    tongTableview.delegate = self;
    tongTableview.dataSource = self;
    tongTableview.separatorStyle = UITableViewCellSelectionStyleNone;
    tongTableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tongTableview];
    
    hear = [[NSBundle mainBundle]loadNibNamed:@"headerView" owner:nil options:nil].lastObject;
    hear.userInteractionEnabled = YES;
    
    [hear.refreshBtn addTarget:self action:@selector(didRefreshButton) forControlEvents:UIControlEventTouchUpInside];
    [hear.xiazaiBtn addTarget:self action:@selector(xiazaiButton) forControlEvents:UIControlEventTouchUpInside];
    tongTableview.tableHeaderView = hear;
    hear.xiazaiBtn.layer.masksToBounds = YES;
    hear.xiazaiBtn.layer.cornerRadius = 16;
    
    self.CircleP = [[CircularProgressView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 40, 40, 80, 80)];
    [self.CircleP  setProgressValue:0 animated:YES];
    self.CircleP.progressWidth = 3;
    self.CircleP.percentageLabelSize = 17;
    self.CircleP.percentageTextColor = [UIColor whiteColor];
    self.CircleP.progressBarColor = [UIColor whiteColor];
    [hear addSubview:self.CircleP];
   
    
}
#pragma mark 刷新按钮
- (void)didRefreshButton{
    [self makeXiazai];
    NSLog(@"点击了刷新按钮");
    
    
}
#pragma mark 下载按钮
- (void)xiazaiButton{
    NSLog(@"点击了下载按钮");
    
//    [self makeDownloadPhone];
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted &&  !error) {
            CFArrayRef personArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex personCount = ABAddressBookGetPersonCount(addressBook);
            if (personCount > 0) {
              
            
            for (int i = 0; i < personCount; i++) {
                ABRecordRef ref = CFArrayGetValueAtIndex(personArray, i);
                // 删除联系人
                ABAddressBookRemoveRecord(addressBook, ref, nil);
            }
            
            // 保存通讯录操作对象
            ABAddressBookSave(addressBook, &error);
            CFRelease(addressBook);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                     [self makeDownloadPhone];
                    NSLog(@"清空通讯录成功");
                } else {
                    [self hideHud];
                    [self showHint:@"清空通讯录失败"];
                }
            });
            }else{
                [self makeDownloadPhone];
            }
        }
    });

    
  //  [self TongXunLuDelete];

}
#pragma mark 删除通讯录
- (void)TongXunLuDelete{
    
    [self showHudInView:self.view hint:nil];
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted &&  !error) {
            CFArrayRef personArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex personCount = ABAddressBookGetPersonCount(addressBook);
            if (personCount <= 0) {
             
            }else{
            
            for (int i = 0; i < personCount; i++) {
                ABRecordRef ref = CFArrayGetValueAtIndex(personArray, i);
                // 删除联系人
                ABAddressBookRemoveRecord(addressBook, ref, nil);
                }
                // 保存通讯录操作对象
                ABAddressBookSave(addressBook, &error);
                CFRelease(addressBook);
            }
           
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    [self showHint:@"清空通讯录成功"];
                    [self hideHud];
                    
                } else {
                    [self hideHud];
                    [self showHint:@"清空通讯录失败"];
                }
            });
            
        }
    });
    
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return xiazaiArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    TongTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"TongTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    XiaZaiListModel *model = xiazaiArr[indexPath.row];
    cellTwo.model = model;
    if (indexPath.row == 0) {
        cellTwo.viewOne.hidden = YES;
        cellTwo.imgView.image = [UIImage imageNamed:@"首页-circle"];
    }else{
        cellTwo.imgView.image = [UIImage imageNamed:@"首页-circle1"];
    }
    return cellTwo;
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
