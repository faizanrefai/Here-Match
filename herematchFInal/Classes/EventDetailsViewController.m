//
//  EventDetailsViewController.m
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/3/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import "EventDetailsViewController.h"


@implementation EventDetailsViewController
@synthesize titleview;
@synthesize EventTitle;
@synthesize EventStart;
@synthesize EventEnd;
@synthesize EventId;
@synthesize placename;
@synthesize bannerIsVisible;



#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currSysVer intValue]>= 5.0) {
        UIImage *backgroundImage = [UIImage imageNamed:@"here-match-header.png"];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
    }
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor]; 
    [self.titleview.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [self.titleview.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.titleview.layer setBorderWidth: 1.0];
    [self.titleview.layer setCornerRadius:8.0f];
    [self.titleview.layer setMasksToBounds:YES];
    
    btnCheckOut.hidden = YES;
    btnCheckin.hidden = YES;
    lblMsg.hidden = YES;
    
    
    if (!adView) {
        adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        adView.frame = CGRectOffset(adView.frame, 0, -50);
        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        [self.view addSubview:adView];
        adView.delegate=self;
        self.bannerIsVisible=NO;  
    }
        
}
- (void)viewWillAppear:(BOOL)animated{
    
    lblEventTitle.text = self.EventTitle;
    
    NSDateFormatter *dateFormatter =  [[NSDateFormatter alloc] init];    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLog(@"%@",self.EventStart);
    NSDate * stdate = [dateFormatter dateFromString:self.EventStart];
    NSDate * enddate = [dateFormatter dateFromString:self.EventEnd];
    
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    
    lblEventStart.text = [dateFormatter stringFromDate:stdate];
    lblEventEnd.text = [dateFormatter stringFromDate:enddate];
    lblPlace.text = self.placename;
    
    stdate = nil;
    enddate = nil;
    
    [dateFormatter release];
    
    
    if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@user_check_event.php?event_id=%@&user_id=%d",kWebServiceUrl,self.EventId,[AppDelegate sharedInstance].UserId]]) {
        DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
        return;
    }
    
    [[AppDelegate sharedInstance] showLoadingView];
    [self performSelectorInBackground:@selector(doCheckCheckIn) withObject:nil];
    
    
}
#pragma mark -
#pragma mark UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
        
        [self gotoMatchesView];
        [self.navigationController popViewControllerAnimated:NO];
        //[[AppDelegate sharedInstance] showLoadingView];
		
	}
    else{

        
    }
    
    
}

#pragma mark - Action Methods
- (void)doconfrimation{
    if (!confrimationalert) {
        confrimationalert = [[UIAlertView alloc] initWithTitle:@"herematch" message:@"Check In Successful." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    [confrimationalert show];
}

- (IBAction) btn_checkIn:(id) sender{
    
    if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@event_check_in.php?lat=24&long=45&event_id=%@&user_id=%d",kWebServiceUrl,self.EventId,[AppDelegate sharedInstance].UserId]]) {
        DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
        return;
    }
    
    [[AppDelegate sharedInstance] showLoadingView];
    [self performSelectorInBackground:@selector(doCheckIn) withObject:nil];
}
- (IBAction) btn_checkOut:(id) sender{
    
    if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@event_check_out.php?event_id=%@&user_id=%d",kWebServiceUrl,self.EventId,[AppDelegate sharedInstance].UserId]]) {
        DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
        return;
    }
    
    [[AppDelegate sharedInstance] showLoadingView];
    [self performSelectorInBackground:@selector(doCheckOut) withObject:nil];
}
- (void) doCheckIn{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    NSString * urlstring = [NSString stringWithFormat:@"%@event_check_in.php?lat=24&long=45&event_id=%@&user_id=%d",kWebServiceUrl,self.EventId,[AppDelegate sharedInstance].UserId];
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    //NSURL *url = [NSURL URLWithString:];
    //NSLog(@"checkin url = %@",url);
    NSString  *jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];//me key
	
	
   // NSLog(@"jsonREsponse Checkin = %@",jsonRes);
    //NSString * strlogin = [(NSString *)[jsonRes JSONValue] valueForKey:@"msg"];
    
    //if ([strlogin isEqualToString:@"Success"]) {
        [[AppDelegate sharedInstance] hideLoadingView];
    
        [self performSelectorOnMainThread:@selector(doconfrimation) withObject:nil waitUntilDone:YES];
    
      

    //}
    //[[AppDelegate sharedInstance] hideLoadingView];
    
    
    [pool release];

}
- (void) gotoMatchesView {
    
    [self.tabBarController setSelectedIndex:1]; 
//    FBWebView * webviewobj = [[FBWebView alloc] initWithNibName:@"FBWebView" bundle:nil];
//    [self presentModalViewController:webviewobj animated:YES];
}
- (void) doCheckOut{
    
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    NSString * urlstring = [NSString stringWithFormat:@"%@event_check_out.php?event_id=%@&user_id=%d",kWebServiceUrl,self.EventId,[AppDelegate sharedInstance].UserId];
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@event_check_out.php?event_id=%@&user_id=%d",kWebServiceUrl,self.EventId,[AppDelegate sharedInstance].UserId]];
    NSString  *jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"jsonREsponse CheckOut= %@",jsonRes);
    NSString * strlogin = [(NSString *)[jsonRes JSONValue] valueForKey:@"msg"];
    
    if ([strlogin isEqualToString:@"Success"]) {
        [[AppDelegate sharedInstance] hideLoadingView];
        DisplayAlertWithTitle(@"Check Out Successful.", @"herematch");
        [self.navigationController popViewControllerAnimated:YES];
    }    
   
    
    [pool release];

}
- (void) doCheckCheckIn{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@user_check_event.php?event_id=%@&user_id=%d",kWebServiceUrl,self.EventId,[AppDelegate sharedInstance].UserId]];
    NSString  *jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"jsonREsponse  do checkin = %@ and url  = %@",jsonRes,url);
    NSString * strlogin = [(NSString *)[jsonRes JSONValue] valueForKey:@"msg"];
    
    if ([strlogin isEqualToString:@"Yes"]) {
        
		btnCheckOut.hidden = NO;
        btnCheckin.hidden = YES;
        lblMsg.hidden = YES;
        
            
    }
    
    else{
        
        btnCheckOut.hidden = YES;
        btnCheckin.hidden = NO;
        lblMsg.hidden = YES;
        
    }
    
    [[AppDelegate sharedInstance] hideLoadingView];
    
    [pool release];
}
 
- (void) FaceBookSHaring {
//    SHKItem * item = [SHKItem text:@"Testing  form iphone"];
//    [SHKFacebook shareItem:item];
    //[SHKTwitter shareItem:item];
}
- (void) TwitterSHaring {
    
    
   // [[iCodeOauthViewController sharedInstance] tweetstaus];
    
//    _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
//	_engine.consumerKey = @"PzkZj9g57ah2bcB58mD4Q";
//	_engine.consumerSecret = @"OvogWpara8xybjMUDGcLklOeZSF12xnYHLE37rel2g";
//    
//    [_engine sendUpdate:@"This is test tweet from gulshan"];
    
    
//    SHKItem * item = [SHKItem text:@"Testing  form iphone"];
//    //[SHKFacebook shareItem:item];
//    [SHKTwitter shareItem:item];
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        scrollEvent.frame=CGRectMake(0, 50, 320,367);
        scrollEvent.contentSize=CGSizeMake(320, 370);
        // banner is invisible now and moved out of the screen on 50 px
        banner.frame = CGRectOffset(banner.frame,0, banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        scrollEvent.frame=CGRectMake(0, 0, 320,367);
        scrollEvent.contentSize=CGSizeMake(320, 370);
        // banner is visible and we move it out of the screen, due to connection issue
        banner.frame = CGRectOffset(banner.frame,0, -banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}
-(void)releaseBannerView {
    //Test for the ADBannerView Class, 4.0+ only (iAd.framework "weak" link Referenced)
    
    Class iAdClassPresent = NSClassFromString(@"ADBannerView");
    
    //If iOS has the ADBannerView class, then iAds = Okay:
    if (iAdClassPresent != nil) {
        
        //If instance of BannerView is Available:
        if (adView) {
            
            //Release the Delegate:
            adView.delegate = nil;
            
            //Release the bannerView:
            adView = nil;
        }
    }
}
- (void)dealloc
{
    [self releaseBannerView];
    [titleview release];
    [super dealloc];
}
@end

