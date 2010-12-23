//
//  QuestionPlainCell.m
//  GenericTownHall
//
//  Created by David Ang on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuestionPlainCell.h"
#import "AsynchImageView.h"


@implementation QuestionPlainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		subject = [[UILabel alloc]init];
		subject.textAlignment = UITextAlignmentLeft;
		subject.font = [UIFont systemFontOfSize:12];
		
		subject.numberOfLines = 0;
		subject.lineBreakMode = UILineBreakModeWordWrap;
		subject.backgroundColor = [UIColor clearColor];
		
		author = [[UILabel alloc]init];
		author.textAlignment = UITextAlignmentLeft;
		author.font = [UIFont systemFontOfSize:9];
		author.backgroundColor = [UIColor clearColor];	
		
		userPoints = [[UILabel alloc]init];
		userPoints.textAlignment = UITextAlignmentCenter;
		userPoints.font = [UIFont systemFontOfSize:20];		
		userPoints.textColor = [UIColor blueColor];
		userPoints.backgroundColor = [UIColor clearColor];
		
		responseCount = [[UILabel alloc]init];
		responseCount.textAlignment = UITextAlignmentCenter;
		responseCount.font = [UIFont systemFontOfSize:9];		
		responseCount.textColor = [UIColor blueColor];		
		responseCount.backgroundColor = [UIColor clearColor];
		
		[self.contentView addSubview:subject];
		[self.contentView addSubview:author];
		[self.contentView addSubview:userPoints];
		[self.contentView addSubview:responseCount];
		
		voteUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
		voteUpButton.frame = CGRectMake(5.0, 2.0, 24.0, 24.0);									
		voteUpButton.backgroundColor = [UIColor clearColor];
		//voteUpButton.tag = question.nuggetId;
		[voteUpButton addTarget:self action:@selector(voteUpPressed:) forControlEvents:UIControlEventTouchUpInside];
		[voteUpButton setImage:[UIImage imageNamed:@"arrow_up_24.png"] forState:UIControlStateNormal];
		[voteUpButton setImage:[UIImage imageNamed:@"arrow_up_24_on.png"] forState:UIControlStateHighlighted];
		[voteUpButton setImage:[UIImage imageNamed:@"arrow_up_24_on.png"] forState:UIControlStateSelected];
		
		voteDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
		voteDownButton.frame = CGRectMake(5.0, 27, 24.0, 24.0);									
		voteDownButton.backgroundColor = [UIColor clearColor];
		//voteDownButton.tag = question.nuggetId;
		[voteDownButton addTarget:self action:@selector(voteDownPressed:) forControlEvents:UIControlEventTouchUpInside];
		[voteDownButton setImage:[UIImage imageNamed:@"arrow_down_24.png"] forState:UIControlStateNormal];
		[voteDownButton setImage:[UIImage imageNamed:@"arrow_down_24_on.png"] forState:UIControlStateHighlighted];
		[voteDownButton setImage:[UIImage imageNamed:@"arrow_down_24_on.png"] forState:UIControlStateSelected];
		
		[self.contentView addSubview:voteUpButton];
		[self.contentView addSubview:voteDownButton];
		
		CGRect frame;
		frame.size.width=50; frame.size.height=42;
		frame.origin.x=30.f; frame.origin.y=5;
		AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
		[asyncImage loadImageFromURL:[NSURL URLWithString:@"http://c0030282.cdn.cloudfiles.rackspacecloud.com/empty-avatar-ml.png"]];
		[self.contentView addSubview:asyncImage];	
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
