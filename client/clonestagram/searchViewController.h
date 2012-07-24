//
//  searchViewController.h
//  clonestagram
//
//  Created by face-do on 12/07/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "R9HTTPRequest.h"

@interface searchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    __weak IBOutlet UITableView *timelineTable;
    NSMutableData *receivedData;
    NSMutableArray *timelineArray;
    UIButton *buttonY;
}
@property (weak, nonatomic) IBOutlet UITableView *timelineTable;

@end
