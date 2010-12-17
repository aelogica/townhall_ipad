    //
//  SplashViewController.m
//  GenericTownHall
//
//  Created by David Ang on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"


@implementation SplashViewController

@synthesize splashImageView, splitViewController, timer;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	NSLog(@"loadview...");
	
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0,0,1034,778)];
	
	//view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	self.view = view;
	[view release];
	

	splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash.jpg"]];
	splashImageView.frame = CGRectMake(0, 0, 1034, 778);
	[self.view addSubview: splashImageView];
	[splashImageView release];
	
	UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];

    switch (orientation) {
        case UIInterfaceOrientationPortrait:		
			view.transform = CGAffineTransformMakeRotation(6.28f);
			splashImageView.frame = CGRectMake(0, 0, 778, 1034);
			view.frame = CGRectMake(0,0,778,1034);
			break;
        case UIInterfaceOrientationPortraitUpsideDown:
			view.transform = CGAffineTransformMakeRotation(3.14f);
			splashImageView.frame = CGRectMake(0, 0, 778, 1034);
			view.frame = CGRectMake(0,0,778,1034);
			break;
		case UIInterfaceOrientationLandscapeLeft:
			view.transform = CGAffineTransformMakeRotation(4.71f);
			break;
		case UIInterfaceOrientationLandscapeRight:
			view.transform = CGAffineTransformMakeRotation(1.57f);
            break;
    }
	
	
	//splitViewController = [[UISplitViewController alloc] initWithNibName:@"MainWindow" bundle:[NSBundle mainBundle]];
	//splitViewController.view.alpha = 0.0;
	//[self.view addSubview: [splitViewController view]];
	//timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target: self selector:@selector(fadeScreen) userInfo: nil repeats: NO];
}

-(void) fadeScreen {
	NSLog(@"SplashViewController::fadeScreen");
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration: 0.75];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector:@selector(finishedFading)];
	self.view.alpha = 0.0;
	[UIView commitAnimations];
}

-(void) finishedFading {
	NSLog(@"SplashViewController::finishedFading");
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration: 0.5];
	self.view.alpha = 1.0;
	splitViewController.view.alpha = 1.0;
	[UIView commitAnimations];	
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	NSLog(@"should autorotate");
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
