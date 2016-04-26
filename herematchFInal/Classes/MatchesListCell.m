//
//  MatchesListCell.m
//  HereMatch
//
//  Created by apple on 9/26/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import "MatchesListCell.h"


@implementation MatchesListCell
@synthesize imgUser,lblTitle,lblSubtitle;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[imgUser release];
	[lblTitle release];
	[lblSubtitle release];
    [super dealloc];
}


@end
