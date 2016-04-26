//
//  iPhone OAuth Starter Kit
//
//  Supported providers: LinkedIn (OAuth 1.0a)
//
//  Lee Whitney
//  http://whitneyland.com
//
#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "OAConsumerL.h"
#import "OAMutableURLRequestL.h"
#import "OADataFetcherL.h"
#import "OATokenManagerL.h"
#import "AppDelegate.h"
//#import "WSPContinuous.h"
//#import "webService.h"
@protocol callLinkdinremove <NSObject>

-(void)hideLinkdin;

@end
@interface OAuthLoginView : UIViewController <UIWebViewDelegate,NSXMLParserDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextField *addressBar;
    
    OATokenL *requestToken;
    OATokenL *accessToken;
    
    NSDictionary *profile;
    
    // Theses ivars could be made into a provider class
    // Then you could pass in different providers for Twitter, LinkedIn, etc
    NSString *apikey;
    NSString *secretkey;
    NSString *requestTokenURLString;
    NSURL *requestTokenURL;
    NSString *accessTokenURLString;
    NSURL *accessTokenURL;
    NSString *userLoginURLString;
    NSURL *userLoginURL;
    NSString *linkedInCallbackURL;
    OAConsumerL *consumer;
    id<callLinkdinremove> delegate;
    int val;
}

@property(nonatomic, retain) OATokenL *requestToken;
@property(nonatomic, retain) OATokenL *accessToken;
@property(nonatomic, retain) NSDictionary *profile;
@property (nonatomic,retain) id<callLinkdinremove> delegate;

- (void)initLinkedInApi;
- (void)requestTokenFromProvider;
- (void)allowUserToLogin;
- (void)accessTokenFromProvider;
- (void)testApiCall;
-(IBAction)removelinkdin;

@end
