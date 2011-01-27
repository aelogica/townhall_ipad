//
//  ResponseDialog.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "ResponseDialog.h"
#import "GenericTownHallAppDelegate.h"
#import "GTMHTTPFetcher.h"
#import "Question.h"
#import <QuartzCore/QuartzCore.h>

@implementation ResponseDialog

@synthesize question;

-(void) setupView:(id*)aModel {
	question = (Question*)aModel;
	
	float padding = 10.f;
	float navbarHeight = 44.f;
	
	CGSize size = [question.body sizeWithFont:[UIFont systemFontOfSize:14.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];
	CGRect nameFrame = CGRectMake(padding, navbarHeight + padding, self.frame.size.width - (padding * 2.f), 40.f);
	CGRect bodyFrame = CGRectMake(padding, navbarHeight + nameFrame.size.height + padding, self.frame.size.width - (padding * 2.f), size.height);
	
	UILabel *name = [[UILabel alloc] initWithFrame:nameFrame];
	name.text = [NSString stringWithFormat:@"Adding response to: %@", question.subject];
	name.font = [UIFont systemFontOfSize:24.f];		
	[name setBackgroundColor:[UIColor clearColor]];
	[self addSubview:name];
	[name release];
	
	UILabel *body = [[UILabel alloc] initWithFrame:bodyFrame];
	body.numberOfLines = 0;
	body.lineBreakMode = UILineBreakModeWordWrap;
	body.text = question.body;
	body.font = [UIFont systemFontOfSize:18.f];
	//[self addSubview:body];
	[body release];		
	
	// Create textview and put right after the table view
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(padding, nameFrame.origin.y + nameFrame.size.height + padding, self.frame.size.width - (padding * 2.f), 140.f)];
	[textView setBackgroundColor: UIColorFromRGB(0x87CEFA)];
	[textView setFont:[UIFont systemFontOfSize:22.f]];
	[textView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
	[textView.layer setBorderColor: [[UIColor grayColor] CGColor]];
	[textView.layer setBorderWidth: 1.f];
	[textView.layer setCornerRadius:8.f];
	[textView.layer setMasksToBounds:YES];
	
	[self addSubview:textView];
	[textView release];		
}

-(NSString *)getRequestUrl {
	return [NSString stringWithFormat:@"%@/responses/for/%@/create", UIAppDelegate.serverDataUrl, question.nuggetId];
}

-(NSString *)getRequestParameters { 
	UITextView *textView = (UITextView*)[self.subviews objectAtIndex:2];
	
	return [NSString stringWithFormat:@"body=%@", [textView text]];
}

-(NSString *)getDialogTitle {
	return @"Add your response";
}
-(NSString *)getRightButtonTitle {
	return @"Send";
}
-(NSString *)getLeftButtonTitle {
	return @"Cancel";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
