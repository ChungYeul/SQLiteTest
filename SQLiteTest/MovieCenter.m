//
//  MovieCenter.m
//  SQLiteTest
//
//  Created by SDT-1 on 2014. 1. 14..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MovieCenter.h"

@implementation MovieCenter
static MovieCenter *_instance = nil;
+(id)sharedMovieCenter {
    if (_instance == nil) {
        _instance = [[MovieCenter alloc] init];
    }
    return _instance;
}
@end