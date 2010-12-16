//
//  Topic.m
//  TownHallServiceClient
//
//  Created by Marc Mercuri on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Topic.h"


@implementation Topic

@synthesize topicId = _topicId;
@synthesize name= _name;
@synthesize slug = _slug;
@synthesize description = _description;
@synthesize firstSubcategorySlug = _firstSubcategorySlug;
@synthesize imagePath = _imagePath;

-(void)dealloc{
	self.topicId = nil;
	self.name = nil;
	self.slug = nil;
	self.description = nil;
	self.firstSubcategorySlug = nil;
	self.imagePath = nil;
	[super dealloc];
}
@end
