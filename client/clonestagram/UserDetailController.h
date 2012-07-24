//
//  UserDetailController.h
//  clonestagram
//
//  Created by face-do on 12/07/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "R9HTTPRequest.h"
#import "SBJson.h"
#import "ImageStore.h"

@interface UserDetailController : UIViewController<UITableViewDataSource, UITableViewDelegate>{

    UILabel *label;
    UIView *photoList;
    UIView *followBar;
    UIImageView *imageView;
    UIImageView *imageBaseView;
    UIButton *buttonY;
    UIButton *buttonPhoto;
    UIButton *buttonFollow;
    UIButton *buttonFollower;
    UILabel *photoCount;
    UILabel *followCount;
    UILabel *followerCount;
    __weak IBOutlet UITableView *timelineTable;
    NSMutableArray *timelineArray;

@private
    UIImage *image;
    ImageStore *imageStore_;
    UITableView *_tableView;

}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, retain) UILabel *photoCount;
@property (nonatomic, retain) UILabel *followCount;
@property (nonatomic, retain) UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UITableView *timelineTable;



@end
