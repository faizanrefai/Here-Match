//
//  SignUpViewController.m
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/6/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import "SignUpViewController.h"


@implementation SignUpViewController
@synthesize tableview;
@synthesize btnAcceptTerms;
@synthesize btnSubscribeAnouncements;
@synthesize btnSubscribeEvents;

@synthesize webViewTU;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
  //  UINavigationBar *navBar = [[self navigationController] navigationBar];

    
   // UINavigationBar *navBar = [[self navigationController] navigationBar];
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currSysVer intValue]>= 5.0) {
        UIImage *backgroundImage = [UIImage imageNamed:@"here-match-header.png"];
        [navigationbar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
    }
    

	
//	[[NSUserDefaults standardUserDefaults] setInteger:111 forKey:@"RandomStr"];
//	[[NSUserDefaults standardUserDefaults] synchronize];
	
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    btnClose = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_refresh_click)];

    
    [self createTableCellControls];
	viewTermsUse.hidden = YES;
    webViewTU.delegate = self;
        [webViewTU setScalesPageToFit:NO];
}
# pragma  mark label -
# pragma mark custom methods

-(void)createTableCellControls{
    
    
    lblFirstName = [self createLabel:200 :@"First Name":1];
    txtFirstName =  [self createTextField:0:300:@"First Name"];
    txtFirstName.tag = 101;
    
    lblLastName = [self createLabel:200 :@"Last Name":1];
    txtLastName =  [self createTextField:0:300:@"Last Name"];
    txtLastName.tag = 102;
    
    lblEmailAddress = [self createLabel:100 :@"Email Address":1];
    txtEmailAddress = [self createTextField:0:300:@"Email"];
    [txtEmailAddress setKeyboardType:UIKeyboardTypeEmailAddress];
    txtEmailAddress.tag = 103;
    
       
    lblPassword = [self createLabel:150 :@"Password":1];
    txtPassword =  [self createTextField:0:300:@"Password"];
    txtPassword.tag = 104;
    txtPassword.secureTextEntry = YES;
    
    lblConfirmPassword = [self createLabel:150 :@"Confirm Password":1];
    txtConfirmPassword =  [self createTextField:0:300:@"Confirm Password"];
    txtConfirmPassword.tag = 105;
    txtConfirmPassword.secureTextEntry = YES;
    
    txtAcceptTerms = [self createTextView:150 :@"I accept the terms and conditions"];
    txtSubscribeAnouncements = [self createTextView:150 :@"Subscribe to announcements"];
    txtSubscribeEvents = [self createTextView:150 :@"Subscribe to \nevents"];
    
    isAcceptTerms = NO;
    isSubscribeAnouncements = NO;
    isSubscribeEvents = NO;
    
    self.btnAcceptTerms = [self createChkBoxButton];
    self.btnAcceptTerms.tag=201;
    [btnAcceptTerms setSelected:YES];
    
    self.btnSubscribeEvents = [self createChkBoxButton];
    self.btnSubscribeEvents.tag=202;
    
    self.btnSubscribeAnouncements = [self createChkBoxButton];
    self.btnSubscribeAnouncements.tag=203;

}
-(UIButton *)createChkBoxButton{
    //UIButton * btn = [[UIButton alloc] init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(270, 5, 34, 34);
    [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_uchkd.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"checkbox_chkd.png"] forState:UIControlStateSelected];
    
    [btn addTarget:self action:@selector(btnCheckBoxClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
//	[btn release];
//	btn = nil;
}

-(UITextView *)createTextView:(int)width:(NSString *)str{
    UITextView *txt =  [[UITextView alloc] initWithFrame:CGRectMake(15, -5, width, 45)];
    
    txt.font = [UIFont fontWithName:@"Helvetica" size:14];
    txt.textAlignment = UITextAlignmentLeft;
    [txt setEditable:NO];
    [txt setUserInteractionEnabled:NO];
    [txt setText:str];
    [txt setBackgroundColor:[UIColor clearColor]];
    return txt;
	[txt release];
	txt = nil;
}

-(UITextField *)createTextField:(int)left:(int)width:(NSString *) placeholder{
    UITextField *txt =  [[UITextField alloc] initWithFrame:CGRectMake(20, 8, width, 35)];
    txt.returnKeyType = UIReturnKeyNext;
    txt.font = [UIFont fontWithName:@"Helvetica" size:14];
    txt.textAlignment = UITextAlignmentLeft;
    [txt setBorderStyle:UITextBorderStyleNone];
    txt.placeholder = placeholder;
    txt.delegate = self;
    return txt;
	[txt release];
	txt = nil;
}

-(UILabel *)createLabel:(int)width:(NSString *)str :(int)nooflines {
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, width, 35)];
    lbl.font =  [UIFont fontWithName:@"Helvetica" size:14];
    //[lbl setTextColor:[UIColor colorFromRGBIntegers:126 green:126 blue:126 alpha:1]];
    [lbl setTextColor:[UIColor blackColor]];
	lbl.numberOfLines = nooflines;
	lbl.backgroundColor = [UIColor clearColor];
	lbl.textAlignment = UITextAlignmentLeft;
	lbl.adjustsFontSizeToFitWidth=NO;
    lbl.text = str;
    
    return lbl;
	[lbl release];
	lbl = nil;
}

-(IBAction)clickTermsUse {
       
    viewTermsUse.hidden = NO;
       
	NSString *urlAddress = @"http://herematch.com:3000/ws_herematch/terms-of-use.php";
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webViewTU loadRequest:requestObj];  
    [self.view bringSubviewToFront:viewTermsUse];
    
}
-(IBAction)clickPrivacyPlicy{
    
    
    viewTermsUse.hidden = NO;
    
	NSString *urlAddress = @"http://herematch.com:3000/ws_herematch/privacy-policy.php";
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webViewTU loadRequest:requestObj];
     
    [self.view bringSubviewToFront:viewTermsUse];
}
-(IBAction)clickCloseTermsUseView
{
    
	viewTermsUse.hidden = YES;
}

#pragma mark Webview Delegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [[AppDelegate sharedInstance] showLoadingView];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
        [[AppDelegate sharedInstance] hideLoadingView];
        [webViewTU setScalesPageToFit:NO];
}
# pragma  mark label -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if (bEditMode == TRUE) 
    //        return  7;
    return 7;
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//    
//    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-Big.png"]];
//    cell.backgroundColor = [UIColor lightTextColor];
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    //    cell.backgroundColor=[UIColor lightGrayColor];
//}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", indexPath.row] ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = nil;
    
    // Set up the cell...
    if (indexPath.row == 0) {
        //[cell addSubview:lblFirstName];
        [cell addSubview:txtFirstName];
        
    }
    
    if (indexPath.row == 1) {
        //[cell addSubview:lblLastName];
        [cell addSubview:txtLastName];
    }
    if (indexPath.row == 2) {
        //[cell addSubview:lblEmailAddress];
        [cell addSubview:txtEmailAddress];
    }
    if (indexPath.row == 3) {
        //[cell addSubview:lblPassword];
        [cell addSubview:txtPassword];
    }
    if (indexPath.row == 4) {
        //[cell addSubview:lblPassword];
        [cell addSubview:txtConfirmPassword];
    }
//    if (indexPath.row == 5) {
       
//        [cell addSubview:txtAcceptTerms];
//        [cell addSubview:self.btnAcceptTerms];
//        
//    }
    if (indexPath.row == 5) {
        [cell addSubview:txtSubscribeAnouncements];
        [cell addSubview:self.btnSubscribeAnouncements];
    }
    if (indexPath.row == 6) {
        [cell addSubview:txtSubscribeEvents];
        [cell addSubview:self.btnSubscribeEvents];
    }
    
      
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 4) {
        return 45;
    }
    else{
        return 35; 
    }
        
    
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//	return 40;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//	return 90.0;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
////    UIView *tblHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
////    
////    [tblHeader addSubview:self.btnUserPhoto];
////    
////    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(90, 10, 221, 70)];
////    UIImage *imgBack = [UIImage imageNamed:@"signupheader.png"];
////    [imageview setImage:imgBack];
////    
////    [tblHeader addSubview:imageview];
////    
////    [tblHeader addSubview:lblFirstName];
////    [tblHeader addSubview:txtFirstName];
////    
////    [tblHeader addSubview:lblLastName];
////    [tblHeader addSubview:txtLastName];
////    
////    return tblHeader;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *tblFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
//    [tblFooter setBackgroundColor:[UIColor clearColor]];
//    
//    
//    //UIButton *btnSignup = [[UIButton alloc]init];
//    UIButton * btnSignup = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnSignup setFrame:CGRectMake(48, 53, 224, 40)];
//    [btnSignup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btnSignup.titleLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:20];
//    //[btnSignup setTitle:@"Sign Up" forState:UIControlStateNormal];
//    [btnSignup setBackgroundImage:[UIImage imageNamed:@"SignUpButton.png"] forState:UIControlStateNormal];
//    //[btnSignup setBackgroundImage:[UIImage imageNamed:@"btnbackground_hv.png"] forState:UIControlStateHighlighted];
//    [btnSignup addTarget:self action:@selector(btnSignup_Click) forControlEvents:UIControlEventTouchUpInside];
//    
//    [tblFooter addSubview:btnSignup];
//	
//    
//    
//    
//    UITextView *txtTermsUse =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 330, 35)];
//    
//    txtTermsUse.font = [UIFont fontWithName:@"Helvetica" size:11];
//    txtTermsUse.textAlignment = UITextAlignmentLeft;
//    txtTermsUse.backgroundColor = [UIColor clearColor];
//    //[txtTermsUse setEditable:NO];
//    [txtTermsUse setScrollEnabled:NO];
//    [txtTermsUse setDataDetectorTypes:UIDataDetectorTypeLink];
//    //[txt setUserInteractionEnabled:NO];
//    [txtTermsUse setText:@"By clicking sign up, you confirm that you have read, understood, and accept the terms of use and privacy policy."];
//    txtTermsUse.delegate = self;
//	//[btnSignup release];	
////	UIButton * btnTermsUse = [UIButton buttonWithType:UIButtonTypeCustom];
////    [btnTermsUse setFrame:CGRectMake(0, 8, 320, 20)];
////    [btnTermsUse setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    btnTermsUse.titleLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:14];
////
////    [btnTermsUse setTitle:@"By clicking sign up, you confirm that you have read, understood, and accept the terms of use and privacy policy." forState:UIControlStateNormal];
//    //[btnTermsUse setBackgroundImage:[UIImage imageNamed:@"SignUpButton.png"] forState:UIControlStateNormal];
//    //[btnSignup setBackgroundImage:[UIImage imageNamed:@"btnbackground_hv.png"] forState:UIControlStateHighlighted];
//    //[btnTermsUse addTarget:self action:@selector(clickTermsUse) forControlEvents:UIControlEventTouchUpInside];
//    
//    [tblFooter addSubview:txtTermsUse];
//	//[btnTermsUse release];
//    
////    UILabel *lblTerms = [[UILabel alloc]initWithFrame:CGRectMake(0, 52, 320, 20)];
////    lblTerms.font = [UIFont fontWithName:@"Helvetica" size:14];
////    lblTerms.numberOfLines = 1;
////    lblTerms.backgroundColor = [UIColor clearColor];
////    lblTerms.textAlignment = UITextAlignmentCenter;
////    lblTerms.textColor = [UIColor darkGrayColor];
////    lblTerms.shadowColor = [UIColor whiteColor];
////    lblTerms.shadowOffset = CGSizeMake(0.0, 1.0);
////    lblTerms.adjustsFontSizeToFitWidth=YES;
////    lblTerms.text = @"By signing up you agree to the terms of use";
////    
////    [tblFooter addSubview:lblTerms];
////    
////    [lblTerms release];
//    //    }
//    
//    return tblFooter;
//}
-(IBAction)btnSignup_Click{
     
    
    if ([txtFirstName.text length] == 0) {
		DisplayAlertWithTitle(@"Please Enter Your First Name.",@"herematch");
        
	}
    else if ([txtLastName.text length] == 0) {
		DisplayAlertWithTitle(@"Please Enter Your Last Name.",@"herematch");
        
	}
    else if ([txtEmailAddress.text length] == 0) {
        
        DisplayAlertWithTitle(@"Please Enter Your Email Address.",@"herematch");
    }
    else if ([txtPassword.text length] == 0) {
        
        DisplayAlertWithTitle(@"Please Enter Your Password.",@"herematch");
    }else if([txtPassword.text length]<6)
    {
        DisplayAlertWithTitle(@"Password must be at least 6 characters.",@"herematch");
    }
       else if (![txtPassword.text isEqualToString:txtConfirmPassword.text]) {
        
        DisplayAlertWithTitle(@"Password And Confirm Password Do Not Match. Please Try Again.",@"herematch");
    }
    
   

    else if (![[AppDelegate sharedInstance] validateEmail:txtEmailAddress.text]) {
        DisplayAlertWithTitle(@"Please Enter A Valid Email Address.",@"herematch");
    }
    else if (!btnAcceptTerms.selected) {
        DisplayAlertWithTitle(@"Please Accept The Terms Of Use.",@"herematch");
    }
    else {
         if([self check:txtPassword.text] && [self checkLetter:txtPassword.text])
        {
            if (![[AppDelegate sharedInstance] isconnectedToNetwork:[NSString stringWithFormat:@"%@registration.php?email=%@&password=%@&first_name=%@&last_name=%@&username=%@&subscribe_to_announcements=%d&subscribe_to_events=%d&terms=%d",kWebServiceUrl,txtEmailAddress.text,txtPassword.text,txtFirstName.text,txtLastName.text,@"",(btnSubscribeAnouncements.selected?1:0),(btnSubscribeEvents.selected?1:0),(btnAcceptTerms.selected?1:0)]]) {
                DisplayAlertWithTitle(@"Internet Connectivity Not Available.", @"herematch");
                return;
            }
            
            
            [[AppDelegate sharedInstance] showLoadingView];
            [self performSelectorInBackground:@selector(doSignUp) withObject:nil];
  
        }else
        {
            DisplayAlertWithTitle(@"Password must include at least 1 non-alphabetical character.",@"herematch");

        }

               
    }
}
- (void)doSignUp{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
	NSString *strLogin = [[self generateString] retain];
	//NSLog(@"Str Login : %@",strLogin);
    //NSString * urlstring = [NSString stringWithFormat:@"%@registration.php?email=%@&password=%@&first_name=%@&last_name=%@&username=%@&subscribe_to_announcements=%d&subscribe_to_events=%d&terms=%d",kWebServiceUrl,txtEmailAddress.text,txtPassword.text,txtFirstName.text,txtLastName.text,@"",(btnSubscribeAnouncements.selected?1:0),(btnSubscribeEvents.selected?1:0),(btnAcceptTerms.selected?1:0)];  
	NSString * urlstring = [NSString stringWithFormat:@"%@registration.php?login=%@&email=%@&password=%@&first_name=%@&last_name=%@&subscribe_to_announcements=%d&subscribe_to_events=%d&terms=%d",kWebServiceUrl,strLogin,txtEmailAddress.text,txtPassword.text,txtFirstName.text,txtLastName.text,(btnSubscribeAnouncements.selected?1:0),(btnSubscribeEvents.selected?1:0),(btnAcceptTerms.selected?1:0)];
    //NSLog(@"REgistration url = %@",urlstring);
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"jsonREsponse = %@",jsonRes);
    NSString * strsignup = [[(NSString *)[jsonRes JSONValue] valueForKey:@"msg"] retain];
    
    if ([strsignup isEqualToString:@"Success"]) {
        
        
        [[AppDelegate sharedInstance] hideLoadingView];
        DisplayAlertWithTitle(@"Registration Successful.", @"herematch");
		
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SignUpLogin"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"SignUpLogin"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SignUpLoginEA"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[[NSUserDefaults standardUserDefaults] setObject:txtEmailAddress.text forKey:@"SignUpLoginEA"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SignUpLoginPW"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[[NSUserDefaults standardUserDefaults] setObject:txtPassword.text forKey:@"SignUpLoginPW"];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissModalViewControllerAnimated:YES];
        
    }
    else{
        
        [[AppDelegate sharedInstance] hideLoadingView];
        if ([[[jsonRes JSONValue] valueForKey:@"message"] isEqualToString:@"Email already exist"]) {
             DisplayAlertWithTitle(@"Email Address Already Exists.", @"herematch");
        }
        else{
            DisplayAlertWithTitle(@"Registration Failed ", @"herematch");
        }
        
        
        
        
    }
	[strLogin release];
	[strsignup release];
    [pool release];
}
- (void) btnCheckBoxClick:(id)sender{
    UIButton * btn = (UIButton *)sender;
    
    if(btn.selected){
        [btn setSelected:NO];
    }
    else{
        [btn setSelected:YES];
    }
        
    
}
- (IBAction) cancelRegistration
{
    
    [self dismissModalViewControllerAnimated:YES];
    
}

-(NSString*)generateString
{
    
    NSDate *date = [NSDate date];
    NSString *timeString = [NSString stringWithFormat:@"%@",date];
    timeString = [timeString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return timeString;
//	NSUserDefaults *tmp = [NSUserDefaults standardUserDefaults];
//	if ([tmp integerForKey:@"random"]) {
//        int a = [tmp integerForKey:@"random"];
//        a++;
//        [tmp setInteger:a forKey:@"random"];
//        [tmp synchronize];
//    }else {
//        
//        [tmp setInteger:10000000 forKey:@"random"];
//        [tmp synchronize];
//		
//    }
//	
//    NSLog(@"random %d",[tmp integerForKey:@"random"]);
//	NSString *strChange = [NSString stringWithFormat:@"%d",[tmp integerForKey:@"random"]];
//    [strChange stringByTrimmingCharactersInSet:<#(NSCharacterSet *)#>]
//	return strChange;
}


# pragma  mark label -
# pragma mark UITextfield delegate methods

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
    NSInteger nextTag = textField.tag + 1;
	UIResponder* nextResponder = [[textField.superview superview] viewWithTag:nextTag];
    
        
	if (nextResponder) {
		[nextResponder becomeFirstResponder];		
	}
	else{		
		[textField resignFirstResponder];
        //[self.tblSignup setContentSize:CGSizeMake(self.tblSignup.frame.size.width, self.tblSignup.frame.size.height - 200)];
        [self.tableview scrollsToTop];
	}
    
    return YES;
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
   
    //NSLog(@"textviewclick");
	return YES;
}
-(BOOL)check:(NSString *)password
{
    NSCharacterSet* digitsCharSet = [NSCharacterSet decimalDigitCharacterSet];
   // NSCharacterSet* symbolCharSet=[NSCharacterSet symbolCharacterSet];
    NSCharacterSet* allsymbol=[NSCharacterSet characterSetWithCharactersInString:@"~`!@#$%^&*()_-+=|\{}[]:;,.<>/?"];
    
    if ([password rangeOfCharacterFromSet:digitsCharSet].location == NSNotFound && [password rangeOfCharacterFromSet:allsymbol].location == NSNotFound)
    {
        return NO;
    }

    return YES;
        
}
-(BOOL)checkLetter:(NSString *)password
{
    NSCharacterSet* LetterCharSet = [NSCharacterSet letterCharacterSet];
 
    if ([password rangeOfCharacterFromSet:LetterCharSet].location == NSNotFound)
    {
        return NO;
    }
    
    return YES;
    
}
- (void)dealloc
{
    [txtFirstName release];
    [txtLastName release];
    [txtUsername release];
    [txtEmailAddress release];
    [txtPassword release];
    [webViewTU release];
    [super dealloc];
}

@end
