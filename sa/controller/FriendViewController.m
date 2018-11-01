//
//  FriendViewController.m
//  SanQiClound
//
//  Created by yu on 2017/11/8.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "FriendViewController.h"
#import "FriendTableViewCell.h"
#import "FriendDetailViewController.h"
#import "FriendVideoViewController.h"
#import "friendListModel.h"
@interface FriendViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *friendTableview;
    NSInteger number;//分页参数
    NSMutableArray *friendArray;//存放朋友圈数据
}

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    backTitleHidden;
    self.view.backgroundColor = [UIColor whiteColor];
    friendArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeFriendRefreshData) name:@"didRefreshFriendList" object:nil];
    
    number = 0;
    [self makeAddTableview];
    [self makeFriendData];
    // Do any additional setup after loading the view from its nib.
    
}
- (void)makeAddTableview{
    friendTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    friendTableview.delegate = self;
    friendTableview.dataSource = self;
    friendTableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:friendTableview];
    
    friendTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        number = 0;
        [self makeFriendData];
    }];
    friendTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self makeFriendData];
    }];
    
}
- (void)makeFriendRefreshData{
    number = 0;
    [self makeFriendData];
}
#pragma mark 获取朋友圈列表
- (void)makeFriendData{
    number ++ ;
    NSArray *keysArray = @[@"id",@"page",@"num",@"isfinish"];
    NSArray *valuesArray = @[userIDStr,[NSString stringWithFormat:@"%ld",(long)number],@"10",@"2"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,friendList];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"朋友圈列表%@",data);
        NSString *status = [NSString stringWithFormat:@"%@",data[@"status"][@"succeed"]];
        if ([status isEqualToString:@"1"]) {
            NSArray *array = [NSArray arrayWithArray:data[@"data"][@"obj"]];
            if (array.count > 0) {
                
                if (number == 1) {
                    [friendArray removeAllObjects];
                }
                
                for (NSDictionary *dic in array) {
                    friendListModel *model = [friendListModel yy_modelWithJSON:dic];
                    [friendArray addObject:model];
                }
                
                number ++ ;
                
            }else{
                if (friendArray.count == 0) {
                    
                    [self showHint:@"暂无数据" inView:self.view];
                }else{
                    
                    [self showHint:@"暂无更多数据" inView:self.view];
                }
                number -- ;
            }
        }else{
            
            [self showHint:@"暂无数据" inView:self.view];
            number -- ;
            
        }
        [friendTableview reloadData];
        
        [friendTableview.mj_footer endRefreshing];
        [friendTableview.mj_header endRefreshing];
        [self hideHud];
    } failure:^(NSError *error) {
        [friendTableview.mj_footer endRefreshing];
        [friendTableview.mj_header endRefreshing];
        number -- ;
        [self hideHud];
        NSLog(@"朋友圈列表%@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return friendArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    FriendTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"FriendTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    friendListModel *model = friendArray[indexPath.row];
    cellTwo.model = model;
    return cellTwo;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    friendListModel *model = friendArray[indexPath.row];
    NSString *move_type = [NSString stringWithFormat:@"%@",model.move_type];
    if ([move_type isEqualToString:@"1"]) {
        FriendVideoViewController *friend = [[FriendVideoViewController alloc]init];
        friend.hidesBottomBarWhenPushed = YES;
        friend.seeStr = model.see;
        friend.cid = model.id;
        [self.navigationController pushViewController:friend animated:NO];
    }else{
        FriendDetailViewController *friend = [[FriendDetailViewController alloc]init];
        friend.cid = model.id;
        friend.seeStr = model.see;
        friend.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friend animated:NO];
    }
    
    
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
