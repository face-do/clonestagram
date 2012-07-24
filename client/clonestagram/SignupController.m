//
//  SignupController.m
//  clonestagram
//
//  Created by face-do on 12/07/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignupController.h"

@implementation SignupController
@synthesize username = _username;
@synthesize password = _password;
@synthesize mailaddress = _mailaddress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    self.title = @"Sign up";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 15, 300, 240) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLogin.frame = CGRectMake(30, 180, 260, 34);
    [btnLogin setTitle:@"Done" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(btnLoginOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
        
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    self.username = [[UITextField alloc] initWithFrame:CGRectMake(130.0, 14.0, 160.0, 50.0)];
                    self.username.returnKeyType = UIReturnKeyDone;
                    self.username.placeholder = @"UserID";
                    self.username.delegate = self;
                    self.username.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                    [cell addSubview:self.username];
                    cell.textLabel.text = @"Username";
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
                    if ([self.username resignFirstResponder]) {
                        [self.username becomeFirstResponder];
                    }
                } else if (indexPath.row == 2) {
                    self.password = [[UITextField alloc] initWithFrame:CGRectMake(130.0, 14.0, 160.0, 50.0)];
                    self.password.returnKeyType = UIReturnKeyDone;
                    self.password.placeholder = @"Password";
                    self.password.secureTextEntry = YES;
                    self.password.delegate = self;
                    self.password.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                    [cell addSubview:self.password];
                    cell.textLabel.text = @"Password";
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
                    
                } else if (indexPath.row == 1) {
                    self.mailaddress = [[UITextField alloc] initWithFrame:CGRectMake(130.0, 14.0, 160.0, 50.0)];
                    self.mailaddress.returnKeyType = UIReturnKeyDone;
                    self.mailaddress.placeholder = @"info@example.com";
                    self.mailaddress.delegate = self;
                    self.mailaddress.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                    [cell addSubview:self.mailaddress];
                    cell.textLabel.text = @"email";
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
                }
                break;
                
        }
    }
    return cell;
}
- (void)btnLoginOnClicked:(id)sender
{
    if (self.mailaddress.text ==nil || self.password.text ==nil ){
        return;
    }
    NSURL *URL = [NSURL URLWithString:@"http://YOUR_SERVER_DOMAIN/users.json"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    request.shouldRedirect = NO;
    
    [request setHTTPMethod:@"POST"];
    [request addBody:@"zKtbh5mbSBcs/CtRX+EWlPEhBGOaknL5OMcz+5jK7wM=" forKey:@"authenticity_token"];
    [request addBody:self.mailaddress.text forKey:@"user[email]"];
    [request addBody:self.password.text forKey:@"user[password]"];
    [request addBody:self.username.text forKey:@"user[username]"];
    
    
    [request setCompletionHandler:^(NSHTTPURLResponse *responseHeader, NSString *responseString){
        NSLog(@"%d", [[NSThread currentThread] isMainThread] == YES);
        NSLog(@"%d", [responseHeader statusCode]);
        if ([responseHeader statusCode] == 201) {
            NSDictionary *result = [responseString JSONValue];
            NSLog(@"%@", result);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"user registed"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            
            [alert show];
        }
    }];
    // Progress
    [request setUploadProgressHandler:^(float newProgress){
        NSLog(@"%g", newProgress);
    }];
    [request startRequest];
}

@end
