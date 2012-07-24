//
//  UserDetailController.m
//  clonestagram
//
//  Created by face-do on 12/07/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserDetailController.h"
#import <QuartzCore/QuartzCore.h>

@interface UserDetailController ()
- (void)configureView;
@end

@implementation UserDetailController
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize photoCount;
@synthesize followCount;
@synthesize followerCount;
@synthesize timelineTable;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

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
    timelineArray = [[NSMutableArray alloc] init];
    imageStore_ = [[ImageStore alloc] initWithDelegate:self];
    
    UIScrollView *baseView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    baseView.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    [self.view addSubview:baseView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, 320, 400) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];  
    
    NSString *urlString = [NSString stringWithFormat:@"http://YOUR_SERVER_DOMAIN/users/%@.json", [self.detailItem objectForKey:@"id"]];
    NSURL *URL = [NSURL URLWithString:urlString];
    
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    
    [request setHTTPMethod:@"get"];
    [request setCompletionHandler:^(NSHTTPURLResponse *responseHeader, NSString *responseString){
        NSLog(@"%d", [[NSThread currentThread] isMainThread] == YES);
        NSDictionary *result = [responseString JSONValue];
        NSLog(@"result:%@", result);

        
        NSString *follow = [result objectForKey:@"follow?"];
        NSLog(@"%@", follow);
                
        photoCount.text = [[NSString alloc] initWithFormat:@"%@",[result objectForKey:@"entries_count"]];
        followCount.text = [[NSString alloc] initWithFormat:@"%@",[result objectForKey:@"friends_count"]];
        followerCount.text = [[NSString alloc] initWithFormat:@"%@",[result objectForKey:@"followers_count"]];
        
        buttonY = [UIButton buttonWithType:102];
        buttonY.frame = CGRectMake(240, 5, 70, 30);
        [buttonY addTarget:self action:@selector(buttonYpush:) forControlEvents:UIControlEventTouchUpInside];
        [followBar addSubview:buttonY];
        
        if ( [follow isEqualToString:@"followed"]) {
            [buttonY setTitle:@"unfollow" forState:UIControlStateNormal];
            [buttonY setTintColor:[UIColor redColor]];
        } else if ([follow isEqualToString:@"not yet follow"]){
            [buttonY setTitle:@"follow" forState:UIControlStateNormal];
            
        } else {
            [buttonY setTitle:@"yourself" forState:UIControlStateNormal];
            buttonY.enabled = false;
        }
        
        NSLog(@"timelinearray count:%@" ,[timelineArray count]);

        for (NSMutableDictionary* cell in [result objectForKey:@"entries"]) {
            NSLog(@"- %@", [cell objectForKey:@"id"]);
            [cell setObject:[result objectForKey:@"username"] forKey:@"username"];
            
            [timelineArray addObject:cell];
        }
        
        [_tableView reloadData];
        
    }];
    // Progress
    [request setUploadProgressHandler:^(float newProgress){
        NSLog(@"%g", newProgress);
    }];
    [request startRequest];
    
    
    self.title = [self.detailItem objectForKey:@"username"];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    imageBaseView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    imageBaseView.image = [UIImage imageNamed:@"camera.png"];
    [baseView addSubview:imageBaseView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(80,0,100,30)];
    label.text = [self.detailItem objectForKey:@"username"];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:22];
    [baseView addSubview:label];
    
    photoList =  [[UIView alloc] initWithFrame:CGRectMake(0, 80, 320, 300)];
    photoList.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:photoList];
    
    followBar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    followBar.backgroundColor = [UIColor lightGrayColor];
    [photoList addSubview:followBar];
    
    buttonPhoto = [UIButton buttonWithType:102];
    [buttonPhoto setTintColor:[UIColor lightGrayColor]];
    buttonPhoto.frame = CGRectMake(80, 30, 70, 40);
    photoCount = [[UILabel alloc] initWithFrame:CGRectMake(0,0,70,30)];
    photoCount.text = @"";
    photoCount.backgroundColor = [UIColor clearColor];
    photoCount.font = [UIFont fontWithName:@"Helvetica" size:22];
    photoCount.textAlignment = UITextAlignmentCenter;
    photoCount.textColor = [UIColor whiteColor];
    
    UILabel *photolabel = [[UILabel alloc] initWithFrame:CGRectMake(0,24,70,15)];
    photolabel.text = @"photo";
    photolabel.backgroundColor = [UIColor clearColor];
    photolabel.font = [UIFont fontWithName:@"Helvetica" size:9];
    photolabel.textAlignment = UITextAlignmentCenter;
    photolabel.textColor = [UIColor whiteColor];
    
    [baseView addSubview:buttonPhoto];
    [buttonPhoto addSubview:photoCount];
    [buttonPhoto addSubview:photolabel];
    
    buttonFollow = [UIButton buttonWithType:102];
    [buttonFollow setTintColor:[UIColor lightGrayColor]];
    buttonFollow.frame = CGRectMake(160, 30, 70, 40);
    followCount = [[UILabel alloc] initWithFrame:CGRectMake(0,0,70,30)];
    followCount.text = @"";
    followCount.backgroundColor = [UIColor clearColor];
    followCount.font = [UIFont fontWithName:@"Helvetica" size:22];
    followCount.textAlignment = UITextAlignmentCenter;
    followCount.textColor = [UIColor whiteColor];
    
    UILabel *followlabel = [[UILabel alloc] initWithFrame:CGRectMake(0,24,70,15)];
    followlabel.text = @"follows";
    followlabel.backgroundColor = [UIColor clearColor];
    followlabel.font = [UIFont fontWithName:@"Helvetica" size:9];
    followlabel.textAlignment = UITextAlignmentCenter;
    followlabel.textColor = [UIColor whiteColor];
    [baseView addSubview:buttonFollow];
    [buttonFollow addSubview:followCount];
    [buttonFollow addSubview:followlabel];
    
    
    buttonFollower = [UIButton buttonWithType:102];
    [buttonFollower setTintColor:[UIColor lightGrayColor]];
    buttonFollower.frame = CGRectMake(240, 30, 70, 40);
    followerCount = [[UILabel alloc] initWithFrame:CGRectMake(0,0,70,30)];
    followerCount.text = @"";
    followerCount.backgroundColor = [UIColor clearColor];
    followerCount.font = [UIFont fontWithName:@"Helvetica" size:22];
    followerCount.textAlignment = UITextAlignmentCenter;
    followerCount.textColor = [UIColor whiteColor];
    
    UILabel *followerlabel = [[UILabel alloc] initWithFrame:CGRectMake(0,24,70,15)];
    followerlabel.text = @"followers";
    followerlabel.backgroundColor = [UIColor clearColor];
    followerlabel.font = [UIFont fontWithName:@"Helvetica" size:9];
    followerlabel.textAlignment = UITextAlignmentCenter;
    followerlabel.textColor = [UIColor whiteColor];
    
    [baseView addSubview:buttonFollower];
    [buttonFollower addSubview:followerCount];
    [buttonFollower addSubview:followerlabel];
    
    
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

-(void)buttonYpush:(id)sender{
    NSURL *URL = [NSURL URLWithString:@"http://YOUR_SERVER_DOMAIN/follow.json"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    
    [request setHTTPMethod:@"POST"];
    [request addBody:[self.detailItem objectForKey:@"id"] forKey:@"[id]"];
    
    [request setCompletionHandler:^(NSHTTPURLResponse *responseHeader, NSString *responseString){
        NSLog(@"%d", [[NSThread currentThread] isMainThread] == YES);
        NSDictionary *result = [responseString JSONValue];
        NSLog(@"result:%@", result);
        
        NSString *follow = [result objectForKey:@"follow?"];
        
        [buttonY removeFromSuperview];
        
        buttonY = [UIButton buttonWithType:102];
        buttonY.frame = CGRectMake(240, 5, 70, 30);
        [buttonY addTarget:self action:@selector(buttonYpush:) forControlEvents:UIControlEventTouchUpInside];
        [followBar addSubview:buttonY];
        
        if ( [follow isEqualToString:@"followed"]) {
            [buttonY setTitle:@"unfollow" forState:UIControlStateNormal];
            [buttonY setTintColor:[UIColor redColor]];
            
        } else if ([follow isEqualToString:@"not yet follow"]){
            [buttonY setTitle:@"follow" forState:UIControlStateNormal];
            
        } else {
            [buttonY setTitle:@"yourself" forState:UIControlStateNormal];
            buttonY.enabled = false;
        }
        
    }];
    [request startRequest];
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
    v.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(42.0f, 0.0f, 320.0f, 40.0f)];
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.textColor = [UIColor blackColor];
    
    lbl.text = [NSString stringWithFormat:[cell objectForKey:@"username"]];
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
    
    NSLog(@"image URL%@", imageURL);
    
    image = [imageStore_ getImage:imageURL];
    imageView.image = image;
    imageView.layer.cornerRadius = 5;
    imageView.clipsToBounds = true;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 320;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section	{
    return 40;
}
- (void)imageStoreDidGetNewImage:(ImageStore*)sender url:(NSString*)url
{
    NSLog(@"finished");
    image = [sender getImage:url];
    [_tableView reloadData];
}



@end
