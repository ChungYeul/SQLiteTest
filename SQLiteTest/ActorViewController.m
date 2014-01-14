//
//  ActorViewController.m
//  SQLiteTest
//
//  Created by SDT-1 on 2014. 1. 14..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ActorViewController.h"
#import "Actor.h"

@interface ActorViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ActorViewController {
    NSMutableArray *data;
//    sqlite3 *db;
}

// 새로운 데이터를 데이터베이스에 저장한다
- (void)addData:(NSString *)input {
    NSLog(@"adding data : %@", input);
    
    // sqlite3_exec 로 실행하기
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO ACTOR (movie_id, actor) VALUES (%d,'%@')", self.movieID,input];
//    NSString *sql = @"INSERT INTO ACTOR (actor) VALUES ('aa')";
    NSLog(@"sql : %@", sql);
    
    char *errMsg;
    int ret = sqlite3_exec(self.db, [sql UTF8String], NULL, nil, &errMsg);
    
    if (SQLITE_OK != ret) {
        NSLog(@"Error on Insert New data : %s", errMsg);
    }
    
    // 바인딩 예제
    //
    
    [self resolveData];
}

// 데이터베이스 닫기
- (void)closeDB {
//    sqlite3_close(db);
}

// 데이터베이스에서 정보를 가져온다
- (void)resolveData {
    // 기존 데이터 삭제
    [data removeAllObjects];
    
    // 데이터 베이스에서 사용할 쿼리 준비
    NSString *queryStr = [NSString stringWithFormat:@"SELECT movie_id, actor FROM ACTOR WHERE movie_id = %ld", (long)self.movieID];
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(self.db, [queryStr UTF8String], -1, &stmt, NULL);
    NSAssert2(SQLITE_OK == ret, @"Error(%d) on resolving data : %s", ret, sqlite3_errmsg(self.db));
    
    // 모든 행의 정보를 얻어온다
    while (SQLITE_ROW == sqlite3_step(stmt)) {
        int movieID = sqlite3_column_int(stmt, 0);
        char *actorName = (char *)sqlite3_column_text(stmt, 1);
        
        // Actor 객체 생성, 데이터 세팅
        Actor *one = [[Actor alloc] init];
        one.movieID = movieID;
        one.actorName = [NSString stringWithCString:actorName encoding:NSUTF8StringEncoding];
        [data addObject:one];
        
    }
    sqlite3_finalize(stmt);
    
    // 테이블 갱신
    [self.table reloadData];
}
- (IBAction)addActor:(id)sender {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"영화배우 추가" message:@"추가할 배우를 입력하세요" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ACTOR" forIndexPath:indexPath];
    
    //
    Actor *one = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = one.actorName;
    return cell;
}

//
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.firstOtherButtonIndex == buttonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *userInput = textField.text;
        [self addData:userInput];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resolveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
