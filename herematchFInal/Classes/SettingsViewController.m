//
//  SettingsViewController.m
//  HereMatch
//
//  Created by apple123 on 10/8/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//
#import "SettingsViewController.h"
#import "LoginViewController.h"

#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSZone.h>

@implementation SettingsViewController
@synthesize btncancel;


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currSysVer intValue]>= 5.0) {
        UIImage *backgroundImage = [UIImage imageNamed:@"here-match-header.png"];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
    }

    viewTermsUse.hidden = YES;
    btncancel = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(clickCloseTermsUseView)];
    self.navigationItem.rightBarButtonItem = btncancel;
    self.navigationItem.rightBarButtonItem = nil;
   
        webViewTU.delegate = self;
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{

    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        
         cell = [[[UITableViewCell alloc]        initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch (indexPath.section) {
        case 0 :
            cell.detailTextLabel.text = @"1.0";
            cell.textLabel.text=[NSString stringWithFormat:@"Version Number"];
            break;
        case 1 :
            cell.textLabel.text=[NSString stringWithFormat:@"Privacy Policy"];
            break;
        case 2 :
            cell.textLabel.text=[NSString stringWithFormat:@"Terms of Use"];
            break;

        case 3 :
            cell.textLabel.text=[NSString stringWithFormat:@"Logout"];
            break;
         
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0 :
             //NSLog(@"Remain To Add");
            break;
        case 1 :
             self.navigationItem.hidesBackButton = YES;
            viewTermsUse.hidden = NO;
           self.navigationItem.rightBarButtonItem = btncancel;
            NSString *urlAddress = @"http://herematch.com:3000/ws_herematch/privacy-policy.php";
            
            //Create a URL object.
            NSURL *url = [NSURL URLWithString:urlAddress];
            
            //URL Requst Object
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            
            //Load the request in the UIWebView.
            [webViewTU loadRequest:requestObj];
            break;
        case 2 :
             self.navigationItem.hidesBackButton = YES;
            viewTermsUse.hidden = NO;
            self.navigationItem.rightBarButtonItem = btncancel;
            NSString *urlAddress1 = @"http://herematch.com:3000/ws_herematch/terms-of-use.php";
            
            //Create a URL object.
            NSURL *url1 = [NSURL URLWithString:urlAddress1];
            
            //URL Requst Object
            NSURLRequest *requestObj1 = [NSURLRequest requestWithURL:url1];
            
            //Load the request in the UIWebView.
            [webViewTU loadRequest:requestObj1];

            break;
        case 3 :
                     
            self.tabBarController.selectedIndex=0;
            
            NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
                [cookies deleteCookie:cookie];
            }
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBAT"];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OATK"];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OATS"];
            
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ART"];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AAT"];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserLoginID"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            LoginViewController *loginobj= [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
            [self presentModalViewController:loginobj animated:YES];
            
            break;
            
        default:
            break;
    }

}
-(IBAction)clickCloseTermsUseView
{

    self.navigationItem.hidesBackButton = NO;
	viewTermsUse.hidden = YES;
    self.navigationItem.rightBarButtonItem = nil;
}
#pragma mark Webview Delegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [[AppDelegate sharedInstance] showLoadingView];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[AppDelegate sharedInstance] hideLoadingView];
    [webViewTU setScalesPageToFit:NO];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
