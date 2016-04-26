//
//  ActivityAlertView.m
//  herematch
//
//  Created by apple  on 8/19/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import "ActivityAlertView-old.h"


@implementation ActivityAlertView

@synthesize activityView;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 80, 30, 30)];
		[self addSubview:activityView];
		activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		[activityView startAnimating];
    }
	
    return self;
}

- (void) close
{
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) dealloc
{
	[activityView release];
	[super dealloc];
}

@end
