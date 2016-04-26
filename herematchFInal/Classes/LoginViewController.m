//
//  LoginViewController.m
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/6/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize txtemail, txtpassword;
@synthesize  locationManager = _locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currSysVer intValue]>= 5.0) {
        UIImage *backgroundImage = [UIImage imageNamed:@"here-match-header.png"];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
    }
    
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SignUpLogin"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SignUpLoginEA"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SignUpLoginPW"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor]; 
    txtemail.delegate = self;
    txtpassword.delegate=self;
	
	
   
    
    self.locationManager=[[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    
}
- (void)viewWillAppear:(BOOL)animated{
    
	NSInteger signUpLogin = [[NSUserDefaults standardUserDefaults] integerForKey:@"SignUpLogin"];
    if (signUpLogin == 2) {
		txtemail.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"SignUpLoginEA"];
		txtpassword.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"SignUpLoginPW"];
//		self.tabBarController.selectedIndex = 2;
//		[self btnLogin_Click];
		
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SignUpLogin"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SignUpLoginEA"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SignUpLoginPW"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	//[self.locationManager startUpdatingLocation];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [self.locationManager stopUpdatingLocation];
}
#pragma mark -
#pragma mark coreLocation methods

//-------------------------------------------------------------------------------------------------------------------

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {	
	
    
    [AppDelegate sharedInstance].location = newLocation;
   
    [self performSelectorInBackground:@selector(UpdateUserLocation) withObject:nil];
    [self.locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
    [[AppDelegate sharedInstance] hideLoadingView];
    DisplayAlertWithTitle(kLocationErrormsg, @"herematch");
	//NSLog(@"Error in Location Manager (GPS)");
}
#pragma mark - Action Methods
- (IBAction) btnLogin_Click{
   
    [txtemail resignFirstResponder];
    [txtpassword resignFirstResponder];
    
    if ([txtemail.text length] == 0 || [txtpassword.text length] == 0) {
        DisplayAlertWithTitle(@"Please enter All Fields.",@"herematch");
        
    } 
	
    else if (![[AppDelegate sharedInstance] validateEmail:txtemail.text]) {
        DisplayAlertWithTitle(@"Please Enter A Valid Email Address.",@"herematch");
    }
    else {
        
        if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@login.php?email=%@&password=%@&udid=%@",kWebServiceUrl,txtemail.text,txtpassword.text,[AppDelegate sharedInstance].DeviceToken]]) {
            DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
            return;
        }

                
        [[AppDelegate sharedInstance] showLoadingView];
        [self performSelectorInBackground:@selector(doLogin) withObject:nil];
        
              
    }
	
        
}
- (void)doLogin{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
//    
//    
//    // Build post data
//	NSString* url = [ NSString stringWithFormat:@"http://myabilita.com/session.xml"];
//	NSMutableData* postData = [[NSMutableData new] autorelease];
//	NSString *postStr=[NSString stringWithFormat:@"user[email]=dev5@openxcell.info&user[password]=om1234"];
//    //NSString *postStr=[NSString stringWithFormat:@"user[login]=yaxita&user[first_name]=yaxita&user[last_name]=shah&user[email]=yax@yax.com&user[password]=yaxitashah&user[password_confirmation]=1&user[terms]=1&user[subscribe_to_announcements]=1&user[subscribe_to_events]=1"];
//	[postData appendData:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	// Build post request
//	NSMutableURLRequest* postRequest = [[[NSMutableURLRequest alloc] init] autorelease];
//	[postRequest setURL:[NSURL URLWithString:url]];
//	[postRequest setHTTPMethod:@"POST"];
//	[postRequest setHTTPBody:postData];
//	
//	NSString * postString = [[NSString alloc]initWithData:postData encoding:NSASCIIStringEncoding];
//        NSLog(@"url: %@",url);
//    NSLog(@"postString: %@",postString);
//	
//	// Send data
//	NSURLResponse* response;
//	NSError* error = nil;
//	
//	NSData* data = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
//	NSString  *jsonRes=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	
//	
//	[postString release];

//	// Parse feedback
//	

    
    
    
    
    NSString *strLoginUrl=[NSString stringWithFormat:@"%@login.php?email=%@&password=%@&udid=%@",kWebServiceUrl,txtemail.text,txtpassword.text,[AppDelegate sharedInstance].DeviceToken];
    strLoginUrl=[strLoginUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:strLoginUrl];
    //NSLog(@"Login url = %@",url);
    NSString  *jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"jsonREsponse = %@",jsonRes);
    NSString * strlogin = [(NSString *)[jsonRes JSONValue] valueForKey:@"status"];
    
    if ([strlogin isEqualToString:@"success"]) {
                
       // DisplayAlertWithTitle(@"Login SuccesFull",@"HereMatch");
        [AppDelegate sharedInstance].UserId = (int)[[[jsonRes JSONValue] valueForKey:@"User_id"] intValue];
        
        
        [[NSUserDefaults standardUserDefaults] setInteger:[AppDelegate sharedInstance].UserId forKey:@"UserLoginID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
       // NSLog(@"Userid = %d",[AppDelegate sharedInstance].UserId);
        
         //[self.locationManager startUpdatingLocation];
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SignUpLogin"];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
        [[AppDelegate sharedInstance] hideLoadingView];
        [self dismissModalViewControllerAnimated:YES];
		
		[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isLoggedin"];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
        
        NSInteger isloggedin = [[NSUserDefaults standardUserDefaults] integerForKey:@"isLoggedin"];
     //   NSLog(@"isloggedin FROM LOGIN SCREEN= %d",isloggedin);
        //[self performSelectorOnMainThread:@selector(DissmisView) withObject:nil waitUntilDone:NO];
    }
    else{
        [[AppDelegate sharedInstance] hideLoadingView];
        
        if ([[[jsonRes JSONValue] valueForKey:@"msg"] isEqualToString:@"User is not yet Activated"]) {
           DisplayAlertWithTitle(@"An activation link has been sent to the email address you provided. Please click on that link to activate your account.",@"herematch"); 
        }else{
            DisplayAlertWithTitle(@"Login Failed. Please Try Again.",@"herematch");
        }
	}
    [pool release];
}

- (void)UpdateUserLocation{
    
    
    
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
      
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@change_user_lat_long.php?lat=%f&long=%f&user_id=%d",kWebServiceUrl,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,[AppDelegate sharedInstance].UserId]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@change_user_lat_long.php?lat=%f&long=%f&user_id=%d",kWebServiceUrl,[AppDelegate sharedInstance].location.coordinate.latitude,[AppDelegate sharedInstance].location.coordinate.longitude,[AppDelegate sharedInstance].UserId]];
    //NSString * msg = [NSString stringWithFormat:@"Update User Location Url = %@",url];//me keyur
    //NSLog(@"%@",msg);
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
    [[AppDelegate sharedInstance] hideLoadingView];
     
   
    
    [self dismissModalViewControllerAnimated:YES];
//     [self dismissModalViewControllerAnimated:YES];
	[strlogin release];
    [pool release];
}



//- (void) DissmisView{
//    [self dismissModalViewControllerAnimated:YES];
//}
- (IBAction) btnSignup_Click{
    SignUpViewController * signupobj = [[SignUpViewController alloc] initWithNibName:@"SignUpView" bundle:nil];
    [self presentModalViewController:signupobj animated:YES];
    [signupobj release];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == txtemail)
    {
        [txtemail resignFirstResponder];
        [txtpassword becomeFirstResponder];
    }
    
    else{
        [txtpassword resignFirstResponder];
    }
    
    return YES;
}

- (void)dealloc
{
    [txtpassword release];
    [txtemail release];
    [super dealloc];
}

@end