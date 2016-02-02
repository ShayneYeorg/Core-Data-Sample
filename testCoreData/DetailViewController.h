//
//  DetailViewController.h
//  testCoreData
//
//  Created by 杨淳引 on 16/2/1.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article+CoreDataProperties.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Article *theAlterArticle;

@end
