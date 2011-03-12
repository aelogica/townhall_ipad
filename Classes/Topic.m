//
//  Topic.m
//  TownHallServiceClient
//
//  Created by Marc Mercuri on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Topic.h"

@implementation Topic

@synthesize topicId;
@synthesize name;
@synthesize slug;
@synthesize description;
@synthesize firstSubcategorySlug;
@synthesize imagePath;

-(void)dealloc{
	[super dealloc];
}
@end
