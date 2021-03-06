//
//  AddPlaceViewController.m
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/6/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import "AddPlaceViewController.h"


@implementation AddPlaceViewController

@synthesize  locationManager = _locationManager;
@synthesize bannerIsVisible;

static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
CGFloat animatedDistance;
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
    check=FALSE;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor]; 
    txtplacename.delegate = self;
//    txtPlaceAdd.delegate = self;
//    txtplaceCity.delegate = self;
//    txtplaceState.delegate = self;
//    txtplaceZip.delegate = self;
//    txtplacePhone.delegate = self;
//    txtplaceUrl.delegate = self;
    txtplacename.autocapitalizationType=UITextAutocapitalizationTypeSentences;
    
    arr_category = [[NSMutableArray alloc] init];
       
    self.locationManager=[[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    
    checkedplace = 0;
    
    if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@industry_list.php",kWebServiceUrl]]) {
        DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
        return;
    }

    
    [[AppDelegate sharedInstance] showLoadingView];
    
    if (!adView) {
        adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        adView.frame = CGRectOffset(adView.frame, 0, -50);
        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        [self.view addSubview:adView];
        adView.delegate=self;
        self.bannerIsVisible=NO;  
    }

    
    [self performSelectorInBackground:@selector(downloadCategories) withObject:nil];
    
}


- (void)downloadCategories{
    
    
    
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
       
    
    //  For Calling Categories List WebService
    NSString * urlstring2 = [NSString stringWithFormat:@"%@places_category.php",kWebServiceUrl];
    NSURL *url2 = [NSURL URLWithString:[urlstring2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@friend_list.php?username=%@",kWebServiceUrl,[AppDelegate sharedInstance].username]];
    NSString * jsonRes2 = [NSString stringWithContentsOfURL:url2 encoding:NSUTF8StringEncoding error:nil];
   // NSLog(@"jsonREsponse1 = %@",jsonRes2);
   // NSString  *strmsg2 = [[jsonRes2 JSONValue] valueForKey:@"msg"];//me keyur
   // NSLog(@"strmsg2 = %@",strmsg2);
    // if ([strmsg2 isEqualToString:@"Success"]) {
    
    [arr_category setArray:[[jsonRes2 JSONValue] valueForKey:@"Record"]];
    
    //NSLog(@"no of categiries %d",[arr_category count]);
   // NSLog(@"name = %@",[[arr_category objectAtIndex:0] valueForKey:@"category_name"]);
    //   }
    
    
    
    //[PickerView reloadAllComponents];
    [[AppDelegate sharedInstance] hideLoadingView];
    [pool release];
}




#pragma mark - Action Methods


- (IBAction) ShowPikerView:(id) sender{
    
    UIActionSheet *ActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Done" otherButtonTitles:nil];
    
    ActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    //MilestonePickerSheet.tag = 1;
    [ActionSheet setBounds:CGRectMake(0, 0, 320, 250)];
    PickerView = [[UIPickerView alloc] init];
    
    PickerView.delegate = self;
    PickerView.dataSource = self;
    PickerView.showsSelectionIndicator=TRUE;
    
    [PickerView selectRow:checkedplace inComponent:0 animated:NO];
    
    [ActionSheet addSubview:PickerView];
    
    //[sheet showInView:self.parentViewController.tabBarController.view];
    [ActionSheet showInView:self.parentViewController.tabBarController.view];
    [PickerView release];
    [ActionSheet release];
}
- (IBAction) btnAddPlace_Click:(id) sender{
    
    
        [txtplacename resignFirstResponder];
    
    if ([txtplacename.text length] == 0) {
		DisplayAlertWithTitle(@"Please Enter The Place Name.",@"herematch");
        
        
	} 
    
    else if ([lblcategory.text isEqualToString:@"Category"]) {
        DisplayAlertWithTitle(@"Please Select A Category.",@"herematch");
    }
    else {         
        
        if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@industry_list.php",kWebServiceUrl]]) {
            DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
            return;
        }

        
        [[AppDelegate sharedInstance] showLoadingView];
        [self.locationManager startUpdatingLocation];      
    }

}
- (void)doAddPlace{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    NSString * urlstring;
    
    //[[AppDelegate sharedInstance] showLoadingView];
    if ([AppDelegate sharedInstance].isFromAddEvent) {
           urlstring = [NSString stringWithFormat:@"%@add_places.php?address=%@&city=%@&state=%@&country=%@&phone=%@&href=%@&postcode=%@&lat=%f&long=%f&category=%@&creator_id=%d",kWebServiceUrl,txtPlaceAdd.text,txtplaceCity.text,txtplaceState.text,@"Country",txtplacePhone.text,txtplaceUrl.text,txtplaceZip.text,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,lblcategory.text,[AppDelegate sharedInstance].UserId];    
    }
    else {
        urlstring = [NSString stringWithFormat:@"%@add_places.php?address=%@&city=%@&state=%@&country=%@&phone=%@&href=%@&postcode=%@&lat=%f&long=%f&category=%@&creator_id=%d",kWebServiceUrl,txtPlaceAdd.text,txtplaceCity.text,txtplaceState.text,@"Country",txtplacePhone.text,txtplaceUrl.text,txtplaceZip.text,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,lblcategory.text,[AppDelegate sharedInstance].UserId];    
    }
        
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@add_places.php",kWebServiceUrl]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *strPlaceName=[NSString stringWithFormat:@"name=%@",txtplacename.text];
    NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strPlaceName, NULL, CFSTR("&"), kCFStringEncodingUTF8);
   
    NSString *body = [NSString stringWithFormat:@"%@&%@",result,urlstring];
    
    NSData *requestBody = [body dataUsingEncoding:NSASCIIStringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBody];
    
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSString *responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    
   
    
    
    
    
   // NSLog(@"url add place = %@",urlstring);
 //   NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
//    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"jsonREsponse = %@",jsonRes);
    NSString * strsignup = [(NSString *)[responseString JSONValue] valueForKey:@"msg"];
    
    if ([strsignup isEqualToString:@"Success"]) {
        
        
        [[AppDelegate sharedInstance] hideLoadingView];
        [AppDelegate sharedInstance].isFromAddplace = TRUE;
        
        [self performSelectorOnMainThread:@selector(doconfrimation) withObject:nil waitUntilDone:YES];
       
        
    }
    else{
        
        [[AppDelegate sharedInstance] hideLoadingView];
        DisplayAlertWithTitle(@"Add Place Failed.", @"herematch");
        
        
    }
    [pool release];
}
- (void)doconfrimation{
    if (!confrimationalert) {
        confrimationalert = [[UIAlertView alloc] initWithTitle:@"herematch" message:@"Place Added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    [confrimationalert show];
}
#pragma mark -
#pragma mark UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
		//[[AppDelegate sharedInstance] showLoadingView];
		
	}
    else{      
        
        txtplacename.text=@"";
        checkedplace=0; 
        lblcategory.text=@"Category";

    }
    
    
}


#pragma mark -
#pragma mark coreLocation methods

//-------------------------------------------------------------------------------------------------------------------

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {	
	
    
    [AppDelegate sharedInstance].location = newLocation;
    
       
   // [[AppDelegate sharedInstance] showLoadingView];
    
    if (check==FALSE) {
      [self performSelectorInBackground:@selector(doAddPlace) withObject:nil];  
        check=TRUE;
    }
    
    
    [self.locationManager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
     DisplayAlertWithTitle(kLocationErrormsg, @"herematch");
	//NSLog(@"Error in Location Manager (GPS)");
}


# pragma  mark label -
# pragma mark PickerViewDelegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
     return [arr_category count];
    
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
         return [[arr_category objectAtIndex:row] valueForKey:@"category_name"];
      
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    
        //[lblcategory setText:[[arr_category objectAtIndex:row] valueForKey:@"category_name"]];
        checkedplace = row;
}

#pragma mark -
#pragma mark UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
		if (buttonIndex == 0) 
		{
			[lblcategory setText:[[arr_category objectAtIndex:checkedplace] valueForKey:@"category_name"]];
			
		}		
}


#pragma mark - TextField Delegate Methods


//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{     
//    
//    CGRect textFieldRect =[self.view.window convertRect:textField.bounds fromView:textField];
//    CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
//    
//    CGFloat midline = textFieldRect.origin.y +1.0*textFieldRect.size.height;
//    CGFloat numerator =midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION *  viewRect.size.height;
//    CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
//    CGFloat heightFraction = numerator / denominator;
//    
//    animatedDistance = floor(162.0 * heightFraction);
//    
//    CGRect viewFrame = self.view.frame;
//    
//    viewFrame.origin.y -= animatedDistance;
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//    [self.view setFrame:viewFrame];
//    [UIView commitAnimations];
//}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    CGRect viewFrame = self.view.frame;
//    viewFrame.origin.y += animatedDistance;
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//    
//    [self.view setFrame:viewFrame];
//    
//    [UIView commitAnimations];
    
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
     [txtplacename resignFirstResponder];
    
//    NSInteger nextTag = textField.tag + 1;
//	UIResponder* nextResponder = [[textField.superview superview] viewWithTag:nextTag];
//    
//    
//	if (nextResponder) {
//		[nextResponder becomeFirstResponder];		
//	}
//	else{		
//		[textField resignFirstResponder];
//        //[self.tblSignup setContentSize:CGSizeMake(self.tblSignup.frame.size.width, self.tblSignup.frame.size.height - 200)];
//        //[self.tableview scrollsToTop];
//	}
    
    return YES;
    
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        scrollPlace.frame=CGRectMake(0, 50, 320,471);
        scrollPlace.contentSize=CGSizeMake(320, 500);
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
        scrollPlace.frame=CGRectMake(0, 0, 320,471);
        scrollPlace.contentSize=CGSizeMake(320, 500);
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
    [lblcategory release];   
    [txtplacename release];
    [txtPlaceAdd release];
    [txtplaceCity release];
    [txtplaceState release];
    [txtplaceZip release];
    [txtplacePhone release];
    [txtplaceUrl release];

    [arr_category release];
     _locationManager.delegate = nil;
    [_locationManager release];
    [super dealloc];
}
@end
