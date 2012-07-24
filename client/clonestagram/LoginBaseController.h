//
//  LoginBaseController.h
//  clonestagram
//
//  Created by face-do on 12/07/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginBaseController : UIViewController{
    
    __weak IBOutlet UIBarButtonItem *signUpButton;
    __weak IBOutlet UIBarButtonItem *loginButton;
}
- (IBAction)SignUpButton:(id)sender;
- (IBAction)loginButton:(id)sender;

@end
