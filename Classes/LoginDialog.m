//
//  LoginDialog.m
//  GenericTownHall
//
//  Created by David Ang on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginDialog.h"
#import "GenericTownHallAppDelegate.h"
#import "GTMHTTPFetcher.h"

@implementation LoginDialog


-(void) setupView:(id*)aModel {
	float padding = 10.f;
	
	UITextField *loginField = [[UITextField alloc] initWithFrame:CGRectMake(padding, 44.f + padding, self.frame.size.width - (padding * 2.f), 30.f)];
	[loginField setBorderStyle: UITextBorderStyleRoundedRect];
	[loginField setPlaceholder:@"Enter your username"];
	[self addSubview:loginField];		
	[loginField release];
	
	UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(padding, loginField.frame.size.height + loginField.frame.origin.y + padding, self.frame.size.width - (padding * 2.f), 30.f)];
	[passwordField setBorderStyle: UITextBorderStyleRoundedRect];
	[passwordField setPlaceholder:@"Enter your password"];
	[self addSubview:passwordField];		
	[passwordField release];
	
}

-(NSString *)getRequestUrl {
	return [NSString stringWithFormat:@"%@/account/authenticate?format=xml", UIAppDelegate.serverBaseUrl];
}

-(NSString *)getRequestParameters { 
	UITextField *loginField = (UITextField*)[self.subviews objectAtIndex:1];	
	UITextField *passwordField = (UITextField*)[self.subviews objectAtIndex:2];	
	
	return [NSString stringWithFormat:@"username=%@&password=%@", [loginField text], [passwordField text]];
}

-(NSString *)getDialogTitle {
	return @"Enter your login credentials";
}
-(NSString *)getRightButtonTitle {
	return @"Login";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	NSLog(@"LoginDialog dealloc");
    [super dealloc];
}


@end
