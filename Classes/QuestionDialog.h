//
//  InputDialog.h
//  GenericTownHall
//
//  Created by David Ang on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Category;

@interface QuestionDialog : UIView {
	Category *category;

}

@property(nonatomic, assign) Category *category;

- (id)initWithFrameAndQuestion:(CGRect)frame category: (Category*)aCategory;

@end
