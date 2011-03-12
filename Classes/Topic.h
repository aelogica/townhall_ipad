//
//  Topic.h
//  TownHallServiceClient
//
//  Created by Marc Mercuri on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject {
	NSInteger * topicId;
	NSString * name;
	NSString * slug;
	NSString * description;
	NSString * firstSubcategorySlug;
	NSString * imagePath;
}

@property(nonatomic, assign) NSInteger * topicId;
@property(nonatomic, copy) NSString * name;
@property(nonatomic, copy) NSString * slug;
@property(nonatomic, copy) NSString * description;
@property(nonatomic, copy) NSString * firstSubcategorySlug;
@property(nonatomic,copy) NSString * imagePath;

@end