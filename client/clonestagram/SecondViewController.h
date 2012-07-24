//
//  SecondViewController.h
//  clonestagram
//
//  Created by face-do on 12/07/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UIWebViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    IBOutlet UIView *cameraview;
    IBOutlet UIBarButtonItem *cameraCancel;
    IBOutlet UIImageView *_imageView;
    IBOutlet UIBarButtonItem *selectCancel;
    IBOutlet UIBarButtonItem *sendButton;
    IBOutlet UIButton *nomalFilter;
    IBOutlet UIButton *amaroFilter;
    IBOutlet UIButton *riseFilter;
    IBOutlet UIButton *hudsonFilter;
    IBOutlet UIButton *darkFilter;
    IBOutlet UIImageView *amaroView;
    IBOutlet UIImageView *basedImageView;
    IBOutlet UIImageView *riseView;
    IBOutlet UIImageView *hudsonView;
    IBOutlet UIImageView *darkView;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *_imageView;
- (IBAction)sendButton:(id)sender;
- (IBAction)cameraCancel:(id)sender;
- (IBAction)selectCancel:(id)sender;
- (IBAction)nomalFilter:(id)sender;
- (IBAction)amaroFilter:(id)sender;
- (IBAction)riseFilter:(id)sender;
- (IBAction)hudsonFilter:(id)sender;
- (IBAction)darkFilter:(id)sender;
- (void)hideTabBar;

@end
