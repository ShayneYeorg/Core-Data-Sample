//
//  Article+CoreDataProperties.h
//  testCoreData
//
//  Created by 杨淳引 on 16/2/1.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Article.h"

NS_ASSUME_NONNULL_BEGIN

@interface Article (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSData *content;
@property (nullable, nonatomic, retain) NSDate *createTime;

@end

NS_ASSUME_NONNULL_END
