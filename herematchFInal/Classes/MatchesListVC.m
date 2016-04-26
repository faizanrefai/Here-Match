//
//  MatchesListVC.m
//  HereMatch
//
//  Created by apple on 9/28/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import "MatchesListVC.h"
#import "MatchDetailsViewController.h"
#import "MatchlListDetailCell.h"
#import "UITableViewCell+NIB.h"

@implementation MatchesListVC
@synthesize  locationManager = _locationManager;
@synthesize myTable,bannerIsVisible;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
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
   
    
    
    
	UIBarButtonItem * btnrefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btn_refresh_click)];
    self.navigationItem.rightBarButtonItem = btnrefresh;
	
	allProfilesArray = [[NSMutableArray alloc] init];
	matchesArray = [[NSMutableArray alloc] init];
	isWSCalled = NO;
    
	self.locationManager=[[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];

}

- (void)viewWillAppear:(BOOL)animated{
    
    if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@industry_list.php",kWebServiceUrl]]) {
        DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
        return;
    }

	myTable.tag = 0;
    isWSCalled = NO;
	[self.locationManager startUpdatingLocation];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    
    
	//[super viewWillDisappear:animated];
	myTable.tag=111;
	//[myTable removeFromSuperview];
    
    [self.locationManager stopUpdatingLocation];
}
- (void) btn_refresh_click{
    
    if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@industry_list.php",kWebServiceUrl]]) {
        DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
        return;
    }

    
    myTable.tag = 111;
    isWSCalled = NO;
    [self.locationManager startUpdatingLocation];
}

- (void)downloadFriendsList
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	NSString  *urlstring = [NSString stringWithFormat:@"%@match.php?lat=%f&long=%f&user_id=%d",kWebServiceUrl,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,[AppDelegate sharedInstance].UserId];
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  //  NSLog(@"url1 : %@",urlstring);
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@friend_list.php?username=%@",kWebServiceUrl,[AppDelegate sharedInstance].username]];
    NSString  *jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
  //  NSLog(@"jsonREsponse = %@",jsonRes);
    
    [matchesArray setArray:[[jsonRes JSONValue] valueForKey:@"Record"]];
    
	NSString  *urlstring1 = [NSString stringWithFormat:@"%@unmatched_users.php?lat=%f&long=%f&user_id=%d",kWebServiceUrl,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,[AppDelegate sharedInstance].UserId];
    NSURL *url1 = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   // NSLog(@"url1 : %@",urlstring1);
    
    NSString  *jsonRes1 = [NSString stringWithContentsOfURL:url1 encoding:NSUTF8StringEncoding error:nil];
   // NSLog(@"jsonREsponse = %@",jsonRes1);
	[allProfilesArray setArray:[[jsonRes1 JSONValue] valueForKey:@"Record"]];
	myTable.tag = 0;
	[self performSelectorOnMainThread:@selector(reloadtable) withObject:nil waitUntilDone:YES];
	[[AppDelegate sharedInstance] hideLoadingView];
    //[self performSelectorOnMainThread:@selector(reloadtable) withObject:nil waitUntilDone:YES];
	[pool release];
}
- (void) reloadtable{
	myTable.tag = 0;
    [myTable reloadData];    
}
- (NSString *)removeNull:(NSString *)str{
    str = [NSString stringWithFormat:@"%@",str];
    //NSLog(@"\n\nstr = %@,  length = ",str);
    
    if (!str) {
        return @"";
    }
    else if([str isEqualToString:@"<null>"]){
        return @"";
    }
    else if([str isEqualToString:@"(null)"]){
        return @"";
    }
    
    else{
        return str;
    }
}
#pragma mark -
#pragma mark CLLocationManager delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {    
    
    [AppDelegate sharedInstance].location = newLocation;
    
    [matchesArray removeAllObjects];
    [allProfilesArray removeAllObjects];
    
    if (!isWSCalled) {
        isWSCalled = YES;
        [[AppDelegate sharedInstance] showLoadingView];
        [self performSelectorInBackground:@selector(downloadFriendsList) withObject:nil];
    }
    
    [self.locationManager stopUpdatingLocation];
    
}	
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
     DisplayAlertWithTitle(kLocationErrormsg, @"herematch");
	NSLog(@"Error in Location Manager (GPS)");
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.    
	
	if (section==0) {
		return [matchesArray count];
	}else {
		return [allProfilesArray count];
	}
	return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
        return @"Matches";
    }else {
		return @"Everyone";
	}
	
	return @"NO Matches";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


	MatchlListDetailCell *cell = [MatchlListDetailCell dequeOrCreateInTable:tableView];	
	if (indexPath.section == 0) {
		
        cell.imgUser.image=[UIImage imageNamed:@"MatchDetails-Default.png"];
        
		NSMutableDictionary *dForCell=[[matchesArray  objectAtIndex:indexPath.row] retain];
		NSMutableString *strImgURl;		
		strImgURl= [NSString stringWithFormat:@"%@",[dForCell objectForKey:@"photo_file_name"]];
       
		NSLog(@"image uri = %@",strImgURl);
		if ([strImgURl isEqualToString:@""]) {
			cell.imgUser.image =[UIImage imageNamed:@"MatchDetails-Default.png"];
		}else {
			if([dForCell valueForKey:@"cell"])
			{
				cell.imgUser.image = [[UIImage alloc] initWithData:[dForCell valueForKey:@"mywebdata"]];
			}
			else 
			{
				[DCImageView loadURLImage:strImgURl dictionaryRef:dForCell indexPath:indexPath tableViewRef:tableView];
			}
		}
//		if([dForCell valueForKey:@"cell"])
//		{
//			cell.imgUser.image = [[UIImage alloc] initWithData:[dForCell valueForKey:@"mywebdata"]];
//		}
//		else 
//		{
//			[DCImageView loadURLImage:strImgURl dictionaryRef:dForCell indexPath:indexPath tableViewRef:tableView];
//		} 
		NSString *strTemp = nil;
        
		strTemp = [[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"first_name"] retain];
        strTemp = [[self removeNull:strTemp] retain];
		cell.lblFN.text = strTemp;
		strTemp = nil;
		
		strTemp = [[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"last_name"] retain];
		strTemp = [[self removeNull:strTemp] retain];
		cell.lblFN.text = [cell.lblFN.text stringByAppendingFormat:[NSString stringWithFormat:@" %@",strTemp] ];
        strTemp = nil;
		
        NSString * strtitle = [[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"title"];
        strtitle= [self removeNull:strtitle];
        NSString * strcompany = [[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"company"];
        strcompany= [self removeNull:strcompany];
       // NSLog(@"strtitle = %@ , strcompany = %@ in section 0",strtitle,strcompany);
        if ((![strtitle isEqualToString:@""])  && (![strcompany isEqualToString:@""])) {
            cell.lblCompany.text = [NSString stringWithFormat:@"%@ at %@",strtitle,strcompany];
        }
        else{
            
            if (![strtitle isEqualToString:@""]) {
                cell.lblCompany.text = strtitle;
            }else{
                cell.lblCompany.text = strcompany; 
            }
        }

        
//		strTemp = [[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"company"] retain];
//		if (strTemp != nil) {
//			cell.lblCompany.text = strTemp;
//		}
//		else {
//			cell.lblCompany.text = @"";
//		}
//		strTemp = nil;
		// for maTCH RESONS ONLY 1 
        NSString *strGrop=[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"groups"];
        NSString *strinterests=[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"interests"];
        NSString *strschool=[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"school"];
        NSString *strservices_needed=[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"services_needed"];
        
        NSString *strindustry=[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"industry"];
        NSString *strhometown=[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"hometown"];
        
        
        
        if (strservices_needed) {
            strTemp = [NSString stringWithFormat:@"Needs: %@",[[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"services_needed"] retain]];  
        }
        else if (strindustry) {
            strTemp = [NSString stringWithFormat:@"Offers: %@",[[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"industry"] retain]];  
        }
        else if (strGrop) {
            
            strTemp = [NSString stringWithFormat:@"Member of: %@",[[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"groups"] retain]];  
        }    
        else if (strinterests) {
            strTemp = [NSString stringWithFormat:@"Likes: %@",[[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"interests"] retain]];  
        }
        else if (strschool) {
            strTemp = [NSString stringWithFormat:@"Went to: %@",[[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"school"] retain]];  
        }
            
        else if (strhometown) {
            strTemp = [NSString stringWithFormat:@"From: %@",[[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"hometown"] retain]];  
        }
        // 
        
		//strTemp = [[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"title"] retain];
		if (strTemp != nil) {
			cell.lblReason.text = strTemp;
		}
		else {
			cell.lblReason.text = @"";
		}
		strTemp = nil;
		
		//cell.lblFN.text = [[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"first_name"];
		//cell.lblLN.text = [[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"last_name"];
		//cell.lblCompany.text = [[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"company"];
		//cell.lblReason.text = [[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"title"];
	}else {
		
           cell.imgUser.image=[UIImage imageNamed:@"MatchDetails-Default.png"];
        
		NSMutableDictionary *dForCell=[[allProfilesArray  objectAtIndex:indexPath.row] retain];
		NSMutableString *strImgURl;		
		strImgURl= [NSString stringWithFormat:@"%@",[dForCell objectForKey:@"photo_file_name"]];
     //   NSLog(@"str Image Uri = %d for user %@",[strImgURl length],[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"first_name"]);
		if ([strImgURl isEqualToString:@""]) {
			cell.imgUser.image =  [UIImage imageNamed:@"MatchDetails-Default.png"];
		}else {
			if([dForCell valueForKey:@"cell"])
			{
				cell.imgUser.image = [[UIImage alloc] initWithData:[dForCell valueForKey:@"mywebdata"]];
			}
			else 
			{
				[DCImageView loadURLImage:strImgURl dictionaryRef:dForCell indexPath:indexPath tableViewRef:tableView];
			}
		}
//		if([dForCell valueForKey:@"cell"])
//		{
//			cell.imgUser.image = [[UIImage alloc] initWithData:[dForCell valueForKey:@"mywebdata"]];
//		}
//		else 
//		{
//			[DCImageView loadURLImage:strImgURl dictionaryRef:dForCell indexPath:indexPath tableViewRef:tableView];
//		} 
		
		NSString *strTemp = nil;
		strTemp = [[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"first_name"] retain];
		strTemp = [self removeNull:strTemp];
        cell.lblFN.text = strTemp;
		strTemp = nil;
        
		
		strTemp = [[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"last_name"] retain];
		strTemp = [self removeNull:strTemp];
		cell.lblFN.text = [cell.lblFN.text stringByAppendingFormat:[NSString stringWithFormat:@" %@",strTemp] ];
		strTemp = nil;
		
        NSString * strtitle = [[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"title"];
         strtitle= [self removeNull:strtitle];
        NSString * strcompany = [[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"company"];
         strcompany= [self removeNull:strcompany];
       // NSLog(@"strtitle = %@ , strcompany = %@ in section 0",strtitle,strcompany);
        if ((![strtitle isEqualToString:@""]  )  && (![strcompany isEqualToString:@""])) {
            cell.lblCompany.text = [NSString stringWithFormat:@"%@ at %@",strtitle,strcompany];
        }
        else{
            
            if (![strtitle isEqualToString:@""]) {
                cell.lblCompany.text = strtitle;
            }else{
                cell.lblCompany.text = strcompany; 
            }
        }        
        
        
        
        
        
        NSString *strGrop=[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"groups"];
        NSString *strinterests=[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"interests"];
        NSString *strschool=[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"school"];
        NSString *strservices_needed=[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"services_needed"];
        
        NSString *strindustry=[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"industry"];
        NSString *strhometown=[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"hometown"];
        
        
        
        if (strservices_needed) {
            strTemp = [NSString stringWithFormat:@"Needs: %@",[[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"services_needed"] retain]];  
        }
        else if (strindustry) {
            strTemp = [NSString stringWithFormat:@"Offers: %@",[[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"industry"] retain]];  
        }
        else if (strGrop) {
            
            strTemp = [NSString stringWithFormat:@"Member of: %@",[[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"groups"] retain]];  
        }    
        else if (strinterests) {
            strTemp = [NSString stringWithFormat:@"Likes: %@",[[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"interests"] retain]];  
        }
        else if (strschool) {
            strTemp = [NSString stringWithFormat:@"Went to: %@",[[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"school"] retain]];  
        }
        
        else if (strhometown) {
            strTemp = [NSString stringWithFormat:@"From: %@",[[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"hometown"] retain]];  
        }
        // 
        
		//strTemp = [[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"title"] retain];
		if (strTemp != nil) {
			cell.lblReason.text = strTemp;
		}
		else {
			cell.lblReason.text = @"";
		}
		strTemp = nil;

//		strTemp = [[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"company"] retain];
//		if (strTemp != nil) {
//			cell.lblCompany.text = strTemp;
//		}
//		else {
//			cell.lblCompany.text = @"";
//		}
//		strTemp = nil;
		
//		strTemp = [[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"title"] retain];
//		if (strTemp != nil) {
//			cell.lblReason.text = strTemp;
//		}
//		else {
//			cell.lblReason.text = @"";
//		}
//		strTemp = nil;
		//cell.lblFN.text = [[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"first_name"];
		//cell.lblLN.text = [[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"last_name"];
		//cell.lblCompany.text = [[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"company"];
		//cell.lblReason.text = [[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"title"];
        
	}
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	MatchDetailsViewController * matchdetailobj = [[MatchDetailsViewController alloc] initWithNibName:@"MatchDetailsView" bundle:nil];
    if (indexPath.section==0)
	{
		matchdetailobj.idUser = [[[matchesArray objectAtIndex:indexPath.row] valueForKey:@"user_id"] integerValue];	
        NSString * strTemp;
        
        NSString *strGrop=[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"groups"];
        NSString *strinterests=[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"interests"];
        NSString *strschool=[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"school"];
        NSString *strservices_needed=[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"services_needed"];
        
        NSString *strindustry=[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"industry"];
        NSString *strhometown=[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"hometown"];
          
             
        
        
        [[AppDelegate sharedInstance].arrMatchResons removeAllObjects];
        
        
        if (strservices_needed) {
            strTemp = [NSString stringWithFormat:@"Needs: %@",[[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"services_needed"] retain]];  
            [[AppDelegate sharedInstance].arrMatchResons addObject:strTemp];
        }
        if (strindustry) {
            strTemp = [NSString stringWithFormat:@"Offers: %@",[[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"industry"] retain]];  
            [[AppDelegate sharedInstance].arrMatchResons addObject:strTemp];
        }
        if (strGrop) {
            strTemp = [NSString stringWithFormat:@"Member of: %@",[[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"groups"] retain]];  
            [[AppDelegate sharedInstance].arrMatchResons addObject:strTemp];
        }
        if (strinterests) {
            strTemp = [NSString stringWithFormat:@"Likes: %@",[[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"interests"] retain]];  
            [[AppDelegate sharedInstance].arrMatchResons addObject:strTemp];
        }
        if (strschool) {
            strTemp = [NSString stringWithFormat:@"Went to: %@",[[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"school"] retain]];  
            [[AppDelegate sharedInstance].arrMatchResons addObject:strTemp];
        }
        if (strhometown) {
            strTemp = [NSString stringWithFormat:@"From: %@",[[[matchesArray  objectAtIndex:indexPath.row] valueForKey:@"hometown"] retain]];  
            [[AppDelegate sharedInstance].arrMatchResons addObject:strTemp];
        }

	}else
    {
        matchdetailobj.idUser = [[[allProfilesArray objectAtIndex:indexPath.row] valueForKey:@"user_id"] integerValue];		
        NSString * strTemp;
        
        NSString *strGrop=[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"groups"];
        NSString *strinterests=[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"interests"];
        NSString *strschool=[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"school"];
        NSString *strservices_needed=[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"services_needed"];
        
        NSString *strindustry=[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"industry"];
        NSString *strhometown=[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"hometown"];
        
        
        
        
        [[AppDelegate sharedInstance].arrMatchResons removeAllObjects];
        
        
        if (strservices_needed) {
            strTemp = [NSString stringWithFormat:@"Needs: %@",[[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"services_needed"] retain]];  
            [[AppDelegate sharedInstance].arrMatchResons addObject:strTemp];
        }
        if (strindustry) {
            strTemp = [NSString stringWithFormat:@"Offers: %@",[[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"industry"] retain]];  
            [[AppDelegate sharedInstance].arrMatchResons addObject:strTemp];
        }
        if (strGrop) {
            strTemp = [NSString stringWithFormat:@"Member of: %@",[[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"groups"] retain]];  
            [[AppDelegate sharedInstance].arrMatchResons addObject:strTemp];
        }
        if (strinterests) {
            strTemp = [NSString stringWithFormat:@"Likes: %@",[[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"interests"] retain]];  
            [[AppDelegate sharedInstance].arrMatchResons addObject:strTemp];
        }
        if (strschool) {
            strTemp = [NSString stringWithFormat:@"Went to: %@",[[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"school"] retain]];  
            [[AppDelegate sharedInstance].arrMatchResons addObject:strTemp];
        }
        if (strhometown) {
            strTemp = [NSString stringWithFormat:@"From: %@",[[[allProfilesArray  objectAtIndex:indexPath.row] valueForKey:@"hometown"] retain]];  
            [[AppDelegate sharedInstance].arrMatchResons addObject:strTemp];
        }
		
	}
	
	[self.navigationController pushViewController:matchdetailobj animated:YES];
    [matchdetailobj release];
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        myTable.frame=CGRectMake(0, 50, 320,317);
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
        myTable.frame=CGRectMake(0, 0, 320,367);
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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    [self releaseBannerView];
	[matchesArray release];
	[allProfilesArray release];
}


@end
