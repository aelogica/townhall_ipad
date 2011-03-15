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
#import "FBLoginButton.h"

@implementation LoginDialog


-(void) setupView:(id*)aModel {
	float padding = 10.f;
	isRegisteringNewUser = NO;
	
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
	
	FBLoginButton* fbButton = [[[FBLoginButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, passwordField.frame.size.height + passwordField.frame.origin.y + padding, 100 , 55.f)] autorelease];
	[fbButton updateImage];
	[fbButton addTarget:self action:@selector(fbLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:fbButton];	
	
	activityIndicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding + 80, passwordField.frame.size.height + passwordField.frame.origin.y + padding, 400 , 55.f)];
	[activityIndicatorLabel setBackgroundColor:[UIColor clearColor]];
	[activityIndicatorLabel setHidden:YES];
	[self addSubview:activityIndicatorLabel];
	
	_permissions =  [[NSArray arrayWithObjects:
                      @"read_stream", @"offline_access",nil] retain];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[super rightButtonPressed:nil];
    return NO;
}

- (void) fbLoginButtonPressed:(id)sender {	
  [UIAppDelegate.facebook authorize:_permissions delegate:self]; 	
}


#pragma mark FBSessionDelegate

/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	[UIAppDelegate.facebook requestWithGraphPath:@"me" andDelegate:self];

	[activityIndicatorLabel setText: @"Please wait while we try to log you in..."];
	[activityIndicatorLabel setHidden:NO];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}


#pragma mark FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"FBRequestDelegate didReceiveResponse: %@", response);
}


/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0];
	}
	
	UIAppDelegate.fbUser = result;
	NSLog(@"FB connect succeeded: %@", result);	
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/account/fbconnect?format=json", UIAppDelegate.serverBaseUrl]];
	NSLog(@"Making HTTP request: %@", url);		
	
	ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
	[asiRequest addRequestHeader:@"ApiKey" value: UIAppDelegate.serverApiKey];	
	[asiRequest addRequestHeader:@"fbApiKey" value: UIAppDelegate.fbApiKey];		
	[asiRequest addRequestHeader:@"fbIndentifier" value:[UIAppDelegate.fbUser objectForKey:@"id"]];			
	
	[asiRequest setDelegate:self];		
	[asiRequest setValidatesSecureCertificate:NO];
	[asiRequest startAsynchronous];		
};

- (NSString *) genRandomStringLength: (int) len {
	NSString *letters = @"abcdefghijklmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ123456789";	
	
	NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
	
	for (int i = 0; i < len; i++) {
		[randomString appendFormat: @"%c", [letters characterAtIndex: arc4random() % [letters length]]];
	}
	
	return randomString;
}

//- (void)requestFinished:(ASIHTTPRequest *)request {
//	
//	NSString *responseString = [request responseString];
//	NSLog(@"Http request succeeded: %@", responseString );	
//	
//	if ([responseString length] == 0 ) {
//		[self registeUserWithFbAccount];
//	} else {
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoginSuccess" object:nil userInfo:nil];
//		[super leftButtonPressed:nil];
//	}
//}

-(void) registeUserWithFbAccount {
	/*
	 curl -d "Username=test2&Email=test2@test.com&NewPassword=12345&ConfirmPassword=12345&PasswordQuestion=Best%20childhood%20friend&PasswordAnswer=Joe&avatar=avatar-1&Zone=Zone%201&FacebookIdentifier=1322439724&TermsOfUse=true" --insecure https://townhall2.cloudapp.net/account/register-adult/post?format=json\&ApiKey=6ad50a5a9b42848f65b63cc375ee3e92
	 curl -d "
	 Username=test2&
	 Email=test2@test.com&
	 NewPassword=12345&
	 ConfirmPassword=12345&
	 PasswordQuestion=Best%20childhood%20friend&
	 PasswordAnswer=Joe&
	 avatar=avatar-1&
	 Zone=Zone%201&
	 FacebookIdentifier=1322439724&
	 TermsOfUse=true" 
	 --insecure https://townhall2.cloudapp.net/account/register-adult/post?format=json\&ApiKey=6ad50a5a9b42848f65b63cc375ee3e92
	 */	

	ASIFormDataRequest *logoutRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/account/logoff", UIAppDelegate.serverDataUrl]]];
	[logoutRequest startSynchronous];
	
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/account/register-adult/post?format=json&ApiKey=%@", UIAppDelegate.serverBaseUrl, UIAppDelegate.serverApiKey]];
	NSLog(@"Making HTTP request: %@", url);			
	
	// Generate a timestamp for the email
	NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
	NSNumber *timeStampNumber = [NSNumber numberWithDouble: timeStamp];
	NSString *name = [UIAppDelegate.fbUser objectForKey:@"name"];
	NSString *username = [name stringByReplacingOccurrencesOfString:@" " withString:@"-"];
	NSString *password = [self genRandomStringLength:6];
	
	NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:
							  [UIAppDelegate.fbUser objectForKey:@"id"], @"FacebookIdentifier",
							  //password, @"FacebookIdentifier",
							  //[NSString stringWithFormat:@"%d", timeStampNumber], @"Username",
							  username, @"Username",
							  [NSString stringWithFormat:@"%d@fbconnect.com", timeStampNumber], @"Email",						  
							  password, @"NewPassword", 
							  password, @"ConfirmPassword",
							  @"Best childhood friend", @"PasswordQuestion", 
							  @"Joe", @"PasswordAnswer",
							  @"avatar-1", @"avatar",
							  @"Zone 1", @"Zone",
							  @"true", @"TermsOfUse",
							  nil];
	
	//__block ASIFormDataRequest *asiRequest = [ASIFormDataRequest requestWithURL:url];
	ASIFormDataRequest *asiRequest = [ASIFormDataRequest requestWithURL:url];
	
	NSEnumerator *enumerator = [postData keyEnumerator];
	id key;
	while (key = [enumerator nextObject]) {
		NSString *value = [postData objectForKey:key];	
		[asiRequest setPostValue:value forKey:key];
		NSLog(@"key:%@ val:%@", key, value);
	}	
	
	[asiRequest setDelegate:self];		
	[asiRequest setValidatesSecureCertificate:NO];
	
//	[asiRequest setCompletionBlock:^{
//		// Use when fetching text data
//		NSString *responseString = [asiRequest responseString];
//		
//		// Use when fetching binary data
//		NSData *responseData = [asiRequest responseData];
//		NSLog(@"block success");
//	}];
//	[asiRequest setFailedBlock:^{
//		NSError *error = [asiRequest error];
//		NSLog(@"block fail");
//	}];
	
	[asiRequest startAsynchronous];
	isRegisteringNewUser = YES;
	
	// Should move to handleHttpResponse so we can check for return result if successful.
	NSString *msg = [NSString stringWithFormat:@"We have created a new account for you at Townhall. Your temporary username is: %@. Your password is %@. You can now login with your townhall account on the site.", username, password];
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Welcome!" message: msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
	[alert show];
}


- (void)dialogDidComplete:(FBDialog *)dialog {
	NSLog(@"dialogDidComplete");
//	[self.label setText:@"publish successfully"];
}

-(NSString *)getRequestUrl {
	return [NSString stringWithFormat:@"%@/account/authenticate?format=json&ApiKey=%@", UIAppDelegate.serverBaseUrl, UIAppDelegate.serverApiKey];
}

-(NSDictionary *)getRequestParameters { 
	UITextField *loginField = (UITextField*)[self.subviews objectAtIndex:1];	
	UITextField *passwordField = (UITextField*)[self.subviews objectAtIndex:2];	
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
							[loginField text], @"username",
							[passwordField text], @"password", nil];
	return params;
}

-(NSString *)getDialogTitle {
	return @"Enter your login credentials";
}
-(NSString *)getRightButtonTitle {
	return @"Login";
}

- (void)handleHttpResponse:(NSString*)responseString {
  if ([responseString length] == 0 ) {	  
		[self registeUserWithFbAccount];
	} else {
		// Create an array out of the returned json string
		NSDictionary *results = [responseString JSONValue];
		if ([results count] > 10 || isRegisteringNewUser == YES) {			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoginSuccess" object:nil userInfo:nil];
		} else {
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"Invalid login credentials. Please try logging in again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
			[alert show];
		}
	}
}

//- (void)postRequestHandler:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
//	[super postRequestHandler:fetcher finishedWithData:retrievedData error:error];
//	
//	// Store incoming data into a string
//	NSString *jsonString = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];	
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	NSLog(@"LoginDialog dealloc");
	[activityIndicatorLabel release];
    [super dealloc];
}


@end
