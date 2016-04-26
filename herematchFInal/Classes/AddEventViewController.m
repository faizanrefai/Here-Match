//
//  AddEventViewController.m
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/6/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import "AddEventViewController.h"


@implementation AddEventViewController

@synthesize  locationManager = _locationManager;
@synthesize lblStartDate;
@synthesize lblEndDate;
@synthesize startdate;
@synthesize enddate,bannerIsVisible; 

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
    
    flag=0;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor]; 
    arr_place = [[NSMutableArray alloc] init];
    //arr_category = [[NSMutableArray alloc] initWithObjects:@"ConVention Center",@"Conference Center",@"Event Space",@"Public Space",@"Restaurant",@"Other", nil];
    arr_industry = [[NSMutableArray alloc] init];
    arr_category = [[NSMutableArray alloc] init];
    
    txteventname.delegate = self;
    txturl.delegate = self;
    txtemail.delegate = self;
    txtphone.delegate = self;
    txtdescription.delegate = self;
    txtdescription.returnKeyType = UIReturnKeyDone;    
    txteventname.autocapitalizationType=UITextAutocapitalizationTypeSentences;
    
    checkedplace=0;
    checkedindustry=0;
    checkedcategory=0;
    
    obj = [[AddEventDatePickerViewController alloc] initWithNibName:@"AddEventDatePickerView" bundle:nil];
    
    [AppDelegate sharedInstance].AddEventStartDate=nil;
    [AppDelegate sharedInstance].AddEventEndDate=nil;
    
    [AppDelegate sharedInstance].isFromAddplace=FALSE;
    //    scrollView.contentSize = CGSizeMake(320,570);
//    CGPoint topOffset = CGPointMake(0,0);
//    [scrollView setContentOffset:topOffset animated:YES];
    
    isWSCalled = NO;
    //NSLog(@"startdate retail count before = %d",[startdate retainCount]);
    startdate = [[NSDate date] retain];
    enddate = [[NSDate date] retain];
    isFirstTime = YES;
    
    //iad
    
    if (!adView) {
        adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        adView.frame = CGRectOffset(adView.frame, 0, -50);
        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        [self.view addSubview:adView];
        adView.delegate=self;
        self.bannerIsVisible=NO;  
    }

    
    //NSLog(@"startdate retail count After = %d",[startdate retainCount]);
    
    self.locationManager=[[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
    
    checkFlag=FALSE;
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    //lblStartDate.text = [AppDelegate sharedInstance].AddEventStartDate;
    //lblEndDate.text = [AppDelegate sharedInstance].AddEventEndDate;
    
    
    //lblStartDate.text = [AppDelegate sharedInstance].AddEventStartDate;
    //lblEndDate.text = [AppDelegate sharedInstance].AddEventEndDate;
    
    if ([AppDelegate sharedInstance].isFromAddplace) {
        isWSCalled = NO;
        
       [self.locationManager startUpdatingLocation]; 
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardDidShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil];
    
}

- (void)downloadIndustriesAndPlaces{
    
    
    
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    //  For Calling Events List WebService
    NSString * urlstring = [NSString stringWithFormat:@"%@industry_list.php",kWebServiceUrl];
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@friend_list.php?username=%@",kWebServiceUrl,[AppDelegate sharedInstance].username]];
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"jsonREsponse = %@",jsonRes);
         
        [arr_industry setArray:[[jsonRes JSONValue] valueForKey:@"Industry"]];
        [arr_industry insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"General",@"name",@"1",@"ind_id", nil] atIndex:0];
        //[tableview reloadData];
//        NSLog(@"no of Industries %d",[arr_industry count]);
//        NSLog(@"name = %@",[[arr_industry objectAtIndex:0] valueForKey:@"name"]);
    
    
    
    //  For Calling Places List WebService
    NSString * urlstring1 = [NSString stringWithFormat:@"%@places_list_lat_long_name.php?lat=%f&long=%f",kWebServiceUrl,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude];
    NSURL *url1 = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"Places url = %@",url1);
    NSString * jsonRes1 = [NSString stringWithContentsOfURL:url1 encoding:NSUTF8StringEncoding error:nil];
   // NSLog(@"jsonREsponse1 = %@",jsonRes1);
   // NSString  *strmsg = [[jsonRes1 JSONValue] valueForKey:@"msg"];//me keyur
    //NSLog(@"strmsg = %@",strmsg);
    
        
        [arr_place setArray:[[jsonRes1 JSONValue] valueForKey:@"Record"]];
        
    
    //[arr_place removeLastObject];
        //NSLog(@"no of places %d",[arr_place count]);
        //NSLog(@"name = %@",[[arr_place objectAtIndex:0] valueForKey:@"name"]);
   
    
    
    
    
    //  For Calling Categories List WebService
    NSString * urlstring2 = [NSString stringWithFormat:@"%@category.php",kWebServiceUrl];
    NSURL *url2 = [NSURL URLWithString:[urlstring2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
     //NSLog(@"categories url = %@",url2);
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@friend_list.php?username=%@",kWebServiceUrl,[AppDelegate sharedInstance].username]];
    NSString * jsonRes2 = [NSString stringWithContentsOfURL:url2 encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"jsonREsponse1 = %@",jsonRes2);
   // NSString  *strmsg2 = [[jsonRes2 JSONValue] valueForKey:@"msg"];//me keyur
    //NSLog(@"strmsg2 = %@",strmsg2);
   // if ([strmsg2 isEqualToString:@"Success"]) {
        
        [arr_category setArray:[[jsonRes2 JSONValue] valueForKey:@"Record"]];
        
//        NSLog(@"no of categiries %d",[arr_category count]);
//        NSLog(@"name = %@",[[arr_category objectAtIndex:0] valueForKey:@"category_name"]);
 //   }
    
    //@try
    //{
        [[AppDelegate sharedInstance] hideLoadingView];
        
        if ( [AppDelegate sharedInstance].isFromAddplace) {
            [AppDelegate sharedInstance].isFromAddplace=FALSE;
            
            checkedplace=([arr_place count] -2);
            lblplace.text = [[arr_place objectAtIndex:checkedplace] valueForKey:@"name"];
            placeid = [[arr_place objectAtIndex:checkedplace] valueForKey:@"id"];
            //[PickerView reloadAllComponents];
        }

    //}
    
    //@catch (NSException *ex) {
      //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",ex]
       //                                                delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //[alert show];
    //}
    
    //[PickerView reloadAllComponents];
       
    [pool release];
}


#pragma mark - Action Methods

- (IBAction) btnStartEnd_Click:(id) sender{
    
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (IBAction) ShowDatePikerView:(id) sender {
    
    
    UIActionSheet *ActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Date\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Set" otherButtonTitles:nil];
    
    ActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    //ActionSheet.transform = CGAffineTransformMakeRotation(M_PI);
    
    [ActionSheet setBounds:CGRectMake(0, 0, 320, 250)];
    dtPicker = [[UIDatePicker alloc] init];
    
    
    
    UIButton * btn = sender;
    dtPicker.tag = btn.tag;
    ActionSheet.tag = btn.tag;
    
    if (btn.tag==4) {
        [dtPicker setDate:startdate];
        //[startdate release];
    }
    else {
        [dtPicker setDate:enddate];
        //[enddate release];
    }
    
    //[dtPicker addTarget:self action:@selector(setTextDate:) forControlEvents:UIControlEventValueChanged];
    
    [ActionSheet addSubview:dtPicker];
    [ActionSheet showInView:self.parentViewController.tabBarController.view];
    [dtPicker release];
    [ActionSheet release];
    
}

-(IBAction)setTextDate:(id)sender {
    
    
    NSDateFormatter *dateFormatter =  [[NSDateFormatter alloc] init];    
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    
    
    NSDateFormatter *dateFormatterwsformat =  [[NSDateFormatter alloc] init];    
    [dateFormatterwsformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
	
    UIDatePicker * tempbtn = sender;
    if (tempbtn.tag==4) {
        
        
        startdate = [[dtPicker date] retain];
        //NSLog(@"Start Date:: %@",[dateFormatter stringFromDate:[dtPicker date]]);

        self.lblStartDate.text = [dateFormatter stringFromDate:[dtPicker date]];
        [AppDelegate sharedInstance].AddEventStartDateWsFormatted = [dateFormatterwsformat stringFromDate:[dtPicker date]];
    }
    else{
         
        enddate = [[dtPicker date] retain];
        //NSLog(@"End Date:: %@",[dateFormatter stringFromDate:[dtPicker date]]);
        self.lblEndDate.text = [dateFormatter stringFromDate:[dtPicker date]];
        [AppDelegate sharedInstance].AddEventEndDateWsFormatted = [dateFormatterwsformat stringFromDate:[dtPicker date]];
    }
    
    [dateFormatter release];
    [dateFormatterwsformat release];
    
} 


- (IBAction) ShowPikerView:(id) sender{
    UIButton * btn = sender;
    UIActionSheet *ActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Done" otherButtonTitles:nil];
    
    ActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    //MilestonePickerSheet.tag = 1;
    [ActionSheet setBounds:CGRectMake(0, 0, 320, 250)];
    PickerView = [[UIPickerView alloc] init];
    PickerView.tag = btn.tag;
    PickerView.delegate = self;
    PickerView.dataSource = self;
    PickerView.showsSelectionIndicator=TRUE;

	selectBtnTag = btn.tag;
    if (selectBtnTag==1) {
        [PickerView selectRow:checkedplace inComponent:0 animated:NO];
    }
    else if (selectBtnTag==2) {
        [PickerView selectRow:checkedcategory inComponent:0 animated:NO];
    }
    else if (selectBtnTag==3) {
        [PickerView selectRow:checkedindustry inComponent:0 animated:NO];
    }
    [ActionSheet addSubview:PickerView];
    
    [ActionSheet showInView:self.parentViewController.tabBarController.view];
	ActionSheet.tag = 3;
    [PickerView release];
    [ActionSheet release];
}


- (IBAction) btnAddEvent_Click:(id) sender{
    
    [txteventname resignFirstResponder]; 
    
    if ([txteventname.text length] == 0) {
		DisplayAlertWithTitle(@"Please Enter The Event Name.",@"herematch");        
	}
    
    else if ([lblStartDate.text isEqualToString:@"Start Date/Time"]) {
        
        DisplayAlertWithTitle(@"Please Enter The Event Start Date/Time.",@"herematch");        
    }
    else if ([lblEndDate.text isEqualToString:@"End Date/Time"]) {
        
        DisplayAlertWithTitle(@"Please Enter The Event End Date/Time.",@"herematch");       
    }
    else if ([lblplace.text isEqualToString:@"Place"]) {
        DisplayAlertWithTitle(@"Please Select A Place.",@"herematch");
    }
    else if ([lblcategory.text isEqualToString:@"Category"]) {
        DisplayAlertWithTitle(@"Please Select A Category.",@"herematch");
    }
    else if ([lblindustry.text isEqualToString:@"Industry"]) {
        DisplayAlertWithTitle(@"Please Select An Industry.",@"herematch");
    }
    else {
        
        if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@industry_list.php",kWebServiceUrl]]) {
            DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
            return;
        }

        
        flag=1;
        
        [[AppDelegate sharedInstance] showLoadingView];
        [self.locationManager startUpdatingLocation];   
    }

}
- (IBAction) btnimgbutton_Click:(id) sender
{
//	actionsheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose from Library",nil];
//	[actionsheet showFromTabBar:self.tabBarController.tabBar];
//	actionsheet.tag = 2;
//	[actionsheet release];
}

//-(void)doSaveChaged
//{
//	NSAutoreleasePool *pool = [NSAutoreleasePool new];
//	
//	NSString* url1 = [ NSString stringWithFormat:@"%@user_image.php",kWebServiceUrl];
//    NSMutableData* postData = [[NSMutableData new] autorelease];
//    NSMutableData * body = [[NSMutableData alloc] init];
//    
//    NSString *postStr=[NSString stringWithFormat:@"image="];
//	[postData appendData:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
//    NSMutableURLRequest* postRequest = [[[NSMutableURLRequest alloc] init] autorelease];
//	[postRequest setURL:[NSURL URLWithString:url1]];
//	[postRequest setHTTPMethod:@"POST"];
//	
//	CGRect rect=CGRectMake(0,0,100,150);
//	UIGraphicsBeginImageContext( rect.size );
//	[profileimage.imageView.image drawInRect:rect];
//	UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	
//	NSData *imageData = UIImagePNGRepresentation(picture1);
//    
//    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
//	
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithString:postStr] dataUsingEncoding:NSUTF8StringEncoding]];  // message
//	
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%d.jpg\"\r\n",[AppDelegate sharedInstance].UserId]] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[NSData dataWithData:imageData]];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	[postRequest setHTTPBody:body];
//	
//	NSString * postString = [[NSString alloc]initWithData:postData encoding:NSASCIIStringEncoding];
//	
//	// Send data
//	NSURLResponse* response;
//	NSError* error = nil;
//	
//	NSData* data = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
//	NSString *result=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	
//	[postString release];
//	[result release];
//	[pool release];
//}

- (void)doAddEvents{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    

	NSDateFormatter *dateFormatterwsformat =  [[NSDateFormatter alloc] init];    
    [dateFormatterwsformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    

    
    NSString * currentdate = [dateFormatterwsformat stringFromDate:[NSDate date]];
    [dateFormatterwsformat release];
        //NSLog(@"current date = %@",currentdate);
    
    //NSLog(@"Place id = %@",placeid);
    /*
    NSString * urlstring = [NSString stringWithFormat:@"%@add_event.php?start_date=%@&end_date=%@&place_id=%@&lat=%f&long=%f&category=%@&url=%@&phone=%@&email=%@&description=%@&creator_id=%d&industry=%@&today=%@",kWebServiceUrl,[AppDelegate sharedInstance].AddEventStartDateWsFormatted,[AppDelegate sharedInstance].AddEventEndDateWsFormatted,placeid,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,lblcategory.text,txturl.text,txtemail.text,txtphone.text,txtdescription.text,[AppDelegate sharedInstance].UserId,industryid,currentdate]; 

   
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@add_event.php",kWebServiceUrl]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *strEventName=[NSString stringWithFormat:@"name=%@",txteventname.text];
    NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strEventName, NULL, CFSTR("&"), kCFStringEncodingUTF8);
    
    NSString *body = [NSString stringWithFormat:@"%@&%@",result,urlstring];
    
    NSData *requestBody = [body dataUsingEncoding:NSASCIIStringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBody];
    
    */
    
    NSString * urlstring = [NSString stringWithFormat:@"start_date=%@&end_date=%@&place_id=%@&lat=%f&long=%f&category=%@&url=%@&phone=%@&email=%@&description=%@&creator_id=%d&industry=%@&today=%@",[AppDelegate sharedInstance].AddEventStartDateWsFormatted,[AppDelegate sharedInstance].AddEventEndDateWsFormatted,placeid,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,lblcategory.text,txturl.text,txtemail.text,txtphone.text,txtdescription.text,[AppDelegate sharedInstance].UserId,industryid,currentdate]; 
    
    urlstring =[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@add_event.php",kWebServiceUrl]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *strEventName=[NSString stringWithFormat:@"name=%@",txteventname.text];
    NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strEventName, NULL, CFSTR("&"), kCFStringEncodingUTF8);
    
    NSString *body = [NSString stringWithFormat:@"%@&%@",result,urlstring];
    
    NSData *requestBody = [body dataUsingEncoding:NSASCIIStringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBody];
    
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSString *responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    

    
    
  
   // NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     // NSLog(@"url add event= %@",url);
   // NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"jsonREsponse = %@",jsonRes);
    NSString * strsignup = (NSString *)[[[responseString JSONValue] valueForKey:@"msg"] retain];
    
    if ([strsignup isEqualToString:@"Success"]) {
        
        
        [[AppDelegate sharedInstance] hideLoadingView];
        
        [self performSelectorOnMainThread:@selector(doconfrimation) withObject:nil waitUntilDone:YES];
        //DisplayAlertWithTitle(@"Event Added.", @"herematch");
        
        
    }
//	else if ([strsignup isEqualToString:@" You have already added one event "]) {
//		[[AppDelegate sharedInstance] hideLoadingView];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" You have already added one event " message:@" Update it? " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
//		[alert show];
//		[alert release];
//	}
    else{
        [[AppDelegate sharedInstance] hideLoadingView];
        DisplayAlertWithTitle(@"Add Event Failed ", @"herematch");
        
        
    }
	[strsignup release];
    [pool release];
}
- (void)doconfrimation{
    if (!confrimationalert) {
        confrimationalert = [[UIAlertView alloc] initWithTitle:@"herematch" message:@"Event Added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    [confrimationalert show];
}
-(void)callAgain
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
    NSString * urlstring = [NSString stringWithFormat:@"%@add_event.php?name=%@&start_date=%@&end_date=%@&place_id=%@&lat=%f&long=%f&category=%@&url=%@&phone=%@&email=%@&description=%@&creator_id=%d&industry=%@&code=007",kWebServiceUrl,txteventname.text,[AppDelegate sharedInstance].AddEventStartDateWsFormatted,[AppDelegate sharedInstance].AddEventEndDateWsFormatted,placeid,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,lblcategory.text,txturl.text,txtemail.text,txtphone.text,txtdescription.text,[AppDelegate sharedInstance].UserId,industryid];    
	
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//NSLog(@"url add event= %@",url);
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"jsonREsponse = %@",jsonRes);
    NSString * strsignup = [(NSString *)[jsonRes JSONValue] valueForKey:@"msg"];
    
    if ([strsignup isEqualToString:@"Success"]) {
        
        
        [[AppDelegate sharedInstance] hideLoadingView];
        DisplayAlertWithTitle(@"Event Added Successfully", @"herematch");
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else{
        
        [[AppDelegate sharedInstance] hideLoadingView];
        DisplayAlertWithTitle(@"Add Event Failed ", @"herematch");
        
        
    }
    [pool release];
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
        flag=0;
            
        
        checkedplace=0;
        checkedindustry=0;
        checkedcategory=0;
           
        
        
                
        [AppDelegate sharedInstance].isFromAddplace=FALSE;
        
        txteventname.text=@"";
        lblStartDate.text=@"Start Date/Time";
        lblEndDate.text=@"End Date/Time";
        lblindustry.text=@"Industry";
        lblcategory.text=@"Category";
        lblplace.text=@"Place";
        
        

    }


}

#pragma mark -
#pragma mark coreLocation methods

//-------------------------------------------------------------------------------------------------------------------

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {	
	
    [AppDelegate sharedInstance].location = newLocation;
    
    if (!flag) {
        if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@industry_list.php",kWebServiceUrl]]) {
            DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
            return;
        }
        if (!isWSCalled) {
            isWSCalled = YES;          
                     
            //[[AppDelegate sharedInstance] showLoadingView];
            
        
                [self performSelectorInBackground:@selector(downloadIndustriesAndPlaces) withObject:nil];
            
        
        }

        
    }
    else{        
        
       // [[AppDelegate sharedInstance] showLoadingView];
         if(checkFlag==FALSE){
             
             [self performSelectorInBackground:@selector(doAddEvents) withObject:nil];
             checkFlag=TRUE;
         }
    }
    
    [self.locationManager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
    DisplayAlertWithTitle(kLocationErrormsg, @"herematch");
	//NSLog(@"Error in Location Manager (GPS)");
}
#pragma mark -
#pragma mark UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
	if (actionSheet.tag == 3) {
		if (buttonIndex == 0) 
		{
			if (selectBtnTag==1) {
				//checkedplace = checkedplaceTmp;
                
                if (checkedplace==[arr_place count]-1) {
                    
                    [AppDelegate sharedInstance].isFromAddEvent = TRUE;
                    AddPlaceViewController * addplaceobj = [[AddPlaceViewController alloc] initWithNibName:@"AddPlaceView" bundle:nil];
                    [self.navigationController pushViewController:addplaceobj animated:YES];
                    [addplaceobj release]; 
                    return;
                }
                
				lblplace.text = [[arr_place objectAtIndex:checkedplace] valueForKey:@"name"];
				placeid = [[arr_place objectAtIndex:checkedplace] valueForKey:@"id"];
				
			}
			else if (selectBtnTag==2) {
				//checkedcategory = checkedcategoryTmp;
				[lblcategory setText:[[arr_category objectAtIndex:checkedcategory] valueForKey:@"category_name"]];
				
			}
			else if (selectBtnTag==3) {
				//checkedindustry = checkedindustryTmp;
				lblindustry.text = [[arr_industry objectAtIndex:checkedindustry] valueForKey:@"name"];
				industryid = [[arr_industry objectAtIndex:checkedindustry] valueForKey:@"name"];
				
			}
			
		}		
		if(buttonIndex ==1) 
		{
			
		}		
	}
	
	if (actionSheet.tag == 2) {
		if (buttonIndex == 0) 
		{
			UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
			ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
			ipc.delegate = self;
			//ipc.allowsImageEditing = YES;
			[self presentModalViewController:ipc animated:YES];
		}
		if(buttonIndex ==1) 
		{
			UIImagePickerController * picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			[self presentModalViewController:picker animated:YES];
		}
	}
    
    if (actionSheet.tag == 4) {
    
    if (buttonIndex == 0) 
    {
      
        [self setTextDate:[actionSheet viewWithTag:actionSheet.tag]];
        
    }	
	else{    
            
            [startdate retain];            
        
        }
    }
    
    if (actionSheet.tag == 5) {
        
        if (buttonIndex == 0) 
        {
           
            [self setTextDate:[actionSheet viewWithTag:actionSheet.tag]];
            
        }	
        else{           
           
              [enddate retain];   
        }
    }
}
#pragma mark -
#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	UIImage *imgProfile = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	[imgbutton setImage:imgProfile forState:UIControlStateNormal];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];
}
# pragma  mark label -
# pragma mark PickerViewDelegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (PickerView.tag==1) {
        return [arr_place count];
    }
    else if (PickerView.tag==2) {
        return [arr_category count];
    }
    else if (PickerView.tag==3) {
        return [arr_industry count];
    }
    //return nil;
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (PickerView.tag==1) {
         return [[arr_place objectAtIndex:row] valueForKey:@"name"];
    }
    else if (PickerView.tag==2) {
        return [[arr_category objectAtIndex:row] valueForKey:@"category_name"];
    }
    else if (PickerView.tag==3) {
        return [[arr_industry objectAtIndex:row] valueForKey:@"name"];
        
    }
    return nil;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if (PickerView.tag==1) {
//        lblplace.text = [[arr_place objectAtIndex:row] valueForKey:@"name"];
//       placeid = [[arr_place objectAtIndex:row] valueForKey:@"id"];
        //checkedplaceTmp = row;
        
        
        
        checkedplace=row;
    }
    else if (PickerView.tag==2) {
//        [lblcategory setText:[[arr_category objectAtIndex:row] valueForKey:@"category_name"]];
        //checkedcategoryTmp = row;
        checkedcategory=row;
    }
    else if (PickerView.tag==3) {
//        lblindustry.text = [[arr_industry objectAtIndex:row] valueForKey:@"name"];
//        industryid = [[arr_industry objectAtIndex:row] valueForKey:@"name"];
         //checkedindustryTmp = row;
        checkedindustry=row;
    }
    
    
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        scrollView.frame=CGRectMake(0, 50, 320,511);
        scrollView.contentSize=CGSizeMake(320, 620);
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
        scrollView.frame=CGRectMake(0, 0, 320,511);
         scrollView.contentSize=CGSizeMake(320, 570);
        // banner is visible and we move it out of the screen, due to connection issue
         banner.frame = CGRectOffset(banner.frame,0, -banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}
#pragma mark - Action Methods




#pragma mark - TextField Delegate Methods


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	
	//[[self.view viewWithTag:300] removeFromSuperview];
    //    int tag = textField.tag;
    //	if (tag >= 105) {
    //        [self.tableview setContentSize:CGSizeMake(self.tableview.frame.size.width, self.tblSignup.frame.size.height + 200)];
    //        [self scrollTableToTextField:textField.tag];
    //    }
    
    
    
    
	return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
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
    
    [txteventname resignFirstResponder];
    return YES;
    
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
    [arr_category release];
    [arr_industry release];
    [arr_place release];
    [txteventname release];
    [txturl release];
    [txtemail release];
    [txtphone release];
    [txtdescription release];
    [lblplace release];
    [lblindustry release];
    [lblcategory release];
    [lblStartDate release];
    [lblEndDate release];
    [scrollView release];
    [_locationManager release];
    [obj release];
    [confrimationalert release];
    [super dealloc];
     
}

@end
