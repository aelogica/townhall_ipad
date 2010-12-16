//
//  GenericTownHallAppDelegate.m
//  GenericTownHall
//
//  Created by David Ang on 12/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "GenericTownHallAppDelegate.h"


#import "RootViewController.h"
#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "globals.h"


@implementation GenericTownHallAppDelegate

@synthesize window, splitViewController, rootViewController, detailViewController, progressHUD, serverBaseUrl, serverDataUrl;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch.
	NSLog(@"Application started.");
	
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *plistPath = [bundle pathForResource:@"configs" ofType:@"plist"];
	NSDictionary *plistData = [[NSDictionary dictionaryWithContentsOfFile:plistPath] retain];
	
	serverBaseUrl = [plistData objectForKey:@"ServerBaseUrl"];
	serverDataUrl = [plistData objectForKey:@"ServerDataUrl"];
	NSLog(@"Server Base URL set to: %@ Data URL set to: %@", serverBaseUrl, serverDataUrl);
    
    // Add the split view controller's view to the window and display.
    [window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
	
	progressHUD = [[MBProgressHUD alloc] initWithWindow: window];
	progressHUD.delegate = self;
	[window addSubview:progressHUD];
	progressHUD.center = CGPointMake(384,512);		
    
	
    return YES;
}

-(void) hudWasHidden {
	// do nothing
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[progressHUD removeFromSuperview];
	[progressHUD release];
	
    [splitViewController release];
    [window release];
    [super dealloc];
}


@end

