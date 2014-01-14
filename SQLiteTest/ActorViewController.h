//
//  ActorViewController.h
//  SQLiteTest
//
//  Created by SDT-1 on 2014. 1. 14..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface ActorViewController : UIViewController
@property (nonatomic) sqlite3 *db;
@property NSInteger movieID;
@end
