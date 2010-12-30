//
//  BaseDialog.m
//  GenericTownHall
//
//  Created by David Ang on 12/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "BaseDialog.h"
#import "GenericTownHallAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "GTMHTTPFetcher.h"

@implementation BaseDialog

@synthesize model;


CGFloat DegreesToRadians2(CGFloat degrees)
{
	return degrees * M_PI / 180;
};

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		[self setBackgroundColor:UIColorFromRGB(0xEEEEEE)];
		//[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		
        // Initialization code.
		navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, 44.f)];		
		
		navItem = [[UINavigationItem alloc] initWithTitle:[self getDialogTitle]];
		//navItem.hidesBackButton = YES;
		navItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:[self getRightButtonTitle] style:UIBarButtonSystemItemDone target:self action:@selector(rightButtonPressed:)] autorelease];
		navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:[self getLeftButtonTitle] style:UIBarButtonSystemItemDone target:self action:@selector(leftButtonPressed:)] autorelease];
		[navBar pushNavigationItem:navItem animated:NO];
		
		[navItem release];
		
		
		[self addSubview:navBar];
		[navBar release];
		
		// Listen to orientaton changes
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:@"OrientationChange" object:nil]; 

    }
    return self;
}

- (void)doAppearAnimation: (UIWindow*)aWindow {
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

	// Initialize our dimmer view
	dimmer = [[UIView alloc] initWithFrame:CGRectMake(.0f,0.f,768.f,1024.f)];
	[dimmer setBackgroundColor:[UIColor blackColor]];
	[dimmer setAlpha:0.f];
	[aWindow addSubview:dimmer];
	
	[self setCenter:aWindow.center];
	[self setAlpha:0.f];
	
	switch (appDelegate.currentOrientation) {
        case UIInterfaceOrientationPortrait:		
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(.2f, .2f), CGAffineTransformMakeRotation(DegreesToRadians(180)))];
			break;
        case UIInterfaceOrientationPortraitUpsideDown:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(.2f, .2f), CGAffineTransformMakeRotation(DegreesToRadians(360)))];
			break;
		case UIInterfaceOrientationLandscapeLeft:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(.2f, .2f), CGAffineTransformMakeRotation(DegreesToRadians(90)))];
			break;
		case UIInterfaceOrientationLandscapeRight:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(.2f, .2f), CGAffineTransformMakeRotation(DegreesToRadians(270)))];
            break;
    }
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.7f];
	[dimmer setAlpha:0.5f];	
	[self setAlpha:1.f];
	switch (appDelegate.currentOrientation) {
        case UIInterfaceOrientationPortrait:		
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(1.f, 1.f), CGAffineTransformMakeRotation(DegreesToRadians(360)))];
			break;
        case UIInterfaceOrientationPortraitUpsideDown:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(1.f, 1.f), CGAffineTransformMakeRotation(DegreesToRadians(180)))];
			break;
		case UIInterfaceOrientationLandscapeLeft:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(1.f, 1.f), CGAffineTransformMakeRotation(DegreesToRadians(270)))];
			break;
		case UIInterfaceOrientationLandscapeRight:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(1.f, 1.f), CGAffineTransformMakeRotation(DegreesToRadians(90)))];
            break;
    }
	
	[UIView commitAnimations];
	
	[dimmer release];
	
}

-(void)orientationChange:(NSNotification *)orientation { 
	NSString *o = (NSString *)[orientation object];
	
	UIDeviceOrientation aorientation = [[UIDevice currentDevice] orientation];
    switch (aorientation) {
        case UIInterfaceOrientationPortrait:		
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(1.f, 1.f), CGAffineTransformMakeRotation(DegreesToRadians(360)))];
			break;
        case UIInterfaceOrientationPortraitUpsideDown:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(1.f, 1.f), CGAffineTransformMakeRotation(DegreesToRadians(180)))];
			break;
		case UIInterfaceOrientationLandscapeLeft:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(1.f, 1.f), CGAffineTransformMakeRotation(DegreesToRadians(270)))];
			break;
		case UIInterfaceOrientationLandscapeRight:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(1.f, 1.f), CGAffineTransformMakeRotation(DegreesToRadians(90)))];
            break;
    }	
}

				   
- (void)rightButtonPressed: (id)sender {
   NSURL *url = [NSURL URLWithString: [self getRequestUrl]];	
   NSLog(@"Posting to Url: %@", url);
   
   
   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
   
   NSString *post = [self getRequestParameters];  
   NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];	
   NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
   
   [request setValue:postLength forHTTPHeaderField:@"Content-length"];
   [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
   
   [request setHTTPMethod:@"POST"];
   [request setHTTPBody: postData];
   
   GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
   [myFetcher beginFetchWithDelegate:self didFinishSelector:@selector(postRequestHandler:finishedWithData:error:)];	   
}
				   
				   
- (void)leftButtonPressed: (id)sender {	
   [UIView beginAnimations:nil context:nil];
   [UIView setAnimationDelegate:self];
   [UIView setAnimationDidStopSelector: @selector(cancelAnimationDidStop:finished:context:)];
   [UIView setAnimationDuration:.7f];	
   [self setAlpha:0.f];
   [UIView commitAnimations];	
}

- (void)cancelAnimationDidStop:(NSString*) animationID finished:(NSNumber*) finished context:(void*) context {
   [self removeFromSuperview];
   
   	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.3f];
	[dimmer setAlpha:.0f];	
	[UIView commitAnimations];	
}

- (void)postRequestHandler:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
   [UIView beginAnimations:nil context:nil];
   [UIView setAnimationDelegate:self];
   [UIView setAnimationDidStopSelector: @selector(cancelAnimationDidStop:finished:context:)];
   [UIView setAnimationDuration:.7f];	
   [self setAlpha:0.f];
   [UIView commitAnimations];
}
				   
// defaults

-(NSString *)getDialogTitle {
	return @"Add your question";
}
-(NSString *)getRightButtonTitle {
	return @"Send";
}
-(NSString *)getLeftButtonTitle {
	return @"Cancel";
}
				   
				   
				   
				   
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
