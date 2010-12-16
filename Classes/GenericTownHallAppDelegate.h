//
//  GenericTownHallAppDelegate.h
//  GenericTownHall
//
//  Created by David Ang on 12/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIAppDelegate \
	((GenericTownHallAppDelegate *)[UIApplication sharedApplication].delegate)

#define UIColorFromRGB(rgbValue) [UIColor \
	colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
	green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
	blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@class MBProgressHUD;
@class RootViewController;
@class DetailViewController;

@interface GenericTownHallAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
    RootViewController *rootViewController;
    DetailViewController *detailViewController;

	// Some "global" variables - if list becomes large, then it can be taken out and move to a singleton class or move it to a global file
	MBProgressHUD *progressHUD;
	NSString *serverBaseUrl;
	NSString *serverDataUrl;	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (readwrite, retain) MBProgressHUD * progressHUD;
@property (readwrite, retain) NSString * serverBaseUrl;
@property (readwrite, retain) NSString * serverDataUrl;

@end
