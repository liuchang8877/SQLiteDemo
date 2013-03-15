//
//  ViewController.h
//  SQLiteDemo
//
//  Created by liu on 3/14/13.
//  Copyright (c) 2013 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
{
    NSString *databasePath;
    sqlite3 *contactDB;
}
@property (weak, nonatomic) IBOutlet UIButton *searchBut;
@property (weak, nonatomic) IBOutlet UIButton *delBut;
@property (weak, nonatomic) IBOutlet UIButton *addBut;
@property (weak, nonatomic) IBOutlet UITextField *namTextField;
@property (weak, nonatomic) IBOutlet UITextView *showTextView;

@property (weak, nonatomic) IBOutlet UITextField *oldTextField;
- (IBAction)addBut:(id)sender;
- (IBAction)delBut:(id)sender;
- (IBAction)searchBut:(id)sender;

@end
