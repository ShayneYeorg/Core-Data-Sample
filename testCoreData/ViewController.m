//
//  ViewController.m
//  testCoreData
//
//  Created by 杨淳引 on 16/2/1.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "SearchView.h"

typedef enum _LoadType {
    LoadType_First_Load = 0,
    LoadType_Other
}LoadType;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) AppDelegate *appDelegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.articles = [self checkArticlesFromDataSource:LoadType_First_Load];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];
    Article *article = self.articles[indexPath.row];
    cell.textLabel.text = article.title;
    NSData *data = article.content;
    cell.detailTextLabel.text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 130)];
    header.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"左划删除 / 点击修改\n当数据总数大于5时，首次只展示5条数据，\n点击“加载”展示其余数据（分页效果）。";
    label.numberOfLines = 0;
    [label setFont:[UIFont systemFontOfSize:12]];
    [label sizeToFit];
    [label setFrame:CGRectMake(50, 20, label.frame.size.width, label.frame.size.height)];
    [header addSubview:label];
    
    UIButton *newBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 80, 50, 30)];
    newBtn.backgroundColor = [UIColor grayColor];
    [newBtn setTitle:@"新增" forState:UIControlStateNormal];
    [header addSubview:newBtn];
    [newBtn addTarget:self action:@selector(newBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 80, 50, 30)];
    searchBtn.backgroundColor = [UIColor grayColor];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [header addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loadBtn = [[UIButton alloc]initWithFrame:CGRectMake(250, 80, 50, 30)];
    loadBtn.backgroundColor = [UIColor grayColor];
    [loadBtn setTitle:@"加载" forState:UIControlStateNormal];
    [header addSubview:loadBtn];
    [loadBtn addTarget:self action:@selector(loadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 130;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        Article *article = self.articles[indexPath.row];
        
        [self.articles removeObject:article];
        [self removeArticleFromDataSource:article];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = [DetailViewController new];
    detailVC.theAlterArticle = self.articles[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSMutableArray *)articles {
    if (!_articles) {
        _articles = [NSMutableArray array];
    }
    return _articles;
}

- (void)newBtnClick {
    NSLog(@"click");
    DetailViewController *detail = [[DetailViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)searchBtnClick {
    NSLog(@"search");
    SearchView *searchView = [[SearchView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2, ([UIScreen mainScreen].bounds.size.height-130)/2, 200, 130)];
    __weak ViewController *weakSelf = self;
    searchView.searchHandler = ^(NSString *searchStr){
        NSLog(@"%@", searchStr);
        if (searchStr.length) {
            weakSelf.articles = [weakSelf searchArticlesFromDataSource:searchStr];
            [weakSelf.tableView reloadData];
            
        } else {
            weakSelf.articles = [weakSelf checkArticlesFromDataSource:LoadType_First_Load];
            [weakSelf.tableView reloadData];
        }
    };
    [self.view addSubview:searchView];
}

- (void)loadBtnClick {
    NSLog(@"load more");
    [self.articles addObjectsFromArray:[self checkArticlesFromDataSource:LoadType_Other]];
    [self.tableView reloadData];
}

#pragma mark - Core Data


- (NSMutableArray *)checkArticlesFromDataSource:(LoadType)loadType
{
    NSInteger offset = 0;
    NSInteger limit = 5;
    if (loadType == LoadType_Other) {
        offset = 5;
        limit = INTMAX_MAX;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:entity];
    
    // 设置排序条件
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
    NSArray * sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    [request setFetchLimit:limit];
    [request setFetchOffset:offset];
    
    NSError *error = nil;
    NSMutableArray *articles = [[self.appDelegate.managedObjectContext
                                executeFetchRequest:request error:&error] mutableCopy];
    
    if(articles == nil)
    {
        NSLog(@"Error when fetch articles from data source:%@,%@",error,[error userInfo]);
    }
    
    return articles;
}

- (NSMutableArray *)searchArticlesFromDataSource:(NSString *)searchStr
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
    NSArray *sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    NSString *str = [NSString stringWithFormat:@"title LIKE '*%@*'", searchStr];
    NSPredicate *pre = [NSPredicate predicateWithFormat:str];
    [request setPredicate:pre];
    
    NSError *error = nil;
    NSMutableArray *articles = [[self.appDelegate.managedObjectContext
                                 executeFetchRequest:request error:&error] mutableCopy];
    
    if(articles == nil) {
        NSLog(@"Error when fetch articles from data source:%@,%@",error,[error userInfo]);
    }
    
    return articles;
}

- (void)removeArticleFromDataSource:(Article *)article
{
    [self.appDelegate.managedObjectContext deleteObject:article];
    
    NSError *error = nil;
    if(![self.appDelegate.managedObjectContext save:&error])
    {
        NSLog(@"Error when remove article form data source:%@,%@",error,[error userInfo]);
    }
}

@end






