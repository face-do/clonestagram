//
//  LoginController.m
//  clonestagram
//
//  Created by face-do on 12/07/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"

@implementation LoginController
@synthesize username = _username;
@synthesize password = _password;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    self.title = @"Sign in";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 15, 300, 240) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLogin.frame = CGRectMake(30, 140, 260, 34);
    [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(btnLoginOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    return 2;
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
                    self.username = [[UITextField alloc] initWithFrame:CGRectMake(100.0, 14.0, 190.0, 50.0)];
                    self.username.returnKeyType = UIReturnKeyDone;
                    self.username.placeholder = @"UserID or email";
                    self.username.delegate = self;
                    self.username.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                    self.username.text =  [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
                    [cell addSubview:self.username];
                    cell.textLabel.text = @"UserID";
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
                    if ([self.username resignFirstResponder]) {
                        [self.username becomeFirstResponder];
                    }
                } else if (indexPath.row == 1) {
                    NSError *error;
                    self.password = [[UITextField alloc] initWithFrame:CGRectMake(100.0, 14.0, 190.0, 50.0)];
                    self.password.returnKeyType = UIReturnKeyDone;
                    self.password.placeholder = @"Password";
                    self.password.secureTextEntry = YES;
                    self.password.delegate = self;
                    self.password.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
                    [cell addSubview:self.password];
                    cell.textLabel.text = @"Password";
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
                    self.password.text = [SFHFKeychainUtils getPasswordForUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"] andServiceName:@"clonestagram" error:&error];
                }
                break;
                
        }
    }
    return cell;
}

- (void)btnLoginOnClicked:(id)sender
{
    NSURL *URL = [NSURL URLWithString:@"http://YOUR_SERVER_DOMAIN/users/sign_in.json"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    request.shouldRedirect = NO;
    
    [request setHTTPMethod:@"POST"];
    [request addBody:@"zKtbh5mbSBcs/CtRX+EWlPEhBGOaknL5OMcz+5jK7wM=" forKey:@"authenticity_token"];
    [request addBody:self.username.text forKey:@"user[login]"];
    [request addBody:self.password.text forKey:@"user[password]"];
    [request addBody:@"0" forKey:@"user[remember_me]"];
    
    [request setCompletionHandler:^(NSHTTPURLResponse *responseHeader, NSString *responseString){
        NSLog(@"%d", [[NSThread currentThread] isMainThread] == YES);
        NSDictionary *result = [responseString JSONValue];
        NSLog(@"%@", result);
        NSLog(@"%d", [responseHeader statusCode]);
        if ([responseHeader statusCode] == 201) {
            NSError *error;
            [SFHFKeychainUtils storeUsername:self.username.text andPassword:self.password.text forServiceName:@"clonestagram" updateExisting:YES error:&error];

            [self dismissModalViewControllerAnimated:YES];
        } else if([responseHeader statusCode] == 401) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                            message:@"Invalid email or password."
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


- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oldUsername = [defaults objectForKey:@"USERNAME"];
    NSError *error;
    if (![oldUsername isEqualToString:self.username.text]) {
        [SFHFKeychainUtils deleteItemForUsername:oldUsername andServiceName:@"clonestagram" error:&error];
    }
    [defaults setObject:self.username.text forKey:@"USERNAME"];
}


@end
