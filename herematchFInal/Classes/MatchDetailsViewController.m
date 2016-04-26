//
//  MatchDetailsViewController.m
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/3/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import "MatchDetailsViewController.h"
#import "AppDelegate.h"

@implementation MatchDetailsViewController

@synthesize idUser,bannerIsVisible;

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
    
    if (!adView) {
        adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        adView.frame = CGRectOffset(adView.frame, 0, -50);
        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        [self.view addSubview:adView];
        adView.delegate=self;
        self.bannerIsVisible=NO;
        
    }
    
  
	userDetailScrollView.contentSize = CGSizeMake(320,630);
	CGPoint topOffset = CGPointMake(0,0);
    [userDetailScrollView setContentOffset:topOffset animated:YES];
	
	[titleview.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [titleview.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [titleview.layer setBorderWidth:1.0];
    [titleview.layer setCornerRadius:8.0f];
    [titleview.layer setMasksToBounds:YES];
	
	[[AppDelegate sharedInstance] showLoadingView];
	[self performSelectorInBackground:@selector(doStartLoading) withObject:nil];
 
}

#pragma mark -
#pragma mark custom methods
- (NSString *)removeNull:(NSString *)str{
    str = [NSString stringWithFormat:@"%@",str];
    if (!str) {
        return @"";
    }
    else if([str isEqualToString:@"(null)"]){
        return @"";
    }
    else if([str isEqualToString:@"<null>"]){
        return @"";
    }
    else{
        return str;
    }
}

- (void)doStartLoading
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//Begin Detail..
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@user_details_byId.php?id=%d",kWebServiceUrl,idUser]];
    //NSLog(@"profile url = %@",url);
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	dictLoginUserdetail = [[NSMutableDictionary alloc] init];
	
	[dictLoginUserdetail setValuesForKeysWithDictionary:[(NSMutableDictionary*)[jsonRes JSONValue] valueForKey:@"data"]]; 
	NSString *strPhotoFileName = [dictLoginUserdetail valueForKey:@"photo_file_name"];
    strPhotoFileName = [self removeNull:strPhotoFileName];
	//NSLog(@"photo file name %@",strPhotoFileName);
    
        
	if ([strPhotoFileName isEqualToString:@""]) {
		imgPerson.image = [UIImage imageNamed:@"MatchDetails-Default.png"];
	}else {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://herematch.com:3000/system/photos/%d/original/%@",self.idUser,strPhotoFileName]];
		//NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUserImageWSURl,strPhotoFileName]];
		NSData *imageData = [NSData dataWithContentsOfURL:url];
		UIImage *image = [UIImage imageWithData:imageData];
		imgPerson.image = image; 
	}
	//..
	[[AppDelegate sharedInstance] hideLoadingView];
	[self performSelectorOnMainThread:@selector(viewLoginUserData) withObject:nil waitUntilDone:NO];
	[pool release];
}
-(void)viewLoginUserData
{
	//txtmatchesreson.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"title"]];
	lblFirstName.text = [NSString stringWithFormat:@"%@ %@",[dictLoginUserdetail valueForKey:@"first_name"],[dictLoginUserdetail valueForKey:@"last_name"]];
    
    //first set the title
    NSString * details = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"title"]];
    details = [self removeNull:details];
     //NSLog(@"details  = %@",details);
    //check if title is null
    if ([details isEqualToString:@""]) {
        //if title is null then check for company
        NSString * strtemp = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"company"]];
        strtemp = [self removeNull:strtemp];
        if (![strtemp isEqualToString:@""]) {
            //if company is not null then append company.
            details =  strtemp;
        } 
    }
    else{
        //if title is not null then check for company is null or not
        NSString * strtemp = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"company"]];
         strtemp = [self removeNull:strtemp];
        if (![strtemp isEqualToString:@""]) {
            //if company is not null then append it at company.
            details =  [NSString stringWithFormat:@"%@ at %@",details,strtemp];
        }
         
    }    
    //append slash n for new line.
    details = [NSString stringWithFormat:@"%@\n",details];
    //NSLog(@"details  = %@",details);
    
    NSString * strindustry = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_name"]];
    strindustry = [self removeNull:strindustry];
    
    NSString * strlocationcity = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"location_city"]];
    strlocationcity = [self removeNull:strlocationcity];
    
    NSString * strlocationstate = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"location_state"]];
    strlocationstate = [self removeNull:strlocationstate];

    if (![strindustry isEqualToString:@""]) {
        details =  [NSString stringWithFormat:@"%@%@\n",details,strindustry];
    }
    
    
    
    //now check for location city is null or not
    if ([strlocationcity isEqualToString:@""]) {
        details =  [NSString stringWithFormat:@"%@%@",details,strlocationstate];  
    }
    else{
       details =  [NSString stringWithFormat:@"%@%@",details,strlocationcity];   
        if (![strlocationstate isEqualToString:@""]) {
            //if location state is not null append location state
            details =  [NSString stringWithFormat:@"%@, %@",details,[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"location_state"]]];   
        }

    
    }
    
    
    
    
//    //now check if industry is null or not.
//    
//    if ([strindustry isEqualToString:@""]) {
//        //if industry is null then now check for location city is null or not
//        
//        if ([strlocationcity isEqualToString:@""]) {
//            details =  [NSString stringWithFormat:@"%@%@",details,strlocationstate];  
//        }
//        else{
//            //if location city is not null append location city
//            details =  [NSString stringWithFormat:@"%@%@",details,strlocationcity];  
//            //now check for location state is null or not
//            
//            if (![strlocationstate isEqualToString:@""]) {
//                //if location state is not null append location state
//                details =  [NSString stringWithFormat:@"%@, %@",details,[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"location_state"]]];   
//            }
//            
//        } 
//    }
//    else{
//        //if industry is not null append industry
//        details =  [NSString stringWithFormat:@"%@%@",details,strindustry];
//        //now check for location city is null or not
//        if ([strlocationcity isEqualToString:@""]) {
//            //if locatin city is null then now check for location state is null or not
//            if (![strlocationstate isEqualToString:@""]) {
//                //if location state is not null append location state
//                details =  [NSString stringWithFormat:@"%@, %@",details,strlocationstate];   
//            }  
//        }
//        else{
//            //if location city is not null append location city
//            details =  [NSString stringWithFormat:@"%@ | %@",details,strlocationcity];  
//            //now check for location state is null or not
//            if (![strlocationstate isEqualToString:@""]) {
//               //if location state is not null append location state
//               details =  [NSString stringWithFormat:@"%@, %@",details,strlocationstate];   
//            }
//            
//        }
//    }
//    
    //NSLog(@"details  = %@",details);
	txtdetails.text = details;
    
                       
                       
	lblLocationCity.text =strlocationcity;
	lblLocationState.text = strlocationstate;
	//lblIndustry.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_name"]];
    
    NSString * strbio = [NSString stringWithFormat:@"%@",[dictLoginUserdetail objectForKey:@"bio"]];
    strbio = [self removeNull:strbio];
    
	txtBio.text = strbio;
    
	strEmailID = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"email"]] retain];
     //NSLog(@"stremail id = %@",strEmailID);
    
    NSString * strheadline = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"headline"]];
    strheadline = [self removeNull:strheadline];
    
	//lblHeadline.text = strheadline;
    
	strCallNo = [[NSString stringWithFormat:@"%@%@%@",[dictLoginUserdetail valueForKey:@"phone"],[dictLoginUserdetail valueForKey:@"phone2"],[dictLoginUserdetail valueForKey:@"phone3"]] retain];
    strCallNo = [[self removeNull:strCallNo] retain];
    //NSLog(@"strcallno = %@",strCallNo);
    
	//lblURL.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"url"]];
	lblCompany.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"company"]];
	//lblEduSchool.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"school"]];
	//lblEduGraduationYear.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"graduation_year"]];
	//lblEduMajor.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"major"]];
	//lblHTCity.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"hometown_city"]];
	//lblHTState.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"hometown_state"]];
	//lblIndustry1.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_interested_1_name"]];
	//lblIndustry2.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_interested_2_name"]];
	//lblIndustry3.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_interested_3_name"]];
	//txtInterests.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"interests"]];
	//txtAssociations.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"groups"]];	
    
    
    if ([[AppDelegate sharedInstance].arrMatchResons count]>0) {
        for (int i=0;i < [[AppDelegate sharedInstance].arrMatchResons count]; i++) {
            if (i==0) {
                txtmatchesreson.text = [NSString stringWithFormat:@"%@%@",txtmatchesreson.text,[[AppDelegate sharedInstance].arrMatchResons objectAtIndex:i]]; 
            }
            else{
                txtmatchesreson.text = [NSString stringWithFormat:@"%@\n%@",txtmatchesreson.text,[[AppDelegate sharedInstance].arrMatchResons objectAtIndex:i]]; 
            }
            
            
        } 
    }else{
        userDetailScrollView.contentSize = CGSizeMake(320,480);
        
        lblmatchreson.hidden=YES;
        txtmatchesreson.hidden=YES;
        imgmatchreson.hidden=YES;
        
        [lblbio setFrame:lblmatchreson.frame];
        [txtBio setFrame:txtmatchesreson.frame];
        [imgbio setFrame:imgmatchreson.frame];
    }
    
   
    
	if ([strCallNo isEqualToString:@""]) {
		btnCall.hidden = YES;
		btnText.hidden = YES;
        btnEmail.frame = CGRectMake(btnText.frame.origin.x, btnText.frame.origin.y, btnEmail.frame.size.width, btnEmail.frame.size.height);
	}else {
		btnCall.hidden = NO;
		btnText.hidden = NO;
         btnEmail.frame = CGRectMake(215, 157, btnEmail.frame.size.width, btnEmail.frame.size.height);
        
	}

}
-(IBAction)btnCall_Click:(id)sender
{
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:1%@",strCallNo]];
    
	[[UIApplication sharedApplication] openURL:phoneNumberURL];
    
}
-(IBAction)btnSms_Click:(id)sender
{
    
 	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    [AppDelegate sharedInstance].ismail = TRUE;
	picker.messageComposeDelegate = self;
	
	picker.recipients = [NSArray arrayWithObject:[NSString stringWithFormat:@"1%@",strCallNo]];  
    
   
    [picker setBody:@"herematch: "];
	//picker.body = @"herematch: ";
	//NSLog(@"Body : %@  :%@",picker.body,txtReport.text);
	
	
	[self presentModalViewController:picker animated:YES];
	[picker release];   
}
-(IBAction)btnEmail_Click:(id)sender
{
// 	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//	picker.mailComposeDelegate = self;
//	
//	[picker setSubject:@"Hi"];
//	
//	// Set up recipients
//	NSArray *toRecipients = [NSArray arrayWithObject:strEmailID];
//	NSString *emailBody = @"Nice  to See you!";
//	[picker setMessageBody:emailBody isHTML:NO];
//	
//	[self presentModalViewController:picker animated:YES];
//	[picker release];   
    
	if ([MFMailComposeViewController canSendMail]) {
        //
        [AppDelegate sharedInstance].ismail = TRUE;
        mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        //NSLog(@"stremail id = %@",strEmailID);

        
        NSArray *toRecipients = [[NSArray alloc] initWithObjects:strEmailID, nil];
        
                //NSLog(@"stremail ids = %@",toRecipients);
        [mailViewController setToRecipients:toRecipients];
        [mailViewController setSubject:@"herematch message"];
        [mailViewController setMessageBody:@"" isHTML:NO];
        
        [self presentModalViewController:mailViewController animated:YES];
        [[mailViewController navigationBar] setBarStyle:UIBarStyleBlackOpaque];
        [toRecipients release];
        [mailViewController release];
    }
    else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"You are not logged in your device email account." delegate:self cancelButtonTitle:@"Ok." otherButtonTitles:nil,nil];
		[alert show];
		[alert release];
        //NSLog(@"Device is unable to send email in its current state.");
    }
}
#pragma mark -
#pragma mark MFMessageComposeViewController delegate methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	switch (result)
	{
		case MessageComposeResultCancelled:
			//NSLog(@"Result: canceled");
			break;
		case MessageComposeResultSent:
			//NSLog(@"Result: sent");
			break;
		case MessageComposeResultFailed:
			//NSLog(@"Result: failed");
			break;
		default:
			//NSLog(@"Result: not sent");
			break;
	}
	[AppDelegate sharedInstance].ismail = FALSE;
	[self dismissModalViewControllerAnimated:YES];
	
}
#pragma mark -
#pragma mark MFMailComposeViewController delegate methods
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
		default:
			break;
	}
    [AppDelegate sharedInstance].ismail = FALSE;
	[self dismissModalViewControllerAnimated:YES];                      
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        userDetailScrollView.frame=CGRectMake(0, 50, 320,563);
        	userDetailScrollView.contentSize = CGSizeMake(320,740);
        // banner is invisible now and moved out of the screen on 50 px
        
        titleview.frame=CGRectMake(10, 14, 300, 129);
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
        
        userDetailScrollView.frame=CGRectMake(0, 50, 320,563);
        userDetailScrollView.contentSize = CGSizeMake(320,630);
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
       [super dealloc];
 
   // [titleview release];
   // [txtBio release];
    //[txtmatchesreson release];
   // [dictLoginUserdetail release]; 
    

}
@end
