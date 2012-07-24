//
//  SecondViewController.m
//  clonestagram
//
//  Created by face-do on 12/07/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import <CoreImage/CoreImage.h>
#import "R9HTTPRequest.h"
#import "SBJson.h"

@implementation SecondViewController
@synthesize _imageView;
BOOL hiddenTabBar;
dispatch_once_t onceToken;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    cameraCancel = nil;
    selectCancel = nil;
    sendButton = nil;
    nomalFilter = nil;
    amaroFilter = nil;
    riseFilter = nil;
    hudsonFilter = nil;
    darkFilter = nil;
    amaroView = nil;
    riseView = nil;
    hudsonView = nil;
    basedImageView = nil;
    _imageView = nil;
    darkView = nil;
    [super viewDidUnload];
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    UIImagePickerController*    imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    
    UIImagePickerControllerSourceType   sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.sourceType = sourceType;
    } else {
        imagePicker.sourceType = sourceType;
        imagePicker.cameraOverlayView = cameraview;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        
    }
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    // show imagepicker
    [self presentModalViewController:imagePicker animated:NO];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissModalViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 0;
}
- (IBAction)cameraCancel:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 0;
}

- (IBAction)selectCancel:(id)sender {
    [self hideTabBar];
    
    UIImagePickerController*    imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    
    UIImagePickerControllerSourceType   sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.sourceType = sourceType;
    } else {
        imagePicker.sourceType = sourceType;
        imagePicker.cameraOverlayView = cameraview;
        
    }
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    // show imagepicker
    [self presentModalViewController:imagePicker animated:NO];
    
}


- (IBAction)nomalFilter:(id)sender {
    _imageView.image = basedImageView.image;
}

- (IBAction)amaroFilter:(id)sender {
    if (amaroView.image == nil) {
        
        CIImage *ciImage3 = [[CIImage alloc] initWithImage:basedImageView.image];  
        
        CIFilter *gammaAdjust = [CIFilter filterWithName:@"CIGammaAdjust"];
        [gammaAdjust setDefaults];
        [gammaAdjust setValue: ciImage3 forKey: @"inputImage"];
        [gammaAdjust setValue: [NSNumber numberWithFloat: 0.5f]
                       forKey: @"inputPower"];
        CIContext *ciContext3 = [CIContext contextWithOptions:nil];  
        
        CGImageRef cgimg3 = [ciContext3 createCGImage:[gammaAdjust outputImage] fromRect:[[gammaAdjust outputImage] extent]];
        UIImage* tmpImage3 = [UIImage imageWithCGImage:cgimg3 scale:1.0f orientation:UIImageOrientationUp];  
        CGImageRelease(cgimg3);
        
        CIImage *ciImage = [[CIImage alloc] initWithImage:tmpImage3];  
        
        CIFilter *ciFilter = [CIFilter filterWithName:@"CIColorControls" //filter name
                                        keysAndValues:kCIInputImageKey, ciImage,
                              @"inputSaturation", [NSNumber numberWithFloat:1.2], //paramater
                              @"inputBrightness", [NSNumber numberWithFloat:0.5], //paramater
                              @"inputContrast", [NSNumber numberWithFloat:1.0], //paramater
                              nil];
        CIContext *ciContext = [CIContext contextWithOptions:nil];  
        CGImageRef cgimg = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
        UIImage* tmpImage = [UIImage imageWithCGImage:cgimg scale:1.0f orientation:UIImageOrientationUp]; 
        
        CIImage *ciImage2 = [[CIImage alloc] initWithImage:tmpImage];      
        CIFilter *filter = [CIFilter filterWithName:@"CIVignette"]; 
        [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
        [filter setValue:ciImage2 forKey:@"inputImage"];
        ciImage2 = filter.outputImage;
        
        CIContext *ciContext2 = [CIContext contextWithOptions:nil];
        CGImageRef imageRef2 = [ciContext2 createCGImage:ciImage2 fromRect:[ciImage2 extent]];
        UIImage *outputImage  = [UIImage imageWithCGImage:imageRef2 scale:1.0f orientation:UIImageOrientationUp];
        CGImageRelease(imageRef2);
        
        amaroView.image = outputImage;
    }
    
    _imageView.image = amaroView.image;  
}

- (IBAction)riseFilter:(id)sender {
    if (riseView.image == nil) {
        CIImage *ciImage = [[CIImage alloc] initWithImage:basedImageView.image];  
        CIFilter *ciFilter = [CIFilter filterWithName:@"CIColorControls" //filter name
                                        keysAndValues:kCIInputImageKey, ciImage,
                              @"inputSaturation", [NSNumber numberWithFloat:1.0], //paramater
                              @"inputBrightness", [NSNumber numberWithFloat:0.5], //paramater
                              @"inputContrast", [NSNumber numberWithFloat:3.0], //paramater
                              nil];
        CIContext *ciContext = [CIContext contextWithOptions:nil];  
        CGImageRef cgimg = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];  
        UIImage* tmpImage = [UIImage imageWithCGImage:cgimg scale:1.0f orientation:UIImageOrientationUp];  
        CGImageRelease(cgimg);
        riseView.image = tmpImage;
    }
    
    _imageView.image = riseView.image;
}

- (IBAction)hudsonFilter:(id)sender {
    if (hudsonView.image == nil) {
        CIImage *ciImage = [[CIImage alloc] initWithImage:basedImageView.image];  
        
        CIFilter *ciFilter = [CIFilter filterWithName:@"CIColorControls" //filter name
                                        keysAndValues:kCIInputImageKey, ciImage,
                              @"inputSaturation", [NSNumber numberWithFloat:1.2], //paramater
                              @"inputBrightness", [NSNumber numberWithFloat:0.1], //paramater
                              @"inputContrast", [NSNumber numberWithFloat:1.0], //paramater
                              nil];
        CIContext *ciContext = [CIContext contextWithOptions:nil];  
        CGImageRef cgimg = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];  
        UIImage* tmpImage = [UIImage imageWithCGImage:cgimg scale:1.0f orientation:UIImageOrientationUp];  
        CGImageRelease(cgimg);
        
        CIImage *ciImage3 = [[CIImage alloc] initWithImage:tmpImage];  
        
        CIFilter *colorfilter = [CIFilter filterWithName:@"CIFalseColor" //filter
                                           keysAndValues:kCIInputImageKey, ciImage3,
                                 @"inputColor0", [CIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1], //paramater
                                 nil];
        CGImageRef cgimg3 = [ciContext createCGImage:[colorfilter outputImage] fromRect:[[colorfilter outputImage] extent]];
        UIImage* tmpImage3 = [UIImage imageWithCGImage:cgimg3 scale:1.0f orientation:UIImageOrientationUp];  
        CGImageRelease(cgimg3);
        
        
        CIImage *ciImage2 = [[CIImage alloc] initWithImage:tmpImage3];  
        
        CIFilter *gammaAdjust = [CIFilter filterWithName:@"CIGammaAdjust"];
        [gammaAdjust setDefaults];
        [gammaAdjust setValue: ciImage2 forKey: @"inputImage"];
        [gammaAdjust setValue: [NSNumber numberWithFloat: 0.5f]
                       forKey: @"inputPower"];
        CGImageRef cgimg2 = [ciContext createCGImage:[gammaAdjust outputImage] fromRect:[[gammaAdjust outputImage] extent]];
        UIImage* tmpImage2 = [UIImage imageWithCGImage:cgimg2 scale:1.0f orientation:UIImageOrientationUp];  
        CGImageRelease(cgimg2);
        
        
        CIImage *ciImage4 = [[CIImage alloc] initWithImage:tmpImage2];  
        
        CIFilter *contrast = [CIFilter filterWithName:@"CIColorControls" //filter name
                                        keysAndValues:kCIInputImageKey, ciImage4,
                              @"inputContrast", [NSNumber numberWithFloat:1.0], //paramater
                              @"inputContrast", [NSNumber numberWithFloat:1.0], //paramater
                              nil];
        CGImageRef cgimg4 = [ciContext createCGImage:[contrast outputImage] fromRect:[[contrast outputImage] extent]];
        UIImage* tmpImage4 = [UIImage imageWithCGImage:cgimg4 scale:0.5f orientation:UIImageOrientationUp];  
        CGImageRelease(cgimg4);
        hudsonView.image = tmpImage4;
    }
    
    _imageView.image = hudsonView.image;
    
}

- (IBAction)darkFilter:(id)sender {
    if (darkView.image == nil) {
        
        CIImage *ciImage = [[CIImage alloc] initWithImage:basedImageView.image];  
        
        CIFilter *ciFilter = [CIFilter filterWithName:@"CIToneCurve"
                                        keysAndValues:kCIInputImageKey, ciImage,
                              @"inputPoint0", [CIVector vectorWithX:0.0 Y:0.0],
                              @"inputPoint1", [CIVector vectorWithX:0.25 Y:0.1],
                              @"inputPoint2", [CIVector vectorWithX:0.5 Y:0.5],
                              @"inputPoint3", [CIVector vectorWithX:0.75 Y:0.9],
                              @"inputPoint4", [CIVector vectorWithX:1 Y:1],
                              nil];
        CIContext *ciContext = [CIContext contextWithOptions:nil];  
        CGImageRef cgimg = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];  
        UIImage* tmpImage = [UIImage imageWithCGImage:cgimg scale:1.0f orientation:UIImageOrientationUp];  
        CGImageRelease(cgimg);
        darkView.image = tmpImage;
        
    }
    _imageView.image = darkView.image;
    
}

- (void)imagePickerController:(UIImagePickerController*)picker 
        didFinishPickingImage:(UIImage*)image 
                  editingInfo:(NSDictionary*)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
    
    
    UIImage* imageOriginal = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
    
    UIGraphicsBeginImageContext(imageOriginal.size);  
    [imageOriginal drawInRect:CGRectMake(0, 0, imageOriginal.size.width, imageOriginal.size.height)];  
    imageOriginal = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();
    
    CGRect cropRect;
    [[editingInfo objectForKey:UIImagePickerControllerCropRect] getValue:&cropRect];
    CGImageRef imageRef = CGImageCreateWithImageInRect(imageOriginal.CGImage, cropRect);
    UIImage *imageCropped =[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    NSLog(@"%f", imageCropped.size.width);
    
    UIGraphicsBeginImageContext(CGSizeMake(600, 600));
    [imageCropped drawInRect:CGRectMake(0, 0, 600, 600)];
    imageCropped = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _imageView.image = imageCropped;
    basedImageView.image = imageCropped;
    
    [self hideTabBar];
    
    NSLog(@"フィルタ完了");
    _imageView.hidden = NO;
    [self dismissModalViewControllerAnimated:NO];
}


- (IBAction)sendButton:(id)sender {
    
    NSLog(@"sending...");
    
    NSLog(@"url");
    
    NSURL *URL = [NSURL URLWithString:@"http://YOUR_SERVER_DOMAIN/entries.json"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    
    [request setHTTPMethod:@"POST"];
    
    NSData *pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation(_imageView.image)];
    // set image data
    [request setData:pngData withFileName:@"sample.png" andContentType:@"image/png" forKey:@"entry[avatar]"];
    
    [request setCompletionHandler:^(NSHTTPURLResponse *responseHeader, NSString *responseString){
        NSLog(@"%d", [[NSThread currentThread] isMainThread] == YES);
        NSDictionary *result = [responseString JSONValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"P1" object:self userInfo:result];
        NSLog(@"result:%@", result);        
    }];
    
    // Progress
    [request setUploadProgressHandler:^(float newProgress){
        NSLog(@"%g", newProgress);
        
        NSString *sv = [NSString stringWithFormat:@"%f",newProgress];
        
        NSDictionary *dic1 = [NSDictionary dictionaryWithObject:sv forKey:@"KEY1"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"P3" object:self userInfo:dic1];
    }];
    
    //failed
    [request setFailedHandler:^(NSError *error){
        NSLog(@"error");
        NSLog(@"send error: %@", error);
    }];
    
    [request startRequest];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:_imageView forKey:@"KEY1"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"P2" object:self userInfo:dic];
    [self hideTabBar];
    
    self.tabBarController.selectedIndex = 0;
}

- (void)hideTabBar {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0];
    for(UIView *view in self.tabBarController.view.subviews)
    {
        CGRect _rect = view.frame;
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hiddenTabBar) {
                _rect.origin.y = 431;
                [view setFrame:_rect];
            } else {
                _rect.origin.y = 480;
                [view setFrame:_rect];
            }
        } else {
            if (hiddenTabBar) {
                _rect.size.height = 431;
                [view setFrame:_rect];
            } else {
                _rect.size.height = 480;
                [view setFrame:_rect];
            }
        }
    }
    [UIView commitAnimations];
    
    hiddenTabBar = !hiddenTabBar;
    
}

@end
