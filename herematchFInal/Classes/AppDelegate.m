//
//  AppDelegate.m
//  HereMatch
//
//  Created by apple  on 9/2/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import "AppDelegate.h"

@implementation UINavigationBar (CustomImage)

- (void)drawRect:(CGRect)rect {
    if (![AppDelegate sharedInstance].ismail) {
        UIImage *image = [UIImage imageNamed: @"here-match-header.png"];
        [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    else{
        UIImage *image = [UIImage imageNamed: @"blackNavigationBar.png"];
        [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
       
        //self.barStyle = UIBarStyleBlackOpaque;
    }
    
        
   
}
@end

@implementation AppDelegate


@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize UserId;
@synthesize ismail;
@synthesize industry;
@synthesize groups;
@synthesize interests;
@synthesize school;
@synthesize hometown_city;
@synthesize hometown_state;

@synthesize AddEventStartDate;
@synthesize AddEventEndDate;
@synthesize  locationManager = _locationManager;
@synthesize location;
@synthesize DeviceToken;
@synthesize AddEventStartDateWsFormatted;
@synthesize AddEventEndDateWsFormatted;
@synthesize isFromAddplace;
@synthesize isFromAddEvent;
@synthesize arrMatchResons;
@synthesize checkTWLD;

+(AppDelegate *)sharedInstance{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
   
    //[self GDATA];
       
	
	[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"isLoggedin"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
     
    self.ismail = FALSE;
    self.UserId=0;
    start = 0;
    
//    self.locationManager=[[CLLocationManager alloc] init];
//    [self.locationManager setDelegate:self];
//    [self.locationManager startUpdatingLocation];
//    location = [[CLLocation alloc] init];
    
    
     
    arrMatchResons = [[NSMutableArray alloc] init];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    
    
    
    return YES;
}


#pragma mark -
#pragma mark PushNotification methods

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //NSLog(@"Error in registration. Error: %@", error); 
} 
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	
	
	//	if ([[NSUserDefaults standardUserDefaults] integerForKey:@"uid"]) 
	//	{
	
	//NSLog(@"deviceToken: %@", deviceToken); 
	
	NSString *st = [[[[deviceToken description]
                      stringByReplacingOccurrencesOfString: @"<" withString: @""] 
                     stringByReplacingOccurrencesOfString: @">" withString: @""] 
                    stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	//NSLog(@"strToken: %@", st); 
	
	self.DeviceToken = st;
    NSLog(@"st %@",st);
	
	//	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphone.misstwit.com/test/php/ins_name_token.php?username=David&device_token=%@&user_id=76",self.strToken]]];
	//	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	//	}
	
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
	//NSLog(@"notification received");
	
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"herematch" message:@"New User Checked in For the Place" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alert show];
	
    
}
#pragma mark -
#pragma mark Reachability methods

- (BOOL) isconnectedToNetwork:(NSString*)str {
    BOOL isInternet;
    Reachability* reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) { isInternet =NO;}
    else if (remoteHostStatus == ReachableViaWWAN) {isInternet = TRUE;}
    else if (remoteHostStatus == ReachableViaWiFi) { isInternet = TRUE;}
    return isInternet;
}

#pragma mark -
#pragma mark coreLocation methods

//-------------------------------------------------------------------------------------------------------------------

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {	
	//self.locationManager=[[CLLocationManager alloc] init];
    [self.locationManager stopUpdatingLocation];
//    if (start==0) {
//        self.location = newLocation;
//        
//        NSLog(@"Appdelgage Lat = %f and Long = %f",self.location.coordinate.latitude,self.location.coordinate.longitude);
//        [self performSelectorInBackground:@selector(UpdateUserLocation) withObject:nil];
//        start=1;
//    }
//    else {
//        CLLocationDistance meter;
//        meter = [self.location distanceFromLocation:newLocation];
//        if (meter > 800) {
//            
//            self.location = newLocation;
//            NSLog(@"App Delgate NEw Lat = %f and Long = %f",self.location.coordinate.latitude,self.location.coordinate.longitude);
//            //NSString * str = [NSString stringWithFormat:@"App Delgate Lat Long Changed NEw Lat = %f and Long = %f",[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude];
//            //DisplayAlert(str);
//            
//            [self performSelectorInBackground:@selector(UpdateUserLocation) withObject:nil];
//        }
//
//    }
    
    //[self.locationManager stopUpdatingLocation];
    
    
}

//--------------------------------------------------------------------------------------------------------------------

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
    DisplayAlertWithTitle(kLocationErrormsg, @"herematch");
	//NSLog(@"Error in Location Manager (GPS)");
}


- (void)UpdateUserLocation{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@change_user_lat_long.php?lat=%f&long=%f&user_id=%d",kWebServiceUrl,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,self.UserId]];
    //NSString * msg = [NSString stringWithFormat:@"Update User Location Url = %@",url];
    //DisplayAlert(msg);
    //NSLog(@"Update User Location Url = %@",url);
    NSString  *jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"jsonREsponse = %@",jsonRes);
    NSString * strlogin = [(NSString *)[jsonRes JSONValue] valueForKey:@"msg"];
    
    if ([strlogin isEqualToString:@"success"]) {
        
        //NSLog(@"User Location Update SuccesFully");     
        
    }
    else{
		//NSLog(@"User Location Update Failed");  
        //[[AppDelegate sharedInstance] hideLoadingView];
        //DisplayAlertWithTitle(@"Location Update Failed",@"HereMatch");
	}
	
    [pool release];
	//[strlogin release];
}

-(void)GDATA{
	
    
    //	GdataParser *parser = [[GdataParser alloc] init];
    //	[parser downloadAndParse:[NSURL URLWithString:@"http://www.openxcellaus.info/test_xml.php"] 
    //				 withRootTag:@"Record"
    //					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"id",@"id",@"description",@"description",nil] 
    //						 sel:@selector(finishGetData:) 
    //				  andHandler:self];
    GdataParser *parser = [[GdataParser alloc] init];
	[parser downloadAndParse:[NSURL URLWithString:@"http://openxcellaus.info/krupal_webservices_test/taxiApp/pull_Data.php?currentLat=11.11&currentLon=10.10"] 
				 withRootTag:@"Record"
					withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"reqID",@"reqID",@"noOfPassenger",@"noOfPassenger",nil] 
						 sel:@selector(finishGetData:) 
				  andHandler:self];	 
	/*
     TBxmlParser *parser = [[TBxmlParser alloc] init];
     [parser downloadAndParse:[NSURL URLWithString:@"http://openxcellaus.info/krupal_webservices_test/taxiApp/pull_Data.php?currentLat=11.11&currentLon=10.10"] 
     withRootTag:@"Record"
     withTags:[NSDictionary dictionaryWithObjectsAndKeys:@"reqID",@"reqID",@"currentLat",@"currentLat",nil] 
     sel:@selector(finishGetData:) 
     andHandler:self];
     */
	[parser release];
}
-(void)finishGetData:(NSDictionary*)dictionary{
    
    //NSLog(@"dictionay = %@",dictionary);
    
    //NSLog(@"arrycount  = %d",[[[[dictionary valueForKey:@"array"] objectAtIndex:1] valueForKey:@"noOfPassenger"] intValue]);
	
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

//	NSInteger getEnterBGId = [[NSUserDefaults standardUserDefaults] integerForKey:@"EnterBG"];
//	if (getEnterBGId == 2) {
//		[[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"EnterBG"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//	}
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[self.locationManager startUpdatingLocation];
//	NSInteger getEnterBGId = [[NSUserDefaults standardUserDefaults] integerForKey:@"EnterBG"];
//	if (getEnterBGId == 3) {
//		[[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"EnterBG"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//	}
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
      
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
- (BOOL) validateEmail: (NSString *) Email {
	
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:Email];
}


#pragma mark -
#pragma mark Acitivity Indicator methods
- (void)showLoadingView {
	[self performSelectorOnMainThread:@selector(doshowLoadingView) withObject:nil waitUntilDone:NO];
    
//	activityAlert = [[[ActivityAlertView alloc] 
//                      initWithTitle:@"Loading"
//                      message:@"Please wait..."
//                      delegate:self cancelButtonTitle:nil 
//                      otherButtonTitles:nil] autorelease];
//	
//    [activityAlert show];
}

// -----------------------------------------------------------------------------

- (void)hideLoadingView {
    
    	[self performSelectorOnMainThread:@selector(dohideLoadingView) withObject:nil waitUntilDone:NO];
    
    //if ([activityAlert isVisible]) {
        //[activityAlert close];
    //}
    
}
- (void)doshowLoadingView{
    [AlertHandler showAlertForProcess];
}


- (void)dohideLoadingView{
    [AlertHandler hideAlert];
}

- (void)dealloc
{
//	[_locationManager release];
//	[location release];
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
