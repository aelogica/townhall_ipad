//
//  Response.m
//  TownHallServiceClient
//
//  Created by Marc Mercuri on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Response.h"


@implementation Response

@synthesize responseId = _responseId;
@synthesize body= _body;
@synthesize originator = _originator;

-(id)init {
    if (self = [super init]) {		
		_originator = [[Originator alloc]init];
    }
    return self;
}

-(void)dealloc{
	self.responseId = nil;
	self.body = nil;
	self.originator = nil;
	[super dealloc];
}
@end
