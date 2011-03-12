//
//  GenericTownHallAppDelegate.h
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import <UIKit/UIKit.h>

#define UIAppDelegate \
	((GenericTownHallAppDelegate *)[UIApplication sharedApplication].delegate)

#define UIColorFromRGB(rgbValue) [UIColor \
	colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
	green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
	blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

CGFloat DegreesToRadians(CGFloat degrees);

enum {
	CategoriesView, TopicsView, QuestionsView, ResponsesView
};

@class MBProgressHUD;
@class SplashViewController;
@class RootViewController;
@class DetailViewController;

@interface GenericTownHallAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
    SplashViewController *splashViewController;
	RootViewController *rootViewController;
    DetailViewController *detailViewController;

	// Some "global" variables - if list becomes large, then it can be taken out and move to a singleton class or move it to a global file
	MBProgressHUD *progressHUD;
	NSString *serverBaseUrl;
	NSString *serverDataUrl;
	UIInterfaceOrientation currentOrientation;
	CGFloat appWidth;
	CGFloat appHeight;
	BOOL isLogin;
	NSUInteger currentView;
	NSString *currentBarButtonTitle;
	
	NSString *currentSlug;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) SplashViewController *splashViewController;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (readwrite, retain) MBProgressHUD * progressHUD;
@property (readwrite, retain) NSString * serverBaseUrl;
@property (readwrite, retain) NSString * serverDataUrl;
@property (nonatomic, assign) UIInterfaceOrientation currentOrientation;
@property (nonatomic, assign) CGFloat appWidth;
@property (nonatomic, assign) CGFloat appHeight;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) NSUInteger currentView;
@property (nonatomic, assign) NSString *currentBarButtonTitle;

@property (nonatomic, assign) NSString *currentSlug;

@end
