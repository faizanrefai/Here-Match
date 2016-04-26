//
//  GdataParser.m
//  TestWebService
//
//  Created by apple on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GdataParser.h"


@implementation GdataParser
@synthesize tagDic,rootTag;
- (void)downloadAndParse:(NSURL *)url withRootTag:(NSString*)root withTags:(NSDictionary*)tags sel:(SEL)seletor andHandler:(NSObject*)handler{
	self.tagDic =tags;
	self.rootTag=root;
	targetSelector=seletor;
	MainHandler=handler;
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:url];
	 xmlData = [[NSMutableData alloc] init];
	NSURLConnection  *rssConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	
	[rssConnection release];//me
	
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	
	[xmlData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
    [xmlData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    NSMutableArray *finalResult = [[NSMutableArray alloc] init];
	
	NSArray *items = [doc nodesForXPath:[NSString stringWithFormat:@"//%@",rootTag] error:nil];
    for (GDataXMLElement *item in items) {
		
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

		NSArray *ar= [tagDic allKeys];
		for (int i=0; i < [ar count]; i++) {
			 NSArray *tmpArray = [item elementsForName:[NSString stringWithFormat:@"%@",[tagDic objectForKey:[ar objectAtIndex:i]]]];
			for(GDataXMLElement *aID in tmpArray) {
				
				[dic setValue:aID.stringValue forKey:[NSString stringWithFormat:@"%@",[tagDic objectForKey:[ar objectAtIndex:i]]]];
				break;
			}
		}
		[finalResult addObject:dic];
		[dic release];
      /*
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSArray *ids = [item elementsForName:kName_Title];
        for(GDataXMLElement *aID in ids) {

			[dic setValue:aID.stringValue forKey:@"id"];
            break;
        }
        NSArray *descr = [item elementsForName:kName_Category];
        for(GDataXMLElement *category in descr) {
           
			[dic setValue:category.stringValue forKey:@"desc"];
            break;
        }
		[finalResult addObject:dic];
	*/
       
    }
	[MainHandler performSelector:targetSelector withObject:[NSDictionary dictionaryWithObjectsAndKeys:finalResult,@"array",nil]];

	[finalResult release];
    xmlData = nil;
    // Set the condition which ends the run loop.
 
}



- (void)dealloc {

    [super dealloc];
}

@end
