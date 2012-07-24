//
//  searchViewController.m
//  clonestagram
//
//  Created by face-do on 12/07/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "searchViewController.h"
#import "UserDetailController.h"

@implementation searchViewController
@synthesize timelineTable;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"clonestagram";
}


- (void)viewDidUnload
{
    [self setTimelineTable:nil];
    timelineTable = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// セクションに含まれる行の数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [timelineArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tweet = [timelineArray objectAtIndex:indexPath.section];
    
    static NSString *cellID = @"timelineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [tweet objectForKey:@"username"];

    return cell;
}
-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar{
    
    receivedData = [[NSMutableData alloc] initWithLength:0];
    timelineArray = [[NSMutableArray alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"http://YOUR_SERVER_DOMAIN/search.json?id=%@", searchBar.text];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
    [conn scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [conn start];
    NSLog(@"%@", urlString);
    if (conn == nil) {
        return;
    }
    [searchBar resignFirstResponder];

}
-(void)searchBarCancelButtonClicked:(UISearchBar*)searchBar	{
    [searchBar resignFirstResponder];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *json = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSDictionary *result = [json JSONValue];
    NSLog(@"%@", result);
	for (NSDictionary* cell in result) {
		NSLog(@"- %@", [cell objectForKey:@"id"]);
        [timelineArray addObject:cell];
	}
    [timelineTable reloadData];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.timelineTable deselectRowAtIndexPath:indexPath animated:YES];
    
    UserDetailController *viewController;
    viewController = [[UserDetailController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    NSDictionary *object = [timelineArray objectAtIndex:indexPath.row];
    [viewController setDetailItem:object];

    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
