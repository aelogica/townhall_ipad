//
//  ResponseDialog.h
//  GenericTownHall
//
//  Created by David Ang on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Question;

@interface ResponseDialog : UIView {
	Question *question;
}

@property(nonatomic, assign) Question *question;

- (id)initWithFrameAndQuestion:(CGRect)frame question: (Question*)aQuestion;

@end
