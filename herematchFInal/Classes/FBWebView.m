//
//  FBWebView.m
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/29/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import "FBWebView.h"


@implementation FBWebView





- (void)viewDidLoad
{
    
    [super viewDidLoad];
    NSURL * url = [NSURL URLWithString:@"http://www.openxcellaus.info/facebook/iframeapp/iframeapp/"];
    NSURLRequest * rquest = [[NSURLRequest alloc] initWithURL:url];
    [webview loadRequest:rquest];
    webview.scalesPageToFit = YES;
	[rquest release];
}

- (void)dealloc{
    
        [super dealloc];
}
@end
