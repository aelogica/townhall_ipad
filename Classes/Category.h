//
//  Category.h
//  TownHallServiceClient
//
//  Created by Marc Mercuri on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Category : NSObject {
	NSInteger * _categoryId;
	NSString * _name;
	NSString * _slug;
	NSString * _description;
	NSString * _firstSubcategorySlug;
	NSString * _imagePath;
}

@property(nonatomic, assign) NSInteger * categoryId;
@property(nonatomic, copy) NSString * name;
@property(nonatomic, copy) NSString * slug;
@property(nonatomic, copy) NSString * description;
@property(nonatomic, copy) NSString * firstSubcategorySlug;
@property(nonatomic,copy) NSString * imagePath;

@end