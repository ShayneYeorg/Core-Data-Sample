//
//  DetailViewController.m
//  testCoreData
//
//  Created by 杨淳引 on 16/2/1.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()

@property (nonatomic, strong) NSManagedObjectID *objectID;
@property (nonatomic, strong) UITextField *titleFiled;
@property (nonatomic, strong) UITextView *contentField;
@property (weak, nonatomic) AppDelegate *appDelegate;

@end

@implementation DetailViewController

#pragma mark - Core Data

//新增数据
- (void)addArticle {
    NSString *title = self.titleFiled.text;
    NSString *content = self.contentField.text;
    
    Article *article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    article.title = title;
    article.content = [content dataUsingEncoding:NSUTF8StringEncoding];
    article.createTime = [NSDate date];
    
    NSError *error = nil;
    if ([self.appDelegate.managedObjectContext save:&error]) {
        if (error) NSLog(@"新增时发生错误:%@,%@",error,[error userInfo]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//修改数据
- (void)alterArticle {
    Article *article = [self.appDelegate.managedObjectContext objectWithID:self.objectID];
    article.title = self.titleFiled.text;
    article.content = [self.contentField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    if ([self.appDelegate.managedObjectContext save:&error]) NSLog(@"修改成功");
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    [self configDetails];
}

- (void)dealloc {
    NSLog(@"DetailViewController dealloc");
    self.appDelegate = nil;
}

#pragma mark - UIConfiguration

- (void)configDetails {
    self.titleFiled = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, 200, 30)];
    self.titleFiled.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.titleFiled];
    
    self.contentField = [[UITextView alloc]initWithFrame:CGRectMake(20, 200, 200, 200)];
    self.contentField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.contentField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 50, 20)];
    [btn addTarget:self action:@selector(saveArticle) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if (self.theAlterArticle) {
        //在修改的状态下
        self.titleFiled.text = self.theAlterArticle.title;
        self.contentField.text = [[NSString alloc]initWithData:self.theAlterArticle.content encoding:NSUTF8StringEncoding];
        self.objectID = self.theAlterArticle.objectID;
    }
}

#pragma mark - Button Action

- (void)saveArticle {
    if (self.objectID) {
        [self alterArticle];
        
    } else {
        [self addArticle];
    }
}

@end


