//
//  ResponseDialog.h
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import <UIKit/UIKit.h>
#import "BaseDialog.h"

@class Question;

@interface ResponseDialog : BaseDialog {
	Question *question;
}

@property(nonatomic, assign) Question *question;

- (id)initWithFrameAndQuestion:(CGRect)frame question: (Question*)aQuestion;

@end
