//
//  SearchView.h
//  testCoreData
//
//  Created by 杨淳引 on 16/2/1.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^searchBlock)(NSString *searchStr);

@interface SearchView : UIView

@property (nonatomic, strong) searchBlock searchHandler;

@end
