//
//  CheckInListViewController.m
//  HereMatch
//
//  Created by apple  on 9/2/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//
// latest today
#import "CheckInListViewController.h"


@implementation CheckInListViewController
@synthesize tableview;
@synthesize  locationManager = _locationManager;
//@synthesize location;
@synthesize bannerIsVisible;

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{	
    [super viewDidLoad];
    //tableview.frame=CGRectMake(0, 0, 320, 480);
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currSysVer intValue]>= 5.0) {
        UIImage *backgroundImage = [UIImage imageNamed:@"here-match-header.png"];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];

    }
    
    if (!tableview) {
        tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
        [self.view addSubview:tableview];
    }
    tableview.delegate=self;
    tableview.dataSource=self;
    
    
    if (!adView) {
        adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        adView.frame = CGRectOffset(adView.frame, 0, -50);
        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
        [self.view addSubview:adView];
        adView.delegate=self;
        self.bannerIsVisible=NO;
    }
    
//    UIImage *image = [UIImage imageNamed: @"here-match-header.png"];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 40)];
//    
//    [imageView setImage:image];
//    
//    
//    self.navigationItem.titleView = imageView;
//    
//    [imageView release];

    
   
    //mapView = [[MKMapView alloc] init];
    //mapView.showsUserLocation= YES;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor]; 

    int UserID=[[NSUserDefaults standardUserDefaults] integerForKey:@"UserLoginID"];
    
    
    if (UserID) 
    {
     
        [AppDelegate sharedInstance].UserId=UserID;
        
    }else{
	if (!loginobj) {
            loginobj= [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
    }
	NSInteger isloggedin = [[NSUserDefaults standardUserDefaults] integerForKey:@"isLoggedin"];
	if (isloggedin == 0) {
	
		 [self presentModalViewController:loginobj animated:NO];
	}
        
        
    }
    
    UIBarButtonItem * btnrefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btn_refresh_click)];
    self.navigationItem.rightBarButtonItem = btnrefresh;
    

    arr_events = [[NSMutableArray alloc] init];
    arr_places = [[NSMutableArray alloc] init];
//    self.tableview.delegate = self;
//    self.tableview.dataSource = self;
    
    isWSCalled = NO;
    
    self.locationManager=[[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    

}
- (void)viewWillAppear:(BOOL)animated{
    
//    if (!adView) {
//        adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
//        adView.frame = CGRectOffset(adView.frame, 0, -50);
//        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
//        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
//        [self.view addSubview:adView];
//        adView.delegate=self;
//        self.bannerIsVisible=NO;  
//    }
//    
    NSInteger isloggedin = [[NSUserDefaults standardUserDefaults] integerForKey:@"isLoggedin"];
	//NSLog(@"isloggedin = %d",isloggedin);
    
    if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@event_list_lat_long.php?lat=%f&long=%f&user_id=%d",kWebServiceUrl,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,[AppDelegate sharedInstance].UserId]]) {
        DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
        return;
    }
    isWSCalled = NO;
    [self.locationManager startUpdatingLocation];
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil]; 
    
    [self.locationManager stopUpdatingLocation];
}
- (void) btn_refresh_click{
	 
    if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@event_list_lat_long.php?lat=%f&long=%f&user_id=%d",kWebServiceUrl,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,[AppDelegate sharedInstance].UserId]]) {
        DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
        return;
    }
    isWSCalled = NO;

    [self.locationManager startUpdatingLocation];
  
}
- (void) reloadTableView
{
	[tableview reloadData];
}
-(void)hideView
{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(HideAlert) userInfo:nil repeats:NO];
    
}
-(void)HideAlert
{
    [[AppDelegate sharedInstance] hideLoadingView];
}
#pragma mark -
#pragma mark coreLocation methods

//-------------------------------------------------------------------------------------------------------------------

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {	
	
    
    [AppDelegate sharedInstance].location = newLocation;
    [arr_events removeAllObjects];
    [arr_places removeAllObjects];
    if (!isWSCalled) {
        isWSCalled = YES;
       // [[AppDelegate sharedInstance] showLoadingView];
		//[self hideView];
        [self performSelectorInBackground:@selector(downloadEventsAndPlaces) withObject:nil];
    }
   
    [self reloadTableView];
    
    [self.locationManager stopUpdatingLocation];
    
//    CLLocationDistance meter;
//    meter = [[AppDelegate sharedInstance].location distanceFromLocation:newLocation];
//    if (meter > 800) {
//        
//         [AppDelegate sharedInstance].location = newLocation;
//        NSLog(@"NEw Lat = %f and Long = %f",[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude);
//        NSString * str = [NSString stringWithFormat:@"Lat Long Changed NEw Lat = %f and Long = %f",[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude];
//        //DisplayAlert(str);
//            [arr_events removeAllObjects];
//            [arr_places removeAllObjects];
//            [[AppDelegate sharedInstance] showLoadingView];
//            [self performSelectorInBackground:@selector(downloadEventsAndPlaces) withObject:nil];
//    }
    
//    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:location.coordinate radius:meter identifier:@"reg"];
//    //[locationManager startMonitoringForRegion:region desiredAccuracy:kCLLocationAccuracyBest];
//    [self.locationManager startMonitoringSignificantLocationChanges];
//    if([region containsCoordinate:newLocation.coordinate])
//    {
//        NSLog(@"true");
//        //btnScan.hidden=FALSE;
//        
//    }
//    else
//    {
//        NSLog(@"false");
//        //btnScan.hidden=TRUE;
//        location = newLocation;
//        
//        NSLog(@"NEw Lat = %f and Long = %f",location.coordinate.latitude,location.coordinate.longitude);
//        NSString * str = [NSString stringWithFormat:@"Lat Long Changed NEw Lat = %f and Long = %f",location.coordinate.latitude,location.coordinate.longitude];
//        //DisplayAlert(str);
////        [arr_events removeAllObjects];
////        [arr_places removeAllObjects];
////        [[AppDelegate sharedInstance] showLoadingView];
////        [self performSelectorInBackground:@selector(downloadEventsAndPlaces) withObject:nil];
//    }

    
    
}

//--------------------------------------------------------------------------------------------------------------------

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
     DisplayAlertWithTitle(kLocationErrormsg, @"herematch");
	//NSLog(@"Error in Location Manager (GPS)");
}


- (void)downloadEventsAndPlaces{
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
   
     [[AppDelegate sharedInstance] showLoadingView];
    
    NSDateFormatter *dateFormatterwsformat =  [[NSDateFormatter alloc] init];    
    [dateFormatterwsformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString * currentdate = [dateFormatterwsformat stringFromDate:[NSDate date]];
    [dateFormatterwsformat release];
    

    
    
    //  For Calling Events List WebService
    //NSLog(@"NEw Lat = %f and Long = %f in webservice url method",location.latitude,location.longitude);
    NSString * urlstring = [NSString stringWithFormat:@"%@event_list_lat_long.php?lat=%f&long=%f&user_id=%d&today=%@",kWebServiceUrl,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,[AppDelegate sharedInstance].UserId,currentdate];
    
    //NSString * urlstring = [NSString stringWithFormat:@"%@event_list_lat_long.php?lat=%f&long=%f",kWebServiceUrl,];
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   // NSLog(@"url = %@",url);
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@friend_list.php?username=%@",kWebServiceUrl,[AppDelegate sharedInstance].username]];
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"jsonREsponse = %@",jsonRes);
    //NSString * strmsg = [[jsonRes JSONValue] valueForKey:@"msg"];//me keyur
   // NSLog(@"strmsg = %@",strmsg);
    
    //if ([strmsg isEqualToString:@"Success"]) {
        
        [arr_events setArray:[[jsonRes JSONValue] valueForKey:@"Record"]];
        //[tableview reloadData];
         //NSLog(@"no of Events %d",[arr_events count]);
         //NSLog(@"name = %@",[[arr_events objectAtIndex:0] valueForKey:@"name"]);
    //}
    
    
    //  For Calling Places List WebService
    NSString * urlstring1 = [NSString stringWithFormat:@"%@places_list_lat_long.php?lat=%f&long=%f&user_id=%d",kWebServiceUrl,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,[AppDelegate sharedInstance].UserId];
    NSURL *url1 = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"url1 = %@",url1);
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@friend_list.php?username=%@",kWebServiceUrl,[AppDelegate sharedInstance].username]];
    NSString * jsonRes1 = [NSString stringWithContentsOfURL:url1 encoding:NSUTF8StringEncoding error:nil];
   // NSLog(@"jsonREsponse1 = %@",jsonRes1);
    //strmsg = [[jsonRes1 JSONValue] valueForKey:@"msg"];
    //NSLog(@"strmsg = %@",strmsg);
    //if ([strmsg isEqualToString:@"Success"]) {
        
    [arr_places setArray:[[jsonRes1 JSONValue] valueForKey:@"Record"]];
    //[arr_events addObject:@"Add Event"];
    //[arr_places addObject:@"Add Place"];
    
        //[tableview reloadData];
//        NSLog(@"no of places %d",[arr_places count]);
//        NSLog(@"name = %@",[[arr_places objectAtIndex:0] valueForKey:@"name"]);
    //}
    
    
	
    [[AppDelegate sharedInstance] hideLoadingView];
	[self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
     //[tableview reloadData];
    [pool release];
	
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   
	if (section == 0) {
		return [arr_events count];
    }
    else {
		return [arr_places count];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section==0) {
       
        return @"Events";
       
    }
    else{
        
        return @"Places";
               
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 75;
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // static NSString *CellIdentifier = @"Cell";
    
//    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//    }

    MatchesListCell *cell = [MatchesListCell dequeOrCreateInTable:tableView];
	if (indexPath.section==0) {
        
        if ([arr_events count]!=0) {
            cell.lblTitle.text = [[arr_events objectAtIndex:indexPath.row] valueForKey:@"name"];
            int eventdistance = (int)[[[arr_events objectAtIndex:indexPath.row] valueForKey:@"Distance"] intValue];
            cell.lblSubtitle.text =[NSString stringWithFormat:@"%@ - %d ft",[[arr_events objectAtIndex:indexPath.row] valueForKey:@"place_name"],eventdistance];   
            
            
            if (indexPath.row == ([arr_events count]-1)) {
                //cell.imgUser.frame = CGRectMake(5, 5, 35, 35);
                cell.imgUser.image = [UIImage imageNamed:@"plus.png"];
                
                cell.lblSubtitle.text = @"";
            }
            else{
                //UIImageView * imgview = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)] autorelease];
                cell.imgUser.image = [UIImage imageNamed:@"event.png"];
                //cell.imgUser.hidden = YES;
                //imgview.image = [UIImage imageNamed:@"event-calendar.png"];
                //[cell.contentView addSubview:imgview];
                
            }   
        }
             
        
    }
    else{
        if ([arr_places count]!=0) {
            cell.lblTitle.text = [[arr_places objectAtIndex:indexPath.row] valueForKey:@"name"];
            int placedistance = (int)[[[arr_places objectAtIndex:indexPath.row] valueForKey:@"Distance"] floatValue];
            
            
            if ([[[arr_places objectAtIndex:indexPath.row] valueForKey:@"address"] isEqualToString:@""]) {
                cell.lblSubtitle.text = cell.lblSubtitle.text =[NSString stringWithFormat:@"%d ft",placedistance];   
            }
            else{
              cell.lblSubtitle.text = cell.lblSubtitle.text =[NSString stringWithFormat:@"%@ - %d ft",[[arr_places objectAtIndex:indexPath.row] valueForKey:@"address"],placedistance];     
            }
            
            
            
			//cell.imgUser.frame = CGRectMake(6, 6, 32, 32);
            if (indexPath.row == ([arr_places count]-1)) {
                cell.imgUser.image = [UIImage imageNamed:@"plus.png"];
                 cell.lblSubtitle.text = @"";
            }
            else{
                
                cell.imgUser.image = [UIImage imageNamed:@"place.png"];
            }
        }
       
            
        
    }
    
//	UIImageView *accBtn = [[UIImageView alloc] initWithFrame:CGRectMake(288, 12, 20, 20)];
//	accBtn.image = [UIImage imageNamed:@"DSBtn.png"];
//	accBtn.userInteractionEnabled = NO;
//	[cell.contentView addSubview:accBtn];
//	[accBtn release];
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section==0) {
        if (([arr_events count]-1)==indexPath.row) {
            AddEventViewController * addeventobj = [[AddEventViewController alloc] initWithNibName:@"AddEventView" bundle:nil];
            [self.navigationController pushViewController:addeventobj animated:YES];
            [addeventobj release];
        }
        else{
            EventDetailsViewController * eventdetailsobj = [[EventDetailsViewController alloc] initWithNibName:@"EventDetailsView" bundle:nil];
            
            eventdetailsobj.EventTitle = [[arr_events objectAtIndex:indexPath.row] valueForKey:@"name"];
            eventdetailsobj.EventStart = [[arr_events objectAtIndex:indexPath.row] valueForKey:@"start"];
            eventdetailsobj.EventEnd = [[arr_events objectAtIndex:indexPath.row] valueForKey:@"end"];
            eventdetailsobj.EventId = [[arr_events objectAtIndex:indexPath.row] valueForKey:@"id"];
            eventdetailsobj.placename = [[arr_events objectAtIndex:indexPath.row] valueForKey:@"place_name"];
            
            [self.navigationController pushViewController:eventdetailsobj animated:YES];
            [eventdetailsobj release]; 
        }
    }
    else {
        if (([arr_places count]-1)==indexPath.row) {
            [AppDelegate sharedInstance].isFromAddEvent = FALSE;
            AddPlaceViewController * addplaceobj = [[AddPlaceViewController alloc] initWithNibName:@"AddPlaceView" bundle:nil];
            [self.navigationController pushViewController:addplaceobj animated:YES];
            [addplaceobj release]; 
        }
        else{
            PlaceDetailsViewController * placedetailsobj = [[PlaceDetailsViewController alloc] initWithNibName:@"PlaceDetailsView" bundle:nil];
            placedetailsobj.placeid = [[arr_places objectAtIndex:indexPath.row] valueForKey:@"id"];
            placedetailsobj.PlaceTitle = [[arr_places objectAtIndex:indexPath.row] valueForKey:@"name"];
            placedetailsobj.PlaceAdd = [[arr_places objectAtIndex:indexPath.row] valueForKey:@"address"];
            placedetailsobj.PlaceCity = [[arr_places objectAtIndex:indexPath.row] valueForKey:@"city"];
            
            
            [self.navigationController pushViewController:placedetailsobj animated:YES];
            [placedetailsobj release]; 
        }
    }
	
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
       // NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        
      //  if ([currSysVer intValue]>= 5.0) 
       // {
        //    tableview.frame=CGRectMake(0, 50, 320,410);

       // }else 
       // {
            tableview.frame=CGRectMake(0, 50, 320,317);
       // }
        // banner is invisible now and moved out of the screen on 50 px
    //    CGRectOffset(banner.frame,0, -banner.frame.size.height);

      //  CGPoint offset = CGPointMake(0, (1000000.0));
      //  [tableview setContentOffset:offset animated:NO];

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
        tableview.frame=CGRectMake(0, 0, 320,367);
        
        // banner is visible and we move it out of the screen, due to connection issue
        banner.frame = CGRectOffset(banner.frame,0, -banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

#pragma mark -
#pragma mark Memory Management Methods


- (void)dealloc
{
    [super dealloc];
    //[mapView release];
    [tableview release];
    [arr_events release];
    [arr_places release];
    [_locationManager release];
    [loginobj release];
}



@end
