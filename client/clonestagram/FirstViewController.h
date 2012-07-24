//
//  FirstViewController.h
//  clonestagram
//
//  Created by face-do on 12/07/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SBJson.h"
#import "ImageStore.h"

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    IBOutlet UITableView *timelineTable;
    NSMutableData *receivedData;
    NSMutableArray *timelineArray;
    __weak IBOutlet UIBarButtonItem *refreshButton;
    __strong IBOutlet UIProgressView *uploadProgressBar;
    UIView* uploadingView;
    UILabel *uploadlabel;
    
@private
    UIImageView *imageView;
    UIImage *image;
    ImageStore *imageStore_;

}

- (void)reloadtable;
- (IBAction)refreshButton:(id)sender;
@property (nonatomic, retain) IBOutlet UITableView *timelineTable;
@property (nonatomic, retain) UIView *uploadingView;


@end
