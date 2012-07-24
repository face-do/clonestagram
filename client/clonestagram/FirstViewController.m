//
//  FirstViewController.m
//  clonestagram
//
//  Created by face-do on 12/07/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "SFHFKeychainUtils.h"
#define SavedHTTPCookiesKey @"SavedHTTPCookies"

@implementation FirstViewController
@synthesize timelineTable;
@synthesize uploadingView;
dispatch_once_t tableonceToken;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSError *error;
    
    if ([SFHFKeychainUtils getPasswordForUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"] andServiceName:@"clonestagram" error:&error] == nil ||
        [[NSUserDefaults standardUserDefaults] objectForKey:SavedHTTPCookiesKey] == nil) {
        
        UIViewController *navCtl = [[self storyboard] instantiateViewControllerWithIdentifier:@"loginBaseController"];
        
        [self presentModalViewController:navCtl animated:YES];
     //   return;
    }
    
    imageStore_ = [[ImageStore alloc] initWithDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification1:) name:@"P1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification2:) name:@"P2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification3:) name:@"P3" object:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    /*
    timelineTable = nil;
    refreshButton = nil;
    uploadProgressBar = nil;
*/
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_once(&tableonceToken, ^{
        NSLog(@"initial");
        receivedData = [[NSMutableData alloc] initWithLength:0];
        timelineArray = [[NSMutableArray alloc] init];
    });
    
    if (timelineArray.count == 0){
        NSLog(@"timelineArray:%d", timelineArray.count);
        [self reloadtable];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [timelineArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *cell = [timelineArray objectAtIndex:section];
    return [cell objectForKey:@"username"];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *cell = [timelineArray objectAtIndex:section];
    
	UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 24.0f, 24.0f)];
    view.image = [UIImage imageNamed:@"photo3.jpeg"];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,320.0f,40.0f)];
    [v setBackgroundColor:[UIColor whiteColor]];
    v.backgroundColor = [UIColor whiteColor];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(42.0f, 0.0f, 320.0f, 40.0f)];
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.textColor = [UIColor blackColor];
    
    lbl.text = [NSString stringWithFormat:[[cell objectForKey:@"user"] objectForKey:@"username"]];
    [v addSubview:lbl]; 
    [v addSubview:view];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tweet = [timelineArray objectAtIndex:indexPath.section];
    
    static NSString *cellID = @"timelineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300.0, 300.0)];
        imageView.tag = 1;
        [cell.contentView addSubview:imageView];
    }else{
        imageView = (UIImageView *)[cell.contentView viewWithTag:1];
    }
    
    NSString *imageURL = [[[tweet objectForKey:@"avatar"] objectForKey:@"thumb"] objectForKey:@"url"];
    
    NSLog(@"%@", imageURL);
    
    image = [imageStore_ getImage:imageURL];
    imageView.image = image;
    imageView.layer.cornerRadius = 5;
    imageView.clipsToBounds = true;
    cell.frame = CGRectMake(0, 0, 320.0, 320.0);
    cell.editing = NO;
    
    return cell;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
	int statusCode = [res statusCode];
    if(statusCode == 401) {
        UIViewController *navCtl = [[self storyboard] instantiateViewControllerWithIdentifier:@"loginBaseController"];
        
        [self presentModalViewController:navCtl animated:YES];
        return;
    }
    
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *json = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSDictionary *result = [json JSONValue];
    
    if (timelineArray != nil && result != nil){
        timelineArray = [[NSMutableArray alloc] init];
    }
    NSLog(@"%@", result);
	for (NSDictionary* cell in result) {
		NSLog(@"- %@", [cell objectForKey:@"id"]);
        [timelineArray addObject:cell];
	}
    [timelineTable reloadData];
}


- (void)imageStoreDidGetNewImage:(ImageStore*)sender url:(NSString*)url
{
    NSLog(@"finished");
    image = [sender getImage:url];
    [self.timelineTable reloadData];
    
}

- (IBAction)refreshButton:(id)sender {
    NSLog(@"refresh!");
    [self reloadtable];
    
}
- (void)reloadtable{
    NSLog(@"reload!");

    NSString *urlString = [NSString stringWithFormat:@"http://YOUR_SERVER_DOMAIN/home.json"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
    [conn scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [conn start];
    
    if (conn == nil) {
        return;
    }

}

-(void)receiveNotification1:(NSNotification *) notification {
    [uploadingView removeFromSuperview];
    
    timelineTable.transform = CGAffineTransformMakeTranslation(0, 0);
    
    [self reloadtable];
}

-(void)receiveNotification2:(NSNotification *) notification {
        
    UIImageView *upoadingImage = [[notification userInfo] objectForKey:@"KEY1"];

    upoadingImage.frame = CGRectMake(10, 8, 24.0f, 24.0f);

    uploadingView = [[UIView alloc] initWithFrame:[[self view] bounds]];
    uploadingView.frame = CGRectMake(0, 44, 320, 40);
    uploadingView.backgroundColor = [UIColor viewFlipsideBackgroundColor];

    uploadProgressBar = [[UIProgressView alloc]
                         initWithProgressViewStyle:UIProgressViewStyleDefault];
    uploadProgressBar.frame = CGRectMake(150, 16, 150, 30);
    uploadProgressBar.progress = 0.0;

    uploadlabel = [[UILabel alloc] initWithFrame:CGRectMake(42,4,100,30)];
    uploadlabel.text = @"uploading...";
    uploadlabel.backgroundColor = [UIColor clearColor];
    uploadlabel.textColor =[UIColor whiteColor];

    [self.view addSubview:uploadingView];
    [uploadingView addSubview:upoadingImage];
    [uploadingView addSubview:uploadlabel];
    [uploadingView addSubview:uploadProgressBar];
    timelineTable.transform = CGAffineTransformMakeTranslation(0, 40);
}

-(void)receiveNotification3:(NSNotification *) notification {

    NSString *valueF = [[notification userInfo] objectForKey:@"KEY1"];
    float val = [valueF floatValue];
    uploadProgressBar.progress = val;
    
    if (val == 1.0f) {
        uploadlabel.text = @"Done!";
    }
}

@end
