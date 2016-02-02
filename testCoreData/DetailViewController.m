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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        self.titleFiled.text = self.theAlterArticle.title;
        self.contentField.text = [[NSString alloc]initWithData:self.theAlterArticle.content encoding:NSUTF8StringEncoding];
        self.objectID = self.theAlterArticle.objectID;
    }
}

- (void)saveArticle {
    if (self.objectID) {
        [self alterArticle];
        
    } else {
        [self addArticle];
    }
}


#pragma mark - Core Data

- (void)addArticle
{
    NSLog(@"新增");
    NSString *title = self.titleFiled.text;
    NSString *content = self.contentField.text;
    
    Article *article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    article.title = title;
    article.content = [content dataUsingEncoding:NSUTF8StringEncoding];
    article.createTime = [NSDate date];
    
    NSError *error = nil;
    if([self.appDelegate.managedObjectContext save:&error]) {
        if (error) NSLog(@"Error when add article:%@,%@",error,[error userInfo]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alterArticle {
    NSLog(@"修改");
    
    NSError *error = nil;
    Article *article = [self.appDelegate.managedObjectContext objectWithID:self.objectID];
    article.title = self.titleFiled.text;
    article.content = [self.contentField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([self.appDelegate.managedObjectContext save:&error]) {
        NSLog(@"修改成功");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end







