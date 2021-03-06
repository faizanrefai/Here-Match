//
//  DCImageView.m
//  asyTblDemo
//
//  Created by digicorp on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DCImageView.h"


@implementation DCImageView

@synthesize dRef;
@synthesize ip;
@synthesize tableRef;
@synthesize strURL;
@synthesize myWebData;


+(void)loadURLImage:(NSString*)urlStringValue dictionaryRef:(NSMutableDictionary*)dRef indexPath:(NSIndexPath*)indexPath tableViewRef:(UITableView*)tableViewRef{
	

	DCImageView *dc=[[DCImageView alloc] init];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	

	
	dc.dRef=dRef;
	dc.ip=indexPath;
	dc.tableRef=tableViewRef;
	dc.strURL=urlStringValue;
	[dRef setObject:dc forKey:@"cell"];
	
	
	

	
	
	[dc release]; dc=nil;
}

-(void)setStrURL:(NSString *)urlInStringFormat{
	
	
	
	if (tableRef.tag == 111) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}else {

	NSURLConnection *con=[[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlInStringFormat]] delegate:self];
	if(con){
		myWebData=[[NSMutableData data] retain];
	} else {
	}	
	//	[con release];//me
	}
	
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

	[myWebData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	if (tableRef.tag==111) {
		
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		
	}else {
	
	[myWebData appendData:data];		
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection release];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	if(tableRef.tag == 111){
	
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
	}else {
	
	[dRef setObject:myWebData forKey:@"mywebdata"];
		
	if ([tableRef cellForRowAtIndexPath:ip]) {
        [tableRef beginUpdates];
		[tableRef reloadRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationNone];
		[tableRef endUpdates];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];		
	}
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];		

	}
	
}

-(void)dealloc{
	if(dRef!=nil && [dRef retainCount]>0) { [dRef release]; dRef=nil; }
	if(ip!=nil && [ip retainCount]>0) { [ip release]; ip=nil; }
	[super dealloc];
}

@end


