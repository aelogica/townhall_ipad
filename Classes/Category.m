//
//  Category.m
//  TownHallServiceClient
//
//  Created by Marc Mercuri on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Category.h"


@implementation Category

@synthesize categoryId = _categoryId;
@synthesize name= _name;
@synthesize slug = _slug;
@synthesize description = _description;
@synthesize firstSubcategorySlug = _firstSubcategorySlug;
@synthesize imagePath = _imagePath;

-(void)dealloc{
	self.categoryId = nil;
	self.name = nil;
	self.slug = nil;
	self.description = nil;
	self.firstSubcategorySlug = nil;
	self.imagePath = nil;
	[super dealloc];
}
@end