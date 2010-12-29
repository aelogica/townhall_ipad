//
//  BaseDialog.h
//  GenericTownHall
//
//  Created by David Ang on 12/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTMHTTPFetcher;

@interface BaseDialog : UIView {

	// Used in Question or Response dialogs
	id *model;
	UINavigationBar *navBar;
	UINavigationItem *navItem;
	
}


- (void)rightButtonPressed: (id)sender;
- (void)leftButtonPressed: (id)sender;
- (void)postRequestHandler:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error;

-(NSString *)getRequestParameters;
-(NSString *)getRequestUrl;
-(NSString *)getDialogTitle;
-(NSString *)getRightButtonTitle;
-(NSString *)getLeftButtonTitle;
-(void) setupView:(id*)aModel;

@property(nonatomic, assign) id *model;

@end
