//
//  BaseDialog.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "BaseDialog.h"
#import "GenericTownHallAppDelegate.h"

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
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification object:nil];
		

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
	NSDictionary *postData = [self getRequestParameters];  ;	
	NSURL *url = [NSURL URLWithString:[self getRequestUrl]];
	NSLog(@"Making HTTP request: %@", url);	

	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

	NSEnumerator *enumerator = [postData keyEnumerator];
	id key;
	while (key = [enumerator nextObject]) {
		NSString *value = [postData objectForKey:key];	
		[request setPostValue:value forKey:key];
	}	

	//[request setPostLength:[postData length]];
	
	[request setDelegate:self];		
	[request setValidatesSecureCertificate:NO];
	[request startAsynchronous];
	
//	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//	[appDelegate.progressHUD showUsingAnimation:YES];   
}


- (void)requestFinished:(ASIHTTPRequest *)request {
	// Use when fetching text data
	NSString *responseString = [request responseString];
	NSLog(@"Http request succeeded: %@", responseString);	

	// Verify responseString contains any characters
	if ([responseString length] > 0) {
		// Create an array out of the returned json string
		id *results = [responseString JSONValue];
		
		if ([results isKindOfClass:[NSArray class]] || [results isKindOfClass:[NSDictionary class]])  { 
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector: @selector(cancelAnimationDidStop:finished:context:)];
			[UIView setAnimationDuration:.7f];	
			[self setAlpha:0.f];
			[UIView commitAnimations];
		} else {
	//		NSLog(@"Http request result bad data: %@", responseString);
	//	    
	//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message: @"We apologize but there has been an error on our server. Would you try again a little later our programmers are working hard to fix the error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];            
	//		[alert show];
	//		[alert release];

		}
	}
	
	// Let any child class handle the responeString
	[self handleHttpResponse:responseString];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	
	NSLog(@"Http request failed: %@ Count: %d", error);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message: @"We apologize but there has been an error on our server. Would you try again a little later our programmers are working hard to fix the error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];            
	[alert show];
	[alert release];	
}

- (void)handleHttpResponse:(NSString*)responseString {
	// Do nothing let implementation child classes handle this case
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
		
- (void)keyboardWillShow:(NSNotification*)aNotification
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
	
	UIDeviceOrientation aorientation = [[UIDevice currentDevice] orientation];
    switch (aorientation) {
		case UIInterfaceOrientationLandscapeLeft:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeTranslation(0.f, -150.f), CGAffineTransformMakeRotation(DegreesToRadians(270)))];
			break;
		case UIInterfaceOrientationLandscapeRight:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeTranslation(0.f, -150.f), CGAffineTransformMakeRotation(DegreesToRadians(90)))];
            break;
    }	
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification*)aNotification {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view

	UIDeviceOrientation aorientation = [[UIDevice currentDevice] orientation];
    switch (aorientation) {
		case UIInterfaceOrientationLandscapeLeft:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeTranslation(0.f, 0.f), CGAffineTransformMakeRotation(DegreesToRadians(270)))];
			break;
		case UIInterfaceOrientationLandscapeRight:
			[self setTransform: CGAffineTransformConcat(CGAffineTransformMakeTranslation(0.f, 0.f), CGAffineTransformMakeRotation(DegreesToRadians(90)))];
            break;
    }	
    [UIView commitAnimations];
}
				   
				   
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	NSLog(@"BaseDialog dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}


@end
