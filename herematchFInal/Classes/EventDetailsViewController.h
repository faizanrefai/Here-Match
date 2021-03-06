//
//  EventDetailsViewController.h
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/3/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppConstat.h"
#import "AppDelegate.h"

#import "FBWebView.h"
#import "iAd/ADBannerView.h"


//#import "SA_OAuthTwitterEngine.h"
//#import "SA_OAuthTwitterController.h"
//#import "iCodeOauthViewController.h"

@interface EventDetailsViewController : UIViewController<UIAlertViewDelegate,ADBannerViewDelegate> {
     IBOutlet UIView * titleview;
    
    IBOutlet UILabel *lblEventTitle;
    IBOutlet UILabel *lblEventStart;
    IBOutlet UILabel *lblEventEnd;
    IBOutlet UILabel *lblMsg;
    IBOutlet UILabel *lblPlace;
    
    IBOutlet UIButton  * btnCheckin;
    IBOutlet UIButton  * btnCheckOut;
    
    
    NSString * EventTitle;
    NSString * EventStart;
    NSString * EventEnd;
    NSString * placename;
    NSString * EventId;
    
    UIAlertView *confrimationalert;
    
    IBOutlet UIScrollView *scrollEvent;
    
    // i Ad 
    ADBannerView *adView;
    BOOL bannerIsVisible;
    
    
}

@property (nonatomic,retain) IBOutlet UIView     * titleview;
@property (nonatomic,retain) NSString * EventTitle;
@property (nonatomic,retain) NSString * EventStart;
@property (nonatomic,retain) NSString * EventEnd;
@property (nonatomic,retain) NSString * EventId;
@property (nonatomic,retain) NSString * placename;
@property (nonatomic,assign) BOOL bannerIsVisible;


- (IBAction) btn_checkIn:(id) sender;
- (IBAction) btn_checkOut:(id) sender;
- (void) doCheckIn;
- (void) doCheckOut;
- (void)doconfrimation;
- (void) gotoMatchesView;
-(void)releaseBannerView;

@end
