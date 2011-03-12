//
//  BaseViewController.h
//  GenericTownHall
//
//  Created by David Ang on 3/11/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "GenericTownHallAppDelegate.h"
#import "ASIHTTPRequest.h"


@interface BaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
	NSMutableArray *items;
	UITableView *tableView;
	
	UIView *headerView;
	UIToolbar *toolbar;
}


- (void) makeHttpRequest;

// Additional init methods
- (void) addTableView:(UITableViewStyle)aStyle;
- (void) addHeader;

// Polymorphic methods
- (NSString*)getServiceUrl;
- (NSString*)getExtraParams;
- (void)handleHttpResponse:(NSString*)responseString;


@property(nonatomic, retain) UIView *headerView;
@property(nonatomic, retain) UIToolbar *toolbar;
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain)  NSMutableArray *items;


@end
