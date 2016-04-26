//
//  ProfileViewController.m
//  HereMatch
//
//  Created by apple  on 9/2/11.
//  Copyright 2011 . All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"


//#define kImageWSUploadURl @"http://www.openxcellaus.info/herematch/user_image.php"

static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;

@implementation ProfileViewController

@synthesize profileScrollView,oAuth2FBLoginView,oAuthLoginView,bannerIsVisible;
//@synthesize txtIndustryTag;
//@synthesize txtIndustry1Tag;
//@synthesize txtIndustry2Tag;
//@synthesize txtIndustry3Tag;
//@synthesize arrIndustryCategoryList;
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
    
//    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[self clearViewForReLoad];
	doneButton.hidden = YES;
	phonecheck=0;
	
	arrIndustryCategoryList =[[NSMutableArray alloc] init];
	profileScrollView.contentSize = CGSizeMake(320,3050);
	CGPoint topOffset = CGPointMake(0,0);
    [profileScrollView setContentOffset:topOffset animated:YES];
	
	
	arrStates = [[NSArray alloc] initWithObjects:@"",@"AL",@"AK",@"AZ",@"AR",@"CA",@"CO",@"CT",@"DE",@"FL",@"GA",@"HI",@"ID",@"IL",@"IN",@"IA",@"KS",@"KY",@"LA",@"ME",@"MD",@"MA",@"MI",@"MN",@"MS",@"MO",@"MT",@"NE",@"NV",@"NH",@"NJ",@"NM",@"NY",@"NC",@"ND",@"OH",@"OK",@"OR",@"PA",@"RI",@"SC",@"SD",@"TN",@"TX",@"UT",@"VT",@"VA",@"WA",@"WV",@"WI",@"WY",@"AS",@"DC",@"FM",@"GU",@"MH",@"MP",@"PW",@"PR",@"PR",@"VI",nil];
    
    
    arrYears = [[NSMutableArray alloc] init];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"YYYY"];
    
    NSString *strYear = [outputFormatter stringFromDate:[NSDate date]];
    NSInteger getYear = [strYear integerValue];
    
    NSInteger key;
    [arrYears addObject:@""];// this for display the blank year only.
    for (key = (getYear+5); key >= (getYear-70); key--) {
        [arrYears addObject:[NSString stringWithFormat:@"%d",key]];
    }
    
	[outputFormatter release];
    profileScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor]; 
    
    
       
}

-(void)viewWillAppear:(BOOL)animated
{
    
//    if (!adView) {
//        adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
//        adView.frame = CGRectOffset(adView.frame, 0, -50);
//        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
//        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
//        [self.view addSubview:adView];
//        adView.delegate=self;
//        self.bannerIsVisible=NO;  
//    }
    
    btnHomeTown.titleLabel.textAlignment = UITextAlignmentCenter;
    btnIndustry.titleLabel.textAlignment = UITextAlignmentCenter;

    	phonecheck=0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardDidShow:) 
                                                     name:UIKeyboardDidShowNotification 
                                                   object:nil];        
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillShow:) 
                                                     name:UIKeyboardWillShowNotification 
                                                   object:nil];
    }
    
	if (imgGetTag == 1) {
		imgGetTag = 0;
	}
	else {
        
        tagPhoto = 0;
		[self clearViewForReLoad];
        
        if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@industry_list.php",kWebServiceUrl]]) {
            DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
            return;
        }
        
      
            
            [[AppDelegate sharedInstance] showLoadingView];
            [self performSelectorInBackground:@selector(doStartLoading) withObject:nil];
     
      
    
	}
    
    //UIBarButtonItem * btnLogout = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystem target:self action:@selector(btnLogout_Clicked)];
    //self.navigationItem.rightBarButtonItem = btnLogout;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"settings1.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnLogout_Clicked) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 35, 30)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    
    
    NSString * urlstring = [NSString stringWithFormat:@"http://herematch.com:3000/ws_herematch/check_access_token.php?user_id=%d",[AppDelegate sharedInstance].UserId];
    
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    
    NSString * strOpenFB = [(NSString *)[jsonRes JSONValue] valueForKey:@"F"];
    NSString * strOpenLD= [(NSString *)[jsonRes JSONValue] valueForKey:@"L"];
    NSString * strOpenTW= [(NSString *)[jsonRes JSONValue] valueForKey:@"T"];
    if ([strOpenFB isEqualToString:@"1"]) {
        [btnAddFacebook setHidden:YES];
        [btnDisconnectFB setHidden:NO];
    }else if([strOpenFB isEqualToString:@"0"]){
        [btnAddFacebook setHidden:NO];
        [btnDisconnectFB setHidden:YES];
    }
    
    if ([strOpenLD isEqualToString:@"1"]) {
        [btnAddLinkdin setHidden:YES];
        [btnDisconnectLd setHidden:NO];
    }else if([strOpenLD isEqualToString:@"0"]){
        [btnAddLinkdin setHidden:NO];
        [btnDisconnectLd setHidden:YES];
    }
    
    
    if ([strOpenTW isEqualToString:@"1"]) {
        [btnAddTwitter setHidden:YES];
        [btnDisconnectTw setHidden:NO];
    }else if([strOpenTW isEqualToString:@"0"]){
        [btnAddTwitter setHidden:NO];
        [btnDisconnectTw setHidden:YES];
    }

    
    //UIBarButtonItem *btnLogout=[[UIBarButtonItem alloc]initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(btnLogout_Clicked)];
    //self.navigationItem.rightBarButtonItem=btnLogout;
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardDidShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    
    
}
#pragma mark -
#pragma mark custom methods

-(void)btnLogout_Clicked
{
    //[(UITabBarController *)self.parentViewController setSelectedIndex:2];
	//[self clearViewForReLoad];
    SettingsViewController *objSettings = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
    [self.navigationController pushViewController:objSettings animated:YES];
    [objSettings release];

}
- (void)doStartLoading
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	//Begin DropDown..
	
	NSString * urlstring1 = [NSString stringWithFormat:@"%@industry_list.php",kWebServiceUrl];
    NSURL *url1 = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
	//NSLog(@"userID:%d",[AppDelegate sharedInstance].UserId);
	
    NSString * jsonRes1 = [NSString stringWithContentsOfURL:url1 encoding:NSUTF8StringEncoding error:nil];

	[arrIndustryCategoryList setArray:[[jsonRes1 JSONValue] valueForKey:@"Industry"]];	
    [arrIndustryCategoryList insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@" ",@"name",@"0",@"ind_id", nil] atIndex:0];
	//[arrIndustryCategoryList removeObjectAtIndex:0];
	//..
  
	//Begin Detail..
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@user_details_byId.php?id=%d",kWebServiceUrl,[AppDelegate sharedInstance].UserId]];
    //NSLog(@"profile url = %@",url);
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	dictLoginUserdetail = [[NSMutableDictionary alloc] init];
	
	[dictLoginUserdetail setValuesForKeysWithDictionary:[(NSMutableDictionary*)[jsonRes JSONValue] valueForKey:@"data"]]; 
    NSString *strPhotoFileName = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"photo_file_name"]];
	 //= [dictLoginUserdetail valueForKey:@"photo_file_name"];
    //NSLog(@"image name = %@",strPhotoFileName);
	if ([strPhotoFileName isEqualToString:@"(null)"] || [strPhotoFileName isEqualToString:@""]) {
		//[profileimage setImage:[UIImage imageNamed:@"profile-default.png"] forState:UIControlStateNormal];
	}else {
		//NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kUserImageWSURl,strPhotoFileName]];
        
        if ([AppDelegate sharedInstance].checkTWLD==FALSE) {
            NSString *strURl=[NSString stringWithFormat:@"http://herematch.com:3000/system/photos/%d/original/%@",[AppDelegate sharedInstance].UserId,strPhotoFileName];
            
            strURl=[strURl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:strURl];
            
            
            // NSLog(@" url %@",url);
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:imageData];
            [profileimage setImage:image forState:UIControlStateNormal];
        }else
        {
            tagPhoto=5;
            [AppDelegate sharedInstance].checkTWLD=TRUE;
          
        }
        
	}
	
	//..
    
	
	[[AppDelegate sharedInstance] hideLoadingView];
    
    if ([AppDelegate sharedInstance].checkTWLD==FALSE) {
        
       [self performSelectorOnMainThread:@selector(viewLoginUserData) withObject:nil waitUntilDone:NO]; 
    }else
    {
        [AppDelegate sharedInstance].checkTWLD=TRUE;
        
    }
	
	[pool release];
}
-(void)viewLoginUserData
{
	NSString *strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"title"]] retain];
     //NSLog(@"strtemp = %@",strTemp);
	if (![strTemp isEqualToString:@"(null)"]) {
		txtTitle.text = strTemp;
		NSString *text = txtTitle.text;
		if ([text length] > 0) {
			NSString *caplitalized = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
			txtTitle.text = caplitalized;
		}else {
			txtTitle.text = @"";
		}
	}
	else {
		txtTitle.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"first_name"]] retain];
   // NSLog(@"strtemp = %@",strTemp);
	if (![strTemp isEqualToString:@"(null)"]) {
		txtFirstName.text = strTemp;
		NSString *text = txtFirstName.text;
		if ([text length] > 0) {
			NSString *caplitalized = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
			txtFirstName.text = caplitalized;
		}else {
			txtFirstName.text = @"";
		}
	}
	else {
		txtFirstName.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"last_name"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtLastName.text = strTemp;
		NSString *text = txtLastName.text;
		if ([text length] > 0) {
			NSString *caplitalized = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
			txtLastName.text = caplitalized;
		}else {
			txtLastName.text = @"";
		}
	}
	else {
		txtLastName.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"location_city"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtLocationCity.text = strTemp;
		NSString *text = txtLocationCity.text;
		if ([text length] > 0) {
			NSString *caplitalized = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
			txtLocationCity.text = caplitalized;
		}else {
			txtLocationCity.text = @"";
		}
	}
	else {
		txtLocationCity.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"location_state"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtLocationState.text = strTemp;
	}
	else {
		txtLocationState.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_name"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtindustry.text = strTemp;
		txtIndustryTag = [[dictLoginUserdetail valueForKey:@"industry"] retain];
	}
	else {
		txtindustry.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail objectForKey:@"bio"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtBio.text = strTemp;
	}
	else {
		txtBio.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"email"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtEmail.text = strTemp;
	}
	else {
		txtEmail.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"headline"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtHeadLine.text = strTemp;
		NSString *text = txtHeadLine.text;
		if ([text length] > 0) {
			NSString *caplitalized = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
			txtHeadLine.text = caplitalized;
		}else {
			txtHeadLine.text = @"";
		}
		
	}
	else {
		txtHeadLine.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"phone"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtPhoneNo1.text = strTemp;
	}
	else {
		txtPhoneNo1.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
    
    
    
    strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"phone2"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtPhoneNo2.text = strTemp;
	}
	else {
		txtPhoneNo2.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
    
    
    
    strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"phone3"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtPhoneNo3.text = strTemp;
	}
	else {
		txtPhoneNo3.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
    
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"url"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtURL.text = strTemp;
	}
	else {
		txtURL.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"company"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtCompany.text = strTemp;
		NSString *text = txtCompany.text;
		if ([text length] > 0) {
			NSString *caplitalized = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
			txtCompany.text = caplitalized;
		}else {
			txtCompany.text = @"";
		}
	}
	else {
		txtCompany.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"school"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtEduSchool.text = strTemp;
		NSString *text = txtEduSchool.text;
		if ([text length] > 0) {
			NSString *caplitalized = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
			txtEduSchool.text = caplitalized;
		}else {
			txtEduSchool.text = @"";
		}
		
	}
	else {
		txtEduSchool.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"graduation_year"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtEduGraduationYear.text = strTemp;
		NSString *text = txtEduGraduationYear.text;
		if ([text length] > 0) {
			NSString *caplitalized = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
			txtEduGraduationYear.text = caplitalized;
		}else {
			txtEduGraduationYear.text = @"";
		}
	}
	else {
		txtEduGraduationYear.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"major"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtEduMajor.text = strTemp;
		NSString *text = txtEduMajor.text;
		if ([text length] > 0) {
			NSString *caplitalized = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
			txtEduMajor.text = caplitalized;
		}else {
			txtEduMajor.text = @"";
		}
	}
	else {
		txtEduMajor.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"hometown_city"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtHomeTownCity.text = strTemp;
		NSString *text = txtHomeTownCity.text;
		if ([text length] > 0) {
			NSString *caplitalized = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
			txtHomeTownCity.text = caplitalized;
		}else {
			txtHomeTownCity.text = @"";
		}


	}
	else {
		txtHomeTownCity.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"hometown_state"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtHomeTownState.text = strTemp;
	}
	else {
		txtHomeTownState.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_interested_1_name"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtIndustryInterested1.text = strTemp;
	}
	else {
		txtIndustryInterested1.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_interested_1_name"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtIndustryInterested1.text = strTemp;
		txtIndustry1Tag = [[dictLoginUserdetail valueForKey:@"industry_interested_1"] retain];
	}
	else {
		txtIndustryInterested1.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_interested_2_name"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtIndustryInterested2.text = strTemp;
		txtIndustry2Tag = [[dictLoginUserdetail valueForKey:@"industry_interested_2"] retain];
	}
	else {
		txtIndustryInterested2.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_interested_3_name"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtIndustryInterested3.text = strTemp;
		txtIndustry3Tag = [[dictLoginUserdetail valueForKey:@"industry_interested_3"] retain];
	}
	else {
		txtIndustryInterested3.text = @"";
	}
	[strTemp release];//
	strTemp = nil;

	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"interests"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtInterests.text = strTemp;		
	}
	else {
		txtInterests.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	
	strTemp = [[NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"groups"]] retain];
	if (![strTemp isEqualToString:@"(null)"]) {
		txtAssociations.text = strTemp;		
	}
	else {
		txtAssociations.text = @"";
	}
	[strTemp release];//
	strTemp = nil;
	//txtTitle.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"title"]];
	//txtFirstName.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"first_name"]];
	//txtLastName.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"last_name"]];
	//txtLocationCity.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"location_city"]];
	//txtLocationState.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"location_state"]];
	
	//txtindustry.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_name"]];
	//txtIndustryTag = [dictLoginUserdetail valueForKey:@"industry"];
	
	//txtBio.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail objectForKey:@"bio"]];
	//txtEmail.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"email"]];
	//txtHeadLine.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"headline"]];
	//txtPhoneNo.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"phone"]];
	//txtURL.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"url"]];
	//txtCompany.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"company"]];
	//txtEduSchool.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"school"]];
	//txtEduGraduationYear.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"graduation_year"]];
	//txtEduMajor.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"major"]];
	//txtHomeTownCity.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"hometown_city"]];
	//txtHomeTownState.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"hometown_state"]];
	
	//txtIndustryInterested1.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_interested_1_name"]];
	//txtIndustry1Tag = [dictLoginUserdetail valueForKey:@"industry_interested_1"];
	
	//txtIndustryInterested2.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_interested_2_name"]];
	//txtIndustry2Tag = [dictLoginUserdetail valueForKey:@"industry_interested_2"];	
	
	//txtIndustryInterested3.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"industry_interested_3_name"]];
	//txtIndustry3Tag = [dictLoginUserdetail valueForKey:@"industry_interested_3"];	
	
	//txtInterests.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"interests"]];
	//txtAssociations.text = [NSString stringWithFormat:@"%@",[dictLoginUserdetail valueForKey:@"groups"]];
	for (int i = 0; i < [arrStates count]; i++) {
		if ([txtLocationState.text isEqualToString:[arrStates objectAtIndex:i]]) {
			selectedStateLS = i;
		}		
	}
	for (int i = 0; i < [arrStates count]; i++) {
		if ([txtHomeTownState.text isEqualToString:[arrStates objectAtIndex:i]]) {
			selectedStateHS = i;
		}		
	}
    NSInteger tagChechYears = 5;
	for (int i = 0; i < [arrYears count]; i++) {
		if ([txtEduGraduationYear.text isEqualToString:[arrYears objectAtIndex:i]]) {
			
            selectedYear = i;
            //NSLog(@"years = %@",[arrYears objectAtIndex:i]);
            if ([[arrYears objectAtIndex:i] isEqualToString:@"0"]) {
               txtEduGraduationYear.text = @""; 
            }
            else{
                txtEduGraduationYear.text = [arrYears objectAtIndex:i];
            }
            
            tagChechYears = 11;
		}		
	}
    if (tagChechYears == 11) {
        
    }
    else
    {
        txtEduGraduationYear.text = @"";
        selectedYear = 0;
    }
	NSInteger key = 0;
	for (key = 0; key < [arrIndustryCategoryList count]; key++) {
		if ([txtIndustryTag isEqualToString:[[arrIndustryCategoryList objectAtIndex:key] valueForKey:@"ind_id"]]) {
			selectedRowInd = key;
		}
		if ([txtIndustry1Tag isEqualToString:[[arrIndustryCategoryList objectAtIndex:key] valueForKey:@"ind_id"]]) {
			selectedRowInd1 = key;
		}
		if ([txtIndustry2Tag isEqualToString:[[arrIndustryCategoryList objectAtIndex:key] valueForKey:@"ind_id"]]) {
			selectedRowInd2 = key;
		}
		if ([txtIndustry3Tag isEqualToString:[[arrIndustryCategoryList objectAtIndex:key] valueForKey:@"ind_id"]]) {
			selectedRowInd3 = key;
		}
	}

}
-(void)clickSaveChanges
{
        [self resignkeyboard];
	CGPoint topOffset = CGPointMake(0,0);
    [profileScrollView setContentOffset:topOffset animated:YES];
    
    if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@industry_list.php",kWebServiceUrl]]) {
        DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
        return;
    }

	[[AppDelegate sharedInstance] showLoadingView];
    [self performSelectorInBackground:@selector(doSaveChaged) withObject:nil];
}
-(void)doSaveChaged
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	if (tagPhoto == 5) {

        
	NSString* url1 = [NSString stringWithFormat:@"http://herematch.com:3000/ws_herematch/user_image.php"];
    NSMutableData* postData = [[NSMutableData new] autorelease];
    NSMutableData * body = [[NSMutableData alloc] init];
    
    NSString *postStr=[NSString stringWithFormat:@"image="];
	[postData appendData:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* postRequest = [[NSMutableURLRequest alloc] init];
	[postRequest setURL:[NSURL URLWithString:url1]];
	[postRequest setHTTPMethod:@"POST"];
	
	CGRect rect=CGRectMake(0,0,75,100);
	UIGraphicsBeginImageContext( rect.size );
	[profileimage.imageView.image drawInRect:rect];
	UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSData *imageData = UIImagePNGRepresentation(picture1);
    
        
        
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:postStr] dataUsingEncoding:NSUTF8StringEncoding]];  // message
     
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%d.jpg\"\r\n",[AppDelegate sharedInstance].UserId]] dataUsingEncoding:NSUTF8StringEncoding]];
        
       // NSLog(@"image name:%d.jpg",[AppDelegate sharedInstance].UserId);
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postRequest setHTTPBody:body];
	
	//NSString * postString = [[NSString alloc]initWithData:postData encoding:NSASCIIStringEncoding];
	
	// Send dataaa
	NSURLResponse* response;
	NSError* error = nil;
	
	NSData* data = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
	NSString *result=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //NSLog(@"result = %@ ",result);
	
		[body release];
		[result release];
		[postRequest release]; 
	//[postString release];
	//[result release];
	
	}
    
    
    NSString *strATokenFB = [[NSUserDefaults standardUserDefaults] objectForKey:@"FBAT"];
    
    NSString *strATKTweet = [[NSUserDefaults standardUserDefaults] objectForKey:@"OATK"];
    
    NSString *strATSTweet = [[NSUserDefaults standardUserDefaults] objectForKey:@"OATS"];
    
    
    NSString *strRequestToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"ART"];
    
    NSString *strAccessToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"AAT"];
    
   // NSLog(@"FBT : %@ , LIART : %@ , LIAAT : %@ ",strATokenFB,strRequestToken,strAccessToken);
    
   // NSLog(@"request token = %@",strRequestToken);
   // NSLog(@"access token = %@",strAccessToken);
    
    NSArray *arrRequestToken=[strRequestToken componentsSeparatedByString:@" "];
    NSArray *arrAccessToken=[strAccessToken componentsSeparatedByString:@" "];
    
    //NSLog(@"request token : %@",arrRequestToken);
   // NSLog(@"access token : %@",arrAccessToken);
    
 //   NSLog(@"Request_oauth_token : %@",[arrRequestToken objectAtIndex:1]);
  //  NSLog(@"oauth_token_secret : %@",[arrRequestToken objectAtIndex:3]);
  //  NSLog(@"oauth_verifier : %@",[arrRequestToken objectAtIndex:5]);
  //  NSLog(@"Access_oauth_token : %@",[arrAccessToken objectAtIndex:1]);
  //  NSLog(@"oauth_token_secret : %@",[arrAccessToken objectAtIndex:3]);
    
    //    NSString *strQueryStar1=[NSString stringWithFormat:@"%@",[arrRequestToken objectAtIndex:1]];
    //    strQueryStar1 = [strQueryStar1 substringToIndex:[strQueryStar1 length]-1];
    //    strQueryStar1 = [[strQueryStar1 substringFromIndex:1] copy];
    //    
    //    NSString *strQueryStar2=[NSString stringWithFormat:@"%@",[arrRequestToken objectAtIndex:3]];
    //    strQueryStar2 = [strQueryStar2 substringToIndex:[strQueryStar2 length]-1];
    //    strQueryStar2 = [strQueryStar2 substringFromIndex:1];
    //    
    //    NSString *strQueryStar3=[NSString stringWithFormat:@"%@",[arrRequestToken objectAtIndex:5]];
    //    strQueryStar3 = [strQueryStar3 substringToIndex:[strQueryStar3 length]-1];
    //    strQueryStar3 = [strQueryStar3 substringFromIndex:1];
    
    NSString *strQueryStar4=[NSString stringWithFormat:@"%@",[arrAccessToken objectAtIndex:1]];
    strQueryStar4 = [strQueryStar4 substringToIndex:[strQueryStar4 length]-1];
    strQueryStar4 = [strQueryStar4 substringFromIndex:1];
    
    NSString *strQueryStar5=[NSString stringWithFormat:@"%@",[arrAccessToken objectAtIndex:3]];
    strQueryStar5 = [strQueryStar5 substringToIndex:[strQueryStar5 length]-1];
    strQueryStar5 = [strQueryStar5 substringFromIndex:1];
    //NSLog(@"my industry = %@, ind1 = %@ , ind2 = %@, ind3 = %@ ",txtIndustryTag,txtIndustry1Tag,txtIndustry2Tag,txtIndustry3Tag);
    
   // NSLog(@"LAT : %@,%@",strQueryStar4,strQueryStar5);
    
    if (!strATKTweet) {
        strATKTweet=@"null";
    }
    if(!strATSTweet)
    {
        strATSTweet=@"null";
    }
    
    if (!strATokenFB) {
        
         strATokenFB=@"null";
    }
    
    //NSLog(@"my industry = %@, ind1 = %@ , ind2 = %@, ind3 = %@ ",txtIndustryTag,txtIndustry1Tag,txtIndustry2Tag,txtIndustry3Tag);
   // http://herematch.com:3000/ws_herematch/
    
    /*
    NSString  *urlstring = [[NSString stringWithFormat:@"%@update_profile.php?id=%d&email=%@&first_name=%@&last_name=%@&industry=%@&industry_interested_1=%@&industry_interested_2=%@&industry_interested_3=%@&headline=%@&bio=%@&phone1=%@&phone2=%@&phone3=%@&url=%@&company=%@&title=%@&school=%@&graduation_year=%@&major=%@&interests=%@&hometown_city=%@&hometown_state=%@&location_city=%@&location_state=%@&groups=%@&fb_access_token=%@&access_token=%@&access_token_secret=%@&oauth_token=%@&oauth_token_secret=%@",@"http://herematch.com:3000/ws_herematch/",[AppDelegate sharedInstance].UserId,txtEmail.text,txtFirstName.text,txtLastName.text,txtIndustryTag,txtIndustry1Tag,txtIndustry2Tag,txtIndustry3Tag,txtHeadLine.text,txtBio.text,txtPhoneNo1.text,txtPhoneNo2.text,txtPhoneNo3.text,txtURL.text,txtCompany.text,txtTitle.text,txtEduSchool.text,txtEduGraduationYear.text,txtEduMajor.text,txtInterests.text,txtHomeTownCity.text,txtHomeTownState.text,txtLocationCity.text,txtLocationState.text,txtAssociations.text,strATokenFB,strQueryStar4,strQueryStar5,strATKTweet,strATSTweet] retain];

    
*/
    
    NSLog(@"%@",txtEmail.text);
    NSLog(@"%@",txtFirstName.text);
    NSLog(@"%@",txtLastName.text);
    NSLog(@"%@",[txtIndustryTag retain]);
    NSLog(@"%@",txtIndustry1Tag);
    NSLog(@"%@",txtIndustry2Tag);
    NSLog(@"%@",txtIndustry3Tag);
    NSLog(@"%@",txtHeadLine.text);
    NSLog(@"%@",txtBio.text);
    NSLog(@"%@",txtPhoneNo1.text);
    NSLog(@"%@",txtPhoneNo2.text);
    NSLog(@"%@",txtPhoneNo3.text);
    NSLog(@"%@",txtURL.text);
     NSLog(@"%@",txtCompany.text);
     NSLog(@"%@",txtTitle.text);
     NSLog(@"%@",txtEduSchool.text);
     NSLog(@"%@",txtEduGraduationYear.text);
     NSLog(@"%@",txtEduMajor.text);
     NSLog(@"%@",txtInterests.text);
    NSLog(@"%@",txtHomeTownCity.text);
    NSLog(@"%@",txtHomeTownCity.text);
    NSLog(@"%@",txtLocationCity.text);
    NSLog(@"%@",txtLocationState.text);
     NSLog(@"%@",txtAssociations.text);
    
     NSString  *urlstring = [[NSString stringWithFormat:@"%@update_profile.php?id=%d&email=%@&first_name=%@&last_name=%@&industry=%@&industry_interested_1=%@&industry_interested_2=%@&industry_interested_3=%@&headline=%@&bio=%@&phone1=%@&phone2=%@&phone3=%@&url=%@&company=%@&title=%@&school=%@&graduation_year=%@&major=%@&interests=%@&hometown_city=%@&hometown_state=%@&location_city=%@&location_state=%@&groups=%@",kWebServiceUrl,[AppDelegate sharedInstance].UserId,txtEmail.text,txtFirstName.text,txtLastName.text,txtIndustryTag,txtIndustry1Tag,txtIndustry2Tag,txtIndustry3Tag,txtHeadLine.text,txtBio.text,txtPhoneNo1.text,txtPhoneNo2.text,txtPhoneNo3.text,txtURL.text,txtCompany.text,txtTitle.text,txtEduSchool.text,txtEduGraduationYear.text,txtEduMajor.text,txtInterests.text,txtHomeTownCity.text,txtHomeTownCity.text,txtLocationCity.text,txtLocationState.text,txtAssociations.text] retain];    
     
     
    
    
    
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
   // NSLog(@"profileupdate url = %@",url);

    
	NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSString * strsignup = [(NSString *)[jsonRes JSONValue] valueForKey:@"msg"];
   // NSLog(@"responce %@",strsignup);
    if ([strsignup isEqualToString:@"Record has been updated successfully"]) {
		[[AppDelegate sharedInstance] hideLoadingView];
        DisplayAlertWithTitle(@"Profile Updated Successfully.", @"herematch");
		//self.tabBarController.selectedIndex  = 1;
    }
    else if ([strsignup isEqualToString:@"email address already exists"]) {
		[[AppDelegate sharedInstance] hideLoadingView];
        DisplayAlertWithTitle(@"Email Address Already Exits. Please Try Again.", @"herematch");
		//self.tabBarController.selectedIndex  = 1;
    }
    else{
        [[AppDelegate sharedInstance] hideLoadingView];
        DisplayAlertWithTitle(@"Profile Update Failed. Please Try Again.", @"herematch");
	}
	[urlstring release];
    [pool release];
	
}
- (void) resignkeyboard{
    [txtBio resignFirstResponder];
	[txtInterests resignFirstResponder];
	
	[txtLocationCity resignFirstResponder];
	[txtLocationState resignFirstResponder];
    
	[txtTitle resignFirstResponder];
    [txtFirstName resignFirstResponder];
	[txtLastName resignFirstResponder];
	
	[txtEmail resignFirstResponder];
	[txtHeadLine resignFirstResponder];
	[txtPhoneNo1 resignFirstResponder];
    [txtPhoneNo2 resignFirstResponder];
    [txtPhoneNo3 resignFirstResponder];
    
	[txtURL resignFirstResponder];
	[txtCompany resignFirstResponder];
	[txtEduSchool resignFirstResponder];
	[txtEduGraduationYear resignFirstResponder];
	[txtEduMajor resignFirstResponder];
	[txtHomeTownCity resignFirstResponder];
	[txtHomeTownState resignFirstResponder];
	[txtAssociations resignFirstResponder];

}
-(void)ShowPikerView:(id) sender{
    [self resignkeyboard];
		UIButton * btn = sender; 
	btnTag = btn.tag;
    UIActionSheet *ActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Done" otherButtonTitles:nil];
    
    ActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [ActionSheet setBounds:CGRectMake(0, 0, 320, 250)];
    PickerView = [[UIPickerView alloc] init];
    PickerView.delegate = self;
    PickerView.dataSource = self;
    PickerView.showsSelectionIndicator=YES;
	[ActionSheet addSubview:PickerView];
	ActionSheet.tag = 4;
	[ActionSheet showInView:self.parentViewController.tabBarController.view];
	if (btnTag == 1) {
        PickerView.tag=1;
		[PickerView selectRow:selectedRowInd inComponent:0 animated:NO];
	}
	if (btnTag == 2) {
                PickerView.tag=2;
		[PickerView selectRow:selectedRowInd1 inComponent:0 animated:NO];
	}
	if (btnTag == 3) {
                PickerView.tag=3;
		[PickerView selectRow:selectedRowInd2 inComponent:0 animated:NO];

	}
	if (btnTag == 4) {
                PickerView.tag=4;
		[PickerView selectRow:selectedRowInd3 inComponent:0 animated:NO];
	}
	[PickerView release];
    [ActionSheet release];
}
-(void)clickGetImageFromUIPicker
{
	imgGetTag = 1;
	actionsheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose from Library",nil];
	[actionsheet showFromTabBar:self.tabBarController.tabBar];
	actionsheet.tag = 2;
	[actionsheet release];
}


-(void)clickGetStates:(id)sender
{
    UIButton *btn = sender;
    btnTag = btn.tag; 
    //NSLog(@"Arr States : %@",arrStates);
    [txtBio resignFirstResponder];
    [txtInterests resignFirstResponder];
    
    [txtLocationCity resignFirstResponder];
    
    [txtTitle resignFirstResponder];
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    
    [txtEmail resignFirstResponder];
    [txtHeadLine resignFirstResponder];
    [txtPhoneNo1 resignFirstResponder];
    [txtPhoneNo2 resignFirstResponder];
    [txtPhoneNo3 resignFirstResponder];
    
    [txtURL resignFirstResponder];
    [txtCompany resignFirstResponder];
    [txtEduSchool resignFirstResponder];
    //    [txtEduGraduationYear resignFirstResponder];
    [txtEduMajor resignFirstResponder];
    [txtHomeTownCity resignFirstResponder];
	[txtAssociations resignFirstResponder];
    //    [txtHomeTownState resignFirstResponder];
    UIActionSheet *ActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Done" otherButtonTitles:nil];
    
    ActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    //MilestonePickerSheet.tag = 1;
    [ActionSheet setBounds:CGRectMake(0, 0, 320, 250)];
    PickerView = [[UIPickerView alloc] init];
    PickerView.delegate = self;
    PickerView.dataSource = self;
    PickerView.showsSelectionIndicator=TRUE;
    
    //[self pickerView:PickerView didSelectRow:0 inComponent:0];
	if (btnTag == 11) {
		[PickerView selectRow:selectedStateHS inComponent:0 animated:NO];
	}
	if (btnTag == 22) {
		[PickerView selectRow:selectedStateLS inComponent:0 animated:NO];
	}
    [ActionSheet addSubview:PickerView];
	[ActionSheet showInView:self.parentViewController.tabBarController.view];
	ActionSheet.tag = 1;
    [PickerView release];
    [ActionSheet release];
    
}
-(void)clickGetYear:(id)sender
{
    UIButton *btn = sender;
    btnTag = btn.tag; 
    //NSLog(@"Arr States : %@",arrYears);
    [txtBio resignFirstResponder];
    [txtInterests resignFirstResponder];
    
    [txtLocationCity resignFirstResponder];
    //    [txtLocationState resignFirstResponder];
    
    [txtTitle resignFirstResponder];
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    
    [txtEmail resignFirstResponder];
    [txtHeadLine resignFirstResponder];
    [txtPhoneNo1 resignFirstResponder];
    [txtPhoneNo2 resignFirstResponder];
    [txtPhoneNo3 resignFirstResponder];
    
    [txtURL resignFirstResponder];
    [txtCompany resignFirstResponder];
    [txtEduSchool resignFirstResponder];
    [txtEduMajor resignFirstResponder];
    [txtHomeTownCity resignFirstResponder];
	[txtAssociations resignFirstResponder];
    UIActionSheet *ActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Done" otherButtonTitles:nil];
    
    ActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    //MilestonePickerSheet.tag = 1;
    [ActionSheet setBounds:CGRectMake(0, 0, 320, 250)];
    PickerView = [[UIPickerView alloc] init];
    PickerView.delegate = self;
    PickerView.dataSource = self;
    PickerView.showsSelectionIndicator=TRUE;
    [PickerView selectRow:selectedYear inComponent:0 animated:NO];
    [ActionSheet addSubview:PickerView];
	ActionSheet.tag = 3;
	[ActionSheet showInView:self.parentViewController.tabBarController.view];
	[PickerView release];
    [ActionSheet release];    
}


-(IBAction)twitter_Click:(id)sender{
    NSLog(@"\n\n\n ShkTwitter");
  
   // http://herematch.com/ws_herematch/check_access_token.php?user_id=103
    
    
    NSString * urlstring = [NSString stringWithFormat:@"http://herematch.com:3000/ws_herematch/check_access_token.php?user_id=%d",[AppDelegate sharedInstance].UserId];
    
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
     NSString * strOpenTwitter = [(NSString *)[jsonRes JSONValue] valueForKey:@"T"];
    
    if ([strOpenTwitter isEqualToString:@"1"]) {
        
        NSString  *urlstring = [NSString stringWithFormat:@"%@twitter_remove_token.php?id=%d",kWebServiceUrl,[AppDelegate sharedInstance].UserId];    
        NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        //   NSLog(@"profileupdate url = %@",url);
        
        
        NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"twitter value:%@",jsonRes);
        [btnDisconnectTw setHidden:YES];
        [btnAddTwitter setHidden:NO];
        
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            [cookies deleteCookie:cookie];
        }

        
    }else if([strOpenTwitter isEqualToString:@"0"])
    {
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        _engine.delegate=self;
        
        _engine.consumerKey = @"FoRfih8kstGQ6u8iAHejCQ";
        _engine.consumerSecret = @"P64YPG4vxl3L9Tx8rpBqE3SZMKv9F8wNvIGsxslQc";
      
        //_engine.consumerKey = @"PzkZj9g57ah2bcB58mD4Q";
       // _engine.consumerSecret = @"OvogWpara8xybjMUDGcLklOeZSF12xnYHLE37rel2g";
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
        
        if (controller) 
            [self presentModalViewController: controller animated: YES];
        else {
            
        }
        

    }

	   
    
}
-(IBAction)FaceBook_Click:(id)sender{
    
    NSLog(@"%@",txtTitle);
    
    NSString * urlstring = [NSString stringWithFormat:@"http://herematch.com:3000/ws_herematch/check_access_token.php?user_id=%d",[AppDelegate sharedInstance].UserId];
    
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    
    NSString * strOpenFB = [(NSString *)[jsonRes JSONValue] valueForKey:@"F"];
    
    if ([strOpenFB isEqualToString:@"1"]) {
        
        NSString  *urlstring = [NSString stringWithFormat:@"%@facebook_remove_token.php?id=%d",kWebServiceUrl,[AppDelegate sharedInstance].UserId];    
        NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        //   NSLog(@"profileupdate url = %@",url);
        
        
        NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
      //  NSLog(@"facebook value:%@",jsonRes);
        
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            [cookies deleteCookie:cookie];
        }
        [btnAddFacebook setHidden:NO];
        [btnDisconnectFB setHidden:YES];
        
        
    }else if([strOpenFB isEqualToString:@"0"]){
    
        oAuth2FBLoginView = [[oAuth2TestViewController alloc] initWithNibName:nil bundle:nil];
        [oAuth2FBLoginView retain];
        oAuth2FBLoginView.delegate=self;
        [self presentModalViewController:oAuth2FBLoginView animated:YES];
        [oAuth2FBLoginView release];
    }
}

-(void) loginViewDidFinish:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    NSDictionary *profile = [notification userInfo];
//    if ( profile )
//    {
//        name.text = [[NSString alloc] initWithFormat:@"%@ %@",
//                     [profile objectForKey:@"firstName"], [profile objectForKey:@"lastName"]];
//        headline.text = [profile objectForKey:@"headline"];
//    }
    [oAuthLoginView release];
}
-(IBAction)Linkdn_Click:(id)sender{
    
    NSString * urlstring = [NSString stringWithFormat:@"http://herematch.com:3000/ws_herematch/check_access_token.php?user_id=%d",[AppDelegate sharedInstance].UserId];
    
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    
    NSString * strOpenLinkdin = [(NSString *)[jsonRes JSONValue] valueForKey:@"L"];
    
    if ([strOpenLinkdin isEqualToString:@"1"]) {
    
        NSString  *urlstring = [NSString stringWithFormat:@"%@linkedin_remove_token.php?id=%d",kWebServiceUrl,[AppDelegate sharedInstance].UserId];    
        NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        //   NSLog(@"profileupdate url = %@",url);
        
        
        NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
       // NSLog(@"linkdin value:%@",jsonRes);
        
        [btnAddLinkdin setHidden:NO];
        [btnDisconnectLd setHidden:YES];
        
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            [cookies deleteCookie:cookie];
        }

        
    }
    else if([strOpenLinkdin isEqualToString:@"0"])
    {
        oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
        oAuthLoginView.delegate=self;
        [oAuthLoginView retain];
        [self presentModalViewController:oAuthLoginView animated:YES]; 
        [oAuthLoginView release];
    }
}

-(void)clearViewForReLoad
{
	[txtBio resignFirstResponder];
    [txtInterests resignFirstResponder];
    
    [txtLocationCity resignFirstResponder];
    
    [txtTitle resignFirstResponder];
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    
    [txtEmail resignFirstResponder];
    [txtHeadLine resignFirstResponder];
    [txtPhoneNo1 resignFirstResponder];
    [txtPhoneNo2 resignFirstResponder];
    [txtPhoneNo3 resignFirstResponder];
    [txtURL resignFirstResponder];
    [txtCompany resignFirstResponder];
    [txtEduSchool resignFirstResponder];
    //    [txtEduGraduationYear resignFirstResponder];
    [txtEduMajor resignFirstResponder];
    [txtHomeTownCity resignFirstResponder];
	[txtAssociations resignFirstResponder];
	
    NSLog(@"title %@",txtTitle.text);
    NSLog(@"title 2%@",txtCompany.text);
    /*
	txtBio.text = @"";
	txtInterests.text = @"";
	txtAssociations.text = @"";
    
    txtLocationCity.text = @"";
	txtLocationState.text = @"";
    txtindustry.text = @"";
    
	txtTitle.text = @"";
    txtFirstName.text = @"";
	txtLastName.text = @"";
	
	txtEmail.text = @"";
	txtHeadLine.text = @"";
	txtPhoneNo1.text = @"";
  	txtPhoneNo2.text = @"";
   	txtPhoneNo3.text = @"";
	txtURL.text = @"";
	txtCompany.text = @"";
	txtEduSchool.text = @"";
	txtEduGraduationYear.text = @"";
	txtEduMajor.text = @"";
	txtHomeTownCity.text = @"";
	txtHomeTownState.text = @"";
	txtIndustryInterested1.text = @"";
	txtIndustryInterested2.text = @"";
	txtIndustryInterested3.text = @"";
     */
    
//	[profileimage setImage:[UIImage imageNamed:@"profile-default.png"] forState:UIControlStateNormal];
}

- (void)addButtonToKeyboard {
	
	// create custom button
	
	doneButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	
	doneButton.frame = CGRectMake(0, 163, 106, 53);
	
	doneButton.adjustsImageWhenHighlighted = NO;
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) {
		
		[doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
		
		[doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
		
	} else {        
		
		[doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
		
		[doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
		
	}
	
	[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
	
	// locate keyboard view
	
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	
	UIView* keyboard;
	
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		
		keyboard = [tempWindow.subviews objectAtIndex:i];
		
		// keyboard found, add the button
		
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
			
			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
				
				[keyboard addSubview:doneButton];
			
		} else {
			
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
				
				[keyboard addSubview:doneButton];
			
		}
		if (phoneTagOrNot == TRUE) {
			doneButton.hidden = TRUE;
		}
	}
}	

- (void)doneButton:(id)sender
{
    
    if (phonecheck==1) {
        [txtPhoneNo1 resignFirstResponder];
        [txtPhoneNo2 becomeFirstResponder];
    }
    else if (phonecheck==2) {
        [txtPhoneNo2 resignFirstResponder];
        [txtPhoneNo3 becomeFirstResponder];
    }
    else{
        [txtPhoneNo3 resignFirstResponder];
    }
    
    
    
}
	
- (void)keyboardWillShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2) {
		[self addButtonToKeyboard];
	}
}
	
- (void)keyboardDidShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		[self addButtonToKeyboard];
	}
}	

#pragma mark -
#pragma mark UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (actionSheet.tag == 1) {
		if (buttonIndex == 0) {
			if (btnTag == 11) {
				//NSLog(@"");
				txtHomeTownState.text = @"";
				selectedStateHS = selectedStateLSTmp;
				txtHomeTownState.text = [arrStates objectAtIndex:selectedStateHS];
			}
			else if (btnTag == 22) {
				txtLocationState.text = @"";
				selectedStateLS = selectedStateHSTmp;
				txtLocationState.text = [arrStates objectAtIndex:selectedStateLS];
			}			
		}
		if (buttonIndex == 1) {
			
		}
	}
	
	if (actionSheet.tag == 3) {
		if (buttonIndex == 0) {
			txtEduGraduationYear.text = @"";
			selectedYear = selectedYearTmp;
			txtEduGraduationYear.text = [arrYears objectAtIndex:selectedYear];
            
		}
		if (buttonIndex == 1) {
			
		}
	}
	
	if (actionSheet.tag == 2) {
        [AppDelegate sharedInstance].ismail = TRUE;
		if (buttonIndex == 0) 
		{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
                UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                
                ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
                ipc.delegate = self;
                //ipc.allowsImageEditing = YES;
                [self presentModalViewController:ipc animated:YES];
            }else{
                DisplayAlertWithTitle(@"Camera Not Available.", @"herematch");
            }
            
			
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
		if (buttonIndex == 0) {
			if (btnTag ==1) {
				txtindustry.text =  [[arrIndustryCategoryList objectAtIndex:selectedRowInd] valueForKey:@"name"];
				txtIndustryTag = [[[arrIndustryCategoryList objectAtIndex:selectedRowInd]  valueForKey:@"ind_id"] retain];
				//selectedRowInd = selectedRowIndTmp;
			}
			if (btnTag ==2) {
				txtIndustryInterested1.text =  [[arrIndustryCategoryList objectAtIndex:selectedRowInd1] valueForKey:@"name"];
				txtIndustry1Tag = [[[arrIndustryCategoryList objectAtIndex:selectedRowInd1] valueForKey:@"ind_id"] retain];
				//selectedRowInd1 = selectedRowIndTmp;
			}
			if (btnTag ==3) {
				txtIndustryInterested2.text =  [[arrIndustryCategoryList objectAtIndex:selectedRowInd2] valueForKey:@"name"];
				txtIndustry2Tag = [[[arrIndustryCategoryList objectAtIndex:selectedRowInd2] valueForKey:@"ind_id"] retain];
				//selectedRowInd2 = selectedRowIndTmp;
			}
			if (btnTag ==4) {
				txtIndustryInterested3.text =  [[arrIndustryCategoryList objectAtIndex:selectedRowInd3] valueForKey:@"name"];
				txtIndustry3Tag = [[[arrIndustryCategoryList objectAtIndex:selectedRowInd3] valueForKey:@"ind_id"] retain];
				//selectedRowInd3 = selectedRowIndTmp;
			}			
		}
		if (buttonIndex == 1) {
			
		}
	}
}

#pragma mark -
#pragma mark UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
        [AppDelegate sharedInstance].ismail = FALSE;	
        [picker dismissModalViewControllerAnimated:YES];
        
		UIImage *imgProfile = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
		[profileimage setImage:imgProfile forState:UIControlStateNormal];
		CGRect rect=CGRectMake(0,0,90,100);
		UIGraphicsBeginImageContext( rect.size );
		[profileimage.imageView.image drawInRect:rect];
	tagPhoto = 5;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [AppDelegate sharedInstance].ismail = FALSE;
	[picker dismissModalViewControllerAnimated:YES];
}
# pragma  mark -
# pragma mark PickerViewDelegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (btnTag ==11 || btnTag == 22) {
        return [arrStates count];
    }
    else if (btnTag == 33) {
        return [arrYears count];
    }
    else {
        return [arrIndustryCategoryList count];
    }    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (btnTag ==11 || btnTag == 22) {
        return [arrStates objectAtIndex:row];
    }
    else if (btnTag == 33) {
        return [arrYears objectAtIndex:row];
    }
    else {
        return [[arrIndustryCategoryList objectAtIndex:row] valueForKey:@"name"];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if (btnTag == 11 || btnTag == 22) {
        if (btnTag == 11) {
			selectedStateLSTmp = row;
        }
        else if (btnTag == 22) {
			selectedStateHSTmp = row;
        }
    }
    else if (btnTag == 33) {
		selectedYearTmp = row;
    }
    else {
        if (PickerView.tag==1) {
            selectedRowInd=row;
        }
        else if (PickerView.tag==2) {
            selectedRowInd1=row;            
        }
        else if (PickerView.tag==3) {
            selectedRowInd2=row;
        }
        else if (PickerView.tag==4) {
            selectedRowInd3=row;
        }
        
    }
}
#pragma mark -
#pragma mark UITextField delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{	
    if (textField==txtPhoneNo1) {
         [textField resignFirstResponder];
        [txtPhoneNo2 becomeFirstResponder];
    }
    else if (textField==txtPhoneNo2) {
        [textField resignFirstResponder];
        [txtPhoneNo3 becomeFirstResponder];
    }
    
    
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{ 	
	
    
    if (textField==txtPhoneNo1) {
        phonecheck=1;
    }
    else if (textField==txtPhoneNo2) {
                phonecheck=2;
    }else{
        phonecheck=3;
    }
    
    /*
	CGRect textFieldRect =[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y +1.0*textFieldRect.size.height;
    CGFloat numerator =midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    animatedDistance = floor(162.0 * heightFraction);
    
    CGRect viewFrame = self.view.frame;
    
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
     */
    
    if ([textField isEqual:txtFirstName] || [textField isEqual:txtLastName]) {
        
        
        
    }else if([textField isEqual:txtTitle])
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [profileScrollView setContentOffset:CGPointMake(textField.frame.origin.x-108, textField.frame.origin.y-50)];
        [UIView commitAnimations];
        
    }else if([textField isEqual:txtPhoneNo2])
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [profileScrollView setContentOffset:CGPointMake(textField.frame.origin.x-104, textField.frame.origin.y-50)];
        [UIView commitAnimations];
    
    }else if([textField isEqual:txtPhoneNo3])
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [profileScrollView setContentOffset:CGPointMake(textField.frame.origin.x-198, textField.frame.origin.y-50)];
        [UIView commitAnimations];
    }else 
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [profileScrollView setContentOffset:CGPointMake(textField.frame.origin.x-10, textField.frame.origin.y-50)];
        [UIView commitAnimations];
    }
  
	if (textField == txtPhoneNo1 || textField == txtPhoneNo2  || textField == txtPhoneNo3) {
		//doneButton.hidden = YES;
		//phoneTagOrNot = TRUE;
        
        doneButton.hidden = NO;
		phoneTagOrNot = FALSE;
        
	}else {
        doneButton.hidden = YES;
		phoneTagOrNot = TRUE;
		//doneButton.hidden = NO;
		//phoneTagOrNot = FALSE;
	}

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:txtFirstName] || [textField isEqual:txtLastName]) {
        
        
        
    }else if([textField isEqual:txtTitle])
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [profileScrollView setContentOffset:CGPointMake(textField.frame.origin.x-108, textField.frame.origin.y-100)];
        [UIView commitAnimations];
        
    }else if([textField isEqual:txtPhoneNo2])
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [profileScrollView setContentOffset:CGPointMake(textField.frame.origin.x-104, textField.frame.origin.y-100)];
        [UIView commitAnimations];
        
    }else if([textField isEqual:txtPhoneNo3])
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [profileScrollView setContentOffset:CGPointMake(textField.frame.origin.x-198, textField.frame.origin.y-100)];
        [UIView commitAnimations];
    }else 
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [profileScrollView setContentOffset:CGPointMake(textField.frame.origin.x-10, textField.frame.origin.y-100)];
        [UIView commitAnimations];
    }
    
   
    
    /*
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y += animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
	[self.view setFrame:viewFrame];
	
	[UIView commitAnimations];
     */
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    
	if (textField == txtPhoneNo1 || textField == txtPhoneNo2) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 3) ? NO : YES;
       
		
	}
	else if (textField == txtPhoneNo3){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 4) ? NO : YES;

    }
	return YES;
}
#pragma mark -
#pragma mark UITextView delegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
      [profileScrollView setContentOffset:CGPointMake(textView.frame.origin.x-10, textView.frame.origin.y-50)];
        [UIView commitAnimations];
    /*
	CGRect textFieldRect =[self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y +1.0*textFieldRect.size.height;
    CGFloat numerator =midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    animatedDistance = floor(162.0 * heightFraction);
    
    CGRect viewFrame = self.view.frame;
    
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
     */
	if (textView == txtBio || textView == txtInterests || textView == txtAssociations) {
		doneButton.hidden = TRUE;
		phoneTagOrNot = TRUE;
	}
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [profileScrollView setContentOffset:CGPointMake(textView.frame.origin.x-10, textView.frame.origin.y-100)];
    [UIView commitAnimations];
    /*
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y += animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
     */
}
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
	[txtView resignFirstResponder];
    return NO;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        profileScrollView.frame=CGRectMake(0, 50, 320,1708-40);
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
         profileScrollView.frame=CGRectMake(0, 0, 320,1708);
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
-(IBAction)btnDisconnect_Facebook:(id)sender
{
    NSString  *urlstring = [NSString stringWithFormat:@"%@facebook_remove_token.php?id=%d",kWebServiceUrl,[AppDelegate sharedInstance].UserId];    
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
 //   NSLog(@"profileupdate url = %@",url);
    
    
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"facebook value:%@",jsonRes);
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
    [btnAddFacebook setHidden:NO];
    [btnDisconnectFB setHidden:YES];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBAT"];
}
-(IBAction)btnDisconnect_twitter:(id)sender
{
    NSString  *urlstring = [NSString stringWithFormat:@"%@twitter_remove_token.php?id=%d",kWebServiceUrl,[AppDelegate sharedInstance].UserId];    
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //   NSLog(@"profileupdate url = %@",url);
    
    
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
 //   NSLog(@"twitter value:%@",jsonRes);
    [btnDisconnectTw setHidden:YES];
    [btnAddTwitter setHidden:NO];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OATK"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OATS"];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
    
}
-(IBAction)btnDisconnect_Linkdin:(id)sender
{
    NSString  *urlstring = [NSString stringWithFormat:@"%@linkedin_remove_token.php?id=%d",kWebServiceUrl,[AppDelegate sharedInstance].UserId];    
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //   NSLog(@"profileupdate url = %@",url);
    
    
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"linkdin value:%@",jsonRes);
    
    

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ART"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AAT"];
    
    [btnAddLinkdin setHidden:NO];
    [btnDisconnectLd setHidden:YES];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
    
}

-(void)hideTwitter
{ 
 
    
    [btnAddTwitter setHidden:YES];
    [btnDisconnectTw setHidden:NO];
}
-(void)hideLinkdin
{
   
    
    [btnAddLinkdin setHidden:YES];
    [btnDisconnectLd setHidden:NO];
}
-(void)removeview:(int)Value;
{
    [AppDelegate sharedInstance].checkTWLD=TRUE;
    
    NSLog(@"%@ a",txtTitle);
    if (Value==1) {
        [btnAddFacebook setHidden:YES];
        [btnDisconnectFB setHidden:NO];
 
    }
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Memory Management Methods
- (void)dealloc
{
    [self releaseBannerView];
	[oAuth2FBLoginView release];
	[oAuthLoginView release];
	[profileScrollView release];
	[dictLoginUserdetail release];
    [arrIndustryCategoryList release];
	[txtIndustryTag release];
	[txtIndustry1Tag release];
	[txtIndustry2Tag release];
	[txtIndustry3Tag release];
    [arrYears release];
    [_engine release];
    [arrStates release];
	[super dealloc];
}
@end
