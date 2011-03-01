//
//  LoginDialog.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "LoginDialog.h"
#import "GenericTownHallAppDelegate.h"
#import "GTMHTTPFetcher.h"
#import "FBLoginButton.h"

@implementation LoginDialog


-(void) setupView:(id*)aModel {
	float padding = 10.f;
	
	UITextField *loginField = [[UITextField alloc] initWithFrame:CGRectMake(padding, 44.f + padding, self.frame.size.width - (padding * 2.f), 55.f)];
	[loginField setBorderStyle: UITextBorderStyleRoundedRect];
	[loginField setFont:[UIFont systemFontOfSize:40]];
	[loginField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[loginField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[loginField setPlaceholder:@"Enter your username"];
	[loginField setDelegate:self];
	[self addSubview:loginField];		
	[loginField release];
	
	UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(padding, loginField.frame.size.height + loginField.frame.origin.y + padding, self.frame.size.width - (padding * 2.f), 55.f)];
	[passwordField setBorderStyle: UITextBorderStyleRoundedRect];
	[passwordField setFont:[UIFont systemFontOfSize:40]];
	[passwordField setSecureTextEntry:YES];
	[passwordField setPlaceholder:@"Enter your password"];
	[passwordField setDelegate:self];
	[self addSubview:passwordField];		
	[passwordField release];
	
	FBLoginButton* fbButton = [[[FBLoginButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, passwordField.frame.size.height + passwordField.frame.origin.y + padding, 0 , 55.f)] autorelease];
	[self addSubview:fbButton];	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSLog(@"textFieldShouldReturn");
	
	[super rightButtonPressed:nil];
    return NO;
}

-(NSString *)getRequestUrl {
	return [NSString stringWithFormat:@"%@/account/authenticate?format=json", UIAppDelegate.serverBaseUrl];
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

- (void)postRequestHandler:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
	[super postRequestHandler:fetcher finishedWithData:retrievedData error:error];
	
	// Store incoming data into a string
	NSString *jsonString = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];
	
	// Create an array out of the returned json string
	NSArray *results = [jsonString JSONValue];
	if ([results count] > 10) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoginSuccess" object:nil userInfo:nil];
	} else {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"Invalid login credentials. Please try logging in again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[alert show];
	}
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
