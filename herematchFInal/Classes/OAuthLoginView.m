//
//  iPhone OAuth Starter Kit
//
//  Supported providers: LinkedIn (OAuth 1.0a)
//
//  Lee Whitney
//  http://whitneyland.com
//
#import <Foundation/NSNotificationQueue.h>
#import "OAuthLoginView.h"
#import "AppConstat.h"

//
// OAuth steps for version 1.0a:
//
//  1. Request a "request token"
//  2. Show the user a browser with the LinkedIn login page
//  3. LinkedIn redirects the browser to our callback URL
//  4  Request an "access token"
//
@implementation OAuthLoginView

@synthesize requestToken, accessToken, profile,delegate;

//
// OAuth step 1a:
//
// The first step in the the OAuth process to make a request for a "request token".
// Yes it's confusing that the work request is mentioned twice like that, but it is whats happening.
//
- (void)requestTokenFromProvider
{
    OAMutableURLRequestL *request = 
            [[[OAMutableURLRequestL alloc] initWithURL:requestTokenURL
                                             consumer:consumer
                                                token:nil   
                                             callback:linkedInCallbackURL
                                    signatureProvider:nil] autorelease];
    
    [request setHTTPMethod:@"POST"];   
    OADataFetcherL *fetcher = [[[OADataFetcherL alloc] init] autorelease];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenResult:didFinish:)
                  didFailSelector:@selector(requestTokenResult:didFail:)];    
}

//
// OAuth step 1b:
//
// When this method is called it means we have successfully received a request token.
// We then show a webView that sends the user to the LinkedIn login page.
// The request token is added as a parameter to the url of the login page.
// LinkedIn reads the token on their end to know which app the user is granting access to.
//
- (void)requestTokenResult:(OAServiceTicketL *)ticket didFinish:(NSData *)data 
{
    if (ticket.didSucceed == NO) 
        return;
        
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    self.requestToken = [[OATokenL alloc] initWithHTTPResponseBody:responseBody];
    [responseBody release];
    
    [self allowUserToLogin];
}
- (void)requestTokenResult:(OAServiceTicketL *)ticket didFail:(NSData *)error 
{
    NSLog(@"%@",[error description]);
}

//
// OAuth step 2:
//
// Show the user a browser displaying the LinkedIn login page.
// They type username/password and this is how they permit us to access their data
// We use a UIWebView for this.
//
// Sending the token information is required, but in this one case OAuth requires us
// to send URL query parameters instead of putting the token in the HTTP Authorization
// header as we do in all other cases.
//
- (void)allowUserToLogin
{
    NSString *userLoginURLWithToken = [NSString stringWithFormat:@"%@?oauth_token=%@&auth_token_secret=%@", 
        userLoginURLString, self.requestToken.key, self.requestToken.secret];
    
    userLoginURL = [NSURL URLWithString:userLoginURLWithToken];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL: userLoginURL];
    [webView loadRequest:request];     
}


//
// OAuth step 3:
//
// This method is called when our webView browser loads a URL, this happens 3 times:
//
//      a) Our own [webView loadRequest] message sends the user to the LinkedIn login page.
//
//      b) The user types in their username/password and presses 'OK', this will submit
//         their credentials to LinkedIn
//
//      c) LinkedIn responds to the submit request by redirecting the browser to our callback URL
//         If the user approves they also add two parameters to the callback URL: oauth_token and oauth_verifier.
//         If the user does not allow access the parameter user_refused is returned.
//
//      Example URLs for these three load events:
//          a) https://www.linkedin.com/uas/oauth/authorize?oauth_token=<token value>
//
//          b) https://www.linkedin.com/uas/oauth/authorize/submit   OR
//             https://www.linkedin.com/uas/oauth/authenticate?oauth_token=<token value>&trk=uas-continue
//
//          c) hdlinked://linkedin/oauth?oauth_token=<token value>&oauth_verifier=63600     OR
//             hdlinked://linkedin/oauth?user_refused
//             
//
//  We only need to handle case (c) to extract the oauth_verifier value
//
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType 
{
	NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
    
    addressBar.text = urlString;
    [activityIndicator startAnimating];
    
    BOOL requestForCallbackURL = ([urlString rangeOfString:linkedInCallbackURL].location != NSNotFound);
    if ( requestForCallbackURL )
    {
        BOOL userAllowedAccess = ([urlString rangeOfString:@"user_refused"].location == NSNotFound);
        if ( userAllowedAccess )
        {            
            [self.requestToken setVerifierWithUrl:url];
            [self accessTokenFromProvider];
        }
        else
        {
            // User refused to allow our app access
            // Notify parent and close this view
            [[NSNotificationCenter defaultCenter] 
                    postNotificationName:@"loginViewDidFinish"        
                                  object:self 
                                userInfo:nil];

            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else
    {
        // Case (a) or (b), so ignore it
    }
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
}

//
// OAuth step 4:
//
- (void)accessTokenFromProvider
{ 
    
    ///NSLog(@"request token:%@",self.requestToken);
    
    
    OAMutableURLRequestL *request = 
            [[[OAMutableURLRequestL alloc] initWithURL:accessTokenURL
                                             consumer:consumer
                                                token:self.requestToken   
                                             callback:nil
                                    signatureProvider:nil] autorelease];
    
    [request setHTTPMethod:@"POST"];
    OADataFetcherL *fetcher = [[[OADataFetcherL alloc] init] autorelease];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenResult:didFinish:)
                  didFailSelector:@selector(accessTokenResult:didFail:)];    
}

- (void)accessTokenResult:(OAServiceTicketL *)ticket didFinish:(NSData *)data 
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSLog(@"responce body:%@",responseBody);
    
    BOOL problem = ([responseBody rangeOfString:@"oauth_problem"].location != NSNotFound);
    if ( problem )
    {
        NSLog(@"Request access token failed.");
        NSLog(@"%@",responseBody);
    }
    else
    {
        self.accessToken = [[OATokenL alloc] initWithHTTPResponseBody:responseBody];
        [self testApiCall];
    }
    [responseBody release];
}

- (void)testApiCall
{
    
    NSLog(@"request token %@",self.requestToken);
    NSLog(@"access token %@",self.accessToken);
    
   // http://herematch.com/ws_herematch/linkedin_token.php?access_token=sdjfdfg&access_token_secret=sdfgjhfgdfg&id=1
   
    
//    NSString *URL =[NSString stringWithFormat:@"http://www.openxcellaus.info/linkedin/test/demo.php?requestToken=%@&accessToken=%@&oauthVerifier=%@",self.requestToken,self.accessToken,@""]; 
//    NSLog(@"url:%@",URL);
//    URL = [URL  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL* url = [NSURL URLWithString:URL];
//    // parsing
//    NSXMLParser* parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
//    [parser setDelegate:self];
//  
//    [parser parse];
    NSString *strRequestToken=[NSString stringWithFormat:@"%@",self.requestToken];
    NSString *strAccessToken=[NSString stringWithFormat:@"%@",self.accessToken];
    
	NSLog(@"request token = %@",strRequestToken);
    NSLog(@"access token = %@",strAccessToken);
    
    NSArray *arrRequestToken=[strRequestToken componentsSeparatedByString:@" "];
    NSArray *arrAccessToken=[strAccessToken componentsSeparatedByString:@" "];
    
    NSLog(@"request token : %@",arrRequestToken);
    NSLog(@"access token : %@",arrAccessToken);
    
    NSLog(@"Request_oauth_token : %@",[arrRequestToken objectAtIndex:1]);
    NSLog(@"oauth_token_secret : %@",[arrRequestToken objectAtIndex:3]);
    NSLog(@"oauth_verifier : %@",[arrRequestToken objectAtIndex:5]);
    NSLog(@"Access_oauth_token : %@",[arrAccessToken objectAtIndex:1]);
    NSLog(@"oauth_token_secret : %@",[arrAccessToken objectAtIndex:3]);
    
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
    
    
    NSString  *urlstring = [NSString stringWithFormat:@"%@linkedin_token.php?id=%d&access_token=%@&access_token_secret=%@",kWebServiceUrl,[AppDelegate sharedInstance].UserId,strQueryStar4,strQueryStar5];    
    
    NSURL *urlLinkdin = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
   // NSLog(@"profileupdate url = %@",url);
    
    
    NSString * jsonRes = [NSString stringWithContentsOfURL:urlLinkdin encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"linkdin value:%@",jsonRes);
    
    val=1;
    [self removelinkdin];
    
//    NSArray *arrRequestToken=[strRequestToken componentsSeparatedByString:@" "];
//    NSArray *arrAccessToken=[strAccessToken componentsSeparatedByString:@" "];
//    
//    NSLog(@"request token : %@",arrRequestToken);
//    NSLog(@"access token : %@",arrAccessToken);
//    
//	 NSLog(@"Request_oauth_token : %@",[arrRequestToken objectAtIndex:1]);
//	 NSLog(@"oauth_token_secret : %@",[arrRequestToken objectAtIndex:3]);
//	 NSLog(@"oauth_verifier : %@",[arrRequestToken objectAtIndex:5]);
//	 NSLog(@"Access_oauth_token : %@",[arrAccessToken objectAtIndex:1]);
//	 NSLog(@"oauth_token_secret : %@",[arrAccessToken objectAtIndex:3]);
//	
//	NSString *strQueryStar1=[NSString stringWithFormat:@"%@",[arrRequestToken objectAtIndex:1]];
//    strQueryStar1 = [strQueryStar1 substringToIndex:[strQueryStar1 length]-1];
//	strQueryStar1 = [[strQueryStar1 substringFromIndex:1] copy];
//	
//	NSString *strQueryStar2=[NSString stringWithFormat:@"%@",[arrRequestToken objectAtIndex:3]];
//    strQueryStar2 = [strQueryStar2 substringToIndex:[strQueryStar2 length]-1];
//	strQueryStar2 = [strQueryStar2 substringFromIndex:1];
//	
//	NSString *strQueryStar3=[NSString stringWithFormat:@"%@",[arrRequestToken objectAtIndex:5]];
//    strQueryStar3 = [strQueryStar3 substringToIndex:[strQueryStar3 length]-1];
//	strQueryStar3 = [strQueryStar3 substringFromIndex:1];
//	
//	NSString *strQueryStar4=[NSString stringWithFormat:@"%@",[arrAccessToken objectAtIndex:1]];
//    strQueryStar4 = [strQueryStar4 substringToIndex:[strQueryStar4 length]-1];
//	strQueryStar4 = [strQueryStar4 substringFromIndex:1];
//	
//	NSString *strQueryStar5=[NSString stringWithFormat:@"%@",[arrAccessToken objectAtIndex:3]];
//    strQueryStar5 = [strQueryStar5 substringToIndex:[strQueryStar5 length]-1];
//	strQueryStar5 = [strQueryStar5 substringFromIndex:1];
	
	[[NSUserDefaults standardUserDefaults] setObject:strRequestToken forKey:@"ART"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[[NSUserDefaults standardUserDefaults] setObject:strAccessToken forKey:@"AAT"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
//	WSPContinuous *wspcontinuous;
//	wspcontinuous = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_linkedinRequest_Key:strQueryStar1 Request_Secret:strQueryStar2 Varifier:strQueryStar3 Access_Key:strQueryStar4 Access_Secret:strQueryStar5]] 
//															rootTag:@"Record" 
//														startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] 
//														  endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"Id",@"Id",@"Title",@"Title",nil] 
//														  otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] 
//																sel:@selector(finishparsing:) 
//														 andHandler:self];	

	
	//NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.openxcellaus.info/linkedin/facebook-twitter-linkedin-status-update/statusupdate.php"]];
//	NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:url1];
//	NSString *body1 = [NSString stringWithFormat:@"request_key=%@&request_secret=%@&varifier=%@&access_key=%@&access_secret=%@",strQueryStar1,strQueryStar2,strQueryStar3,strQueryStar4,strQueryStar5];
//	
//	NSLog(@"body1 = %@",body1);
//	
//	NSData *requestBody1 = [body1 dataUsingEncoding:NSUTF8StringEncoding];
//	[request1 setHTTPMethod:@"GET"];
//	NSString *msgLength = [NSString stringWithFormat:@"%d", [requestBody1 length]];
//    [request1 setValue:@"text/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//	[request1 setValue:msgLength forHTTPHeaderField:@"Content-Length"];
//	[request1 setHTTPBody:requestBody1];
//	
//	
//	
//	
//    NSURLResponse *response = NULL;
//    NSError *requestError = NULL;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:&response error:&requestError];
//    NSString *responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
//    NSLog(@"placeid:%@",responseString);
	

    NSURL *url = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/~"];
    OAMutableURLRequestL *request = 
            [[OAMutableURLRequestL alloc] initWithURL:url
                                            consumer:consumer
                                               token:self.accessToken
                                            callback:nil
                                    signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];

    OADataFetcherL *fetcher = [[OADataFetcherL alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(testApiCallResult:didFinish:)
                  didFailSelector:@selector(testApiCallResult:didFail:)];    
    [request release];
	
	
}

-(void)finishparsing:(NSMutableDictionary*)dic
{
	
}

- (void)testApiCallResult:(OAServiceTicketL *)ticket didFinish:(NSData *)data 
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    self.profile = [responseBody objectFromJSONString];
    [responseBody release];
    
    // Notify parent and close this view
    [[NSNotificationCenter defaultCenter] 
            postNotificationName:@"loginViewDidFinish"        
                          object:self
                        userInfo:self.profile];

    [self dismissModalViewControllerAnimated:YES];
}

- (void)testApiCallResult:(OAServiceTicketL *)ticket didFail:(NSData *)error 
{
    NSLog(@"%@",[error description]);
}

//
//  This api consumer data could move to a provider object
//  to allow easy switching between LinkedIn, Twitter, etc.
//
- (void)initLinkedInApi
{
    apikey = @"4sukiw19xzvj";
    secretkey = @"tBD0oHAtVsbXMPyq";   

    consumer = [[OAConsumerL alloc] initWithKey:apikey
                                        secret:secretkey
                                         realm:@"http://api.linkedin.com/"];

    requestTokenURLString = @"https://api.linkedin.com/uas/oauth/requestToken";
    accessTokenURLString = @"https://api.linkedin.com/uas/oauth/accessToken";
    userLoginURLString = @"https://www.linkedin.com/uas/oauth/authorize";    
    linkedInCallbackURL = @"hdlinked://linkedin/oauth";
    
    requestTokenURL = [[NSURL URLWithString:requestTokenURLString] retain];
    accessTokenURL = [[NSURL URLWithString:accessTokenURLString] retain];
    userLoginURL = [[NSURL URLWithString:userLoginURLString] retain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLinkedInApi];
    [addressBar setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    }

- (void)viewDidAppear:(BOOL)animated
{
//    //if ([apikey length] < 64 || [secretkey length] < 64)
//    //{
//        UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle: @"OAuth Starter Kit"
//                          message: @"You must add your apikey and secretkey.  See the project file readme.txt"
//                          delegate: nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//        
//        // Notify parent and close this view
//        [[NSNotificationCenter defaultCenter] 
//         postNotificationName:@"loginViewDidFinish"        
//         object:self
//         userInfo:self.profile];
//        
//        [self dismissModalViewControllerAnimated:YES];
//   // }

    [self requestTokenFromProvider];
}
    
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}
-(void)removelinkdin
{
    if (val==1) {
      [delegate hideLinkdin];  
    }
    
    [AppDelegate sharedInstance].checkTWLD=TRUE;
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
