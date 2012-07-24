//
//  LoginController.h
//  clonestagram
//
//  Created by face-do on 12/07/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "SFHFKeychainUtils.h"
#import "R9HTTPRequest.h"

@interface LoginController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
@private
    UITableView *_tableView;
}

@property (retain, nonatomic) UITextField *username;
@property (retain, nonatomic) UITextField *password;


@end
