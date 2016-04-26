//
//  AlertHandler.m

//
//

#import "AlertHandler.h"


@implementation AlertHandler
UIAlertView *av; 
UIActivityIndicatorView *actInd;

+(void)showAlertForProcess{
	if(av!=nil && [av retainCount]>0)
	{
		[av release]; av=nil; 
	} 
	if(actInd!=nil && [actInd retainCount]>0)
	{
		[actInd removeFromSuperview];
		[actInd release]; actInd=nil; 
	}
	av=[[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please wait..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil]; 
	actInd=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]; 
	[actInd setFrame:CGRectMake(125, 80, 30, 30)];
	[actInd startAnimating]; 
	[av addSubview:actInd]; 
	[av show]; 
} 
+(void)hideAlert{
	[av dismissWithClickedButtonIndex:0 animated:YES]; 
	if(av!=nil && [av retainCount]>0)
	{ 
		[av release];
		av=nil; 
	} 
	if(actInd!=nil && [actInd retainCount]>0)
	{ 
		[actInd removeFromSuperview];
		[actInd release];
		actInd=nil; 
	} 
} @end
