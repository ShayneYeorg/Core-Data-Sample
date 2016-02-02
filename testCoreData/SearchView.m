//
//  SearchView.m
//  testCoreData
//
//  Created by 杨淳引 on 16/2/1.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "SearchView.h"

@interface SearchView ()

@property (nonatomic, strong) UITextField *field;

@end

@implementation SearchView

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self configDetails];
    }
    return self;
}

#pragma mark - Private

- (void)configDetails {
    self.field = [[UITextField alloc]initWithFrame:CGRectMake(10, 20, 180, 30)];
    self.field.backgroundColor = [UIColor whiteColor];
    [self.field setPlaceholder:@"查询标题"];
    [self addSubview:self.field];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(60, 80, 80, 30)];
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)search {
    if (self.searchHandler) self.searchHandler(self.field.text);
    [self removeFromSuperview];
}

@end
