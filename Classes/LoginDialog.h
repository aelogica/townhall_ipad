//
//  LoginDialog.h
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//

#import "BaseDialog.h"
#import "FBConnect.h"

@interface LoginDialog : BaseDialog <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, UITextFieldDelegate> {
	NSArray *_permissions;
	BOOL isRegisteringNewUser;
	UILabel *activityIndicatorLabel;
}

@end
