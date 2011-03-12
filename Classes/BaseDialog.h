//
//  BaseDialog.h
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@class GTMHTTPFetcher;

@interface BaseDialog : UIView {

	// Used in Question or Response dialogs
	id *model;
	UINavigationBar *navBar;
	UINavigationItem *navItem;
	UIView *dimmer;
}


- (void)rightButtonPressed: (id)sender;
- (void)leftButtonPressed: (id)sender;
- (void)doAppearAnimation: (UIWindow*)aWindow;
- (void)handleHttpResponse:(NSString*)responseString;

-(NSDictionary *)getRequestParameters;
-(NSString *)getRequestUrl;
-(NSString *)getDialogTitle;
-(NSString *)getRightButtonTitle;
-(NSString *)getLeftButtonTitle;
-(void) setupView:(id*)aModel;

@property(nonatomic, assign) id *model;

@end
