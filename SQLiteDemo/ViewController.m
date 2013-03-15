//
//  ViewController.m
//  SQLiteDemo
//
//  Created by liu on 3/14/13.
//  Copyright (c) 2013 liu. All rights reserved.
//

#import "ViewController.h"
#define DBNAME  @"stu.db"
#define DB_OPEN  sqlite3_open
#define DB_CLOSE sqlite3_close
#define DB_OK    sqlite3_finalize
#define DB_STEP  sqlite3_step
#define DB_TEXT  sqlite3_column_text
#define DB_DO_SQL    sqlite3_prepare_v2
#define DB_DO   sqlite3_exec

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _namTextField.delegate = self;
    _oldTextField.delegate = self;

	// Do any additional setup after loading the view, typically from a nib.
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: DBNAME]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    //judged the db file is exist or not
    if ([filemgr fileExistsAtPath:databasePath] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (DB_OPEN(dbpath, &contactDB)==SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS STU(ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, OLD TEXT)";
            if (DB_DO(contactDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
                
                _showTextView.text = @"create table error\n";

            }
        }
        else
        {
            _showTextView.text = @"creat db or open db error\n";
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)addBut:(id)sender {
    
    //add info
    sqlite3_stmt *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (DB_OPEN(dbpath, &contactDB)==SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO STU (NAME,OLD) VALUES(\"%@\",\"%@\")",_namTextField.text,_oldTextField.text];
        const char *insert_stmt = [insertSQL UTF8String];
        DB_DO_SQL(contactDB, insert_stmt, -1, &statement, NULL);
        if (DB_STEP(statement)==SQLITE_DONE) {
            
            _showTextView.text = @"save ok";
            _namTextField.text = @"";
            _oldTextField.text = @"";
        }
        else
        {
            _showTextView.text = @"save error";
        }
        DB_OK(statement);
        DB_CLOSE(contactDB);
    }
}

- (IBAction)delBut:(id)sender {
    
    //delete info
    const char *dbpath = [databasePath UTF8String];
    
    if (DB_OPEN(dbpath, &contactDB)==SQLITE_OK)
    {
        char *errMsg;
        NSString *querySQL = [NSString stringWithFormat:@"DELETE  from STU where name=\"%@\"",_namTextField.text];
        const char *query_stmt = [querySQL UTF8String];
        
        if (DB_DO(contactDB, query_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            
            _showTextView.text = @"delete error\n";
            
        } else {
            _showTextView.text = @"delete ok\n";
            _namTextField.text = @"";
            _oldTextField.text = @"";
            
        }
    }
}

- (IBAction)searchBut:(id)sender {
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    //search info
    if (DB_OPEN(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT name,old from STU where name=\"%@\"",_namTextField.text];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (DB_STEP(statement) == SQLITE_ROW)
            {
                NSString *addressField = [[NSString alloc] initWithUTF8String:(const char *)DB_TEXT(statement, 0)];
                 _namTextField.text = addressField;
                
                NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *)DB_TEXT(statement, 1 )];
                _oldTextField.text = phoneField;
                
                _showTextView.text = @"find it";
                
            }
            else {
                _showTextView.text = @"not find it";
                _namTextField.text = @"";
                _oldTextField.text = @"";
            }
            DB_OK(statement);
        }
        
        DB_CLOSE(contactDB);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

//-(void) hideKeyBoard:(UIView*)view{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(doHideKeyBoard)];
//    
//    tap.numberOfTapsRequired = 1;
//    [view  addGestureRecognizer: tap];
//    [tap setCancelsTouchesInView:NO];
//    //[tap release];
//}
//- (void)doHideKeyBoard{
//    [self resignFirstResponder];
//}

@end
