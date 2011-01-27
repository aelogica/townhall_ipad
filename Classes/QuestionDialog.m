//
//  InputDialog.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "QuestionDialog.h"
#import <QuartzCore/QuartzCore.h>
#import "GenericTownHallAppDelegate.h"
#import "GTMHTTPFetcher.h"
#import "Topic.h"

@implementation QuestionDialog

@synthesize category, topic;

-(void) setupView:(id*)aModel {
	topic = (Topic*)aModel;
	
	float padding = 10.f;
	float navbarHeight = 44.f;
	
	CGSize size = [topic.description sizeWithFont:[UIFont systemFontOfSize:14.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];
	CGRect nameFrame = CGRectMake(padding, navbarHeight + padding, self.frame.size.width - (padding * 2.f), 30.f);
	CGRect bodyFrame = CGRectMake(padding, navbarHeight + nameFrame.size.height + padding, self.frame.size.width - (padding * 2.f), size.height);
	
	UILabel *name = [[UILabel alloc] initWithFrame:nameFrame];
	name.text = [NSString stringWithFormat:@"Adding question to: %@", topic.name];
	name.font = [UIFont systemFontOfSize:22.f];
	[name setBackgroundColor:[UIColor clearColor]];	
	[self addSubview:name];
	[name release];
	
	UILabel *body = [[UILabel alloc] initWithFrame:bodyFrame];
	body.numberOfLines = 0;
	body.lineBreakMode = UILineBreakModeWordWrap;
	body.text = topic.description;
	body.font = [UIFont systemFontOfSize:22.f];
	[body setBackgroundColor:[UIColor clearColor]];
	//[self addSubview:body];
	[body release];
	
	// Create textview and put right after the table view
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(padding, bodyFrame.origin.y + bodyFrame.size.height + padding, self.frame.size.width - (padding * 2.f), 140.f)];
	[textView setBackgroundColor: UIColorFromRGB(0x87CEFA)];
	[textView setFont:[UIFont systemFontOfSize:20]];
	[textView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
	[textView.layer setBorderColor: [[UIColor grayColor] CGColor]];
	[textView.layer setBorderWidth: 1.f];
	[textView.layer setCornerRadius:8.f];
	[textView.layer setMasksToBounds:YES];
	
	[self addSubview:textView];
	[textView release];
	
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(padding, textView.frame.size.height + textView.frame.origin.y + padding, self.frame.size.width - (padding * 2.f), 35.f)];
	[textField setFont:[UIFont systemFontOfSize:20]];
	[textField setBorderStyle: UITextBorderStyleRoundedRect];
	[textField setPlaceholder:@"Enter tags for this question"];
	[self addSubview:textField];
	[textField release];
}

- (NSString *)urlEncodeValue:(NSString *)str {
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
	return [result autorelease];
}

-(NSString *)getRequestUrl {
	return [NSString stringWithFormat:@"%@/questions/in/%@/create/post", UIAppDelegate.serverDataUrl, topic.slug];
}

-(NSString *)getRequestParameters { 
	UITextView *textView = (UITextView*)[self.subviews objectAtIndex:2];
	UITextField *textField = (UITextField*)[self.subviews objectAtIndex:3];	

	return [NSString stringWithFormat:@"Body=%@&TagsCommaSeparated=%@&CategorySlug=%@", [self urlEncodeValue:[textView text]], [self urlEncodeValue:[textField text]], topic.slug];
}

	
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	NSLog(@"QustionDialog dealloc");
    [super dealloc];
}


@end
