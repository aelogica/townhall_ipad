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
}

@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)NSMutableArray *items;


- (NSString*)getServiceUrl;
- (void)handleHttpResponse:(NSString*)responseString;


@end
