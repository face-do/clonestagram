//
//  SignupController.h
//  clonestagram
//
//  Created by face-do on 12/07/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "R9HTTPRequest.h"
#import "SBJson.h"
#import "SFHFKeychainUtils.h"

@interface SignupController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> 
{
@private
    UITableView *_tableView;
}

@property (retain, nonatomic) UITextField *username;
@property (retain, nonatomic) UITextField *password;
@property (retain, nonatomic) UITextField *mailaddress;


@end
