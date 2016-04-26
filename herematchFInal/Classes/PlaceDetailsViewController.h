//
//  PlaceDetailsViewController.h
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/3/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "AppConstat.h"
#import "EventDetailsViewController.h"
#import "MatchesListCell.h"
#import "UITableViewCell+NIB.h"
#import "iAd/ADBannerView.h"

@interface PlaceDetailsViewController : UIViewController <UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,ADBannerViewDelegate> {
    IBOutlet UIView * titleview;
    IBOutlet UITableView * table;
    NSMutableArray * arr_events;
    
    IBOutlet UILabel *lblPlaceTitle;
    IBOutlet UILabel *lblPlaceAdd;
    IBOutlet UILabel *lblPlaceCity;
    IBOutlet UILabel *lblMsg;
    
    IBOutlet UIButton  * btnCheckin;
    IBOutlet UIButton  * btnCheckOut;
    
    NSString * PlaceTitle;
    NSString * PlaceAdd;
    NSString * PlaceCity;
    
    NSString * placeid;
    
     UIAlertView *confrimationalert;
    // i Ad 
    ADBannerView *adView;
    BOOL bannerIsVisible;
    
    IBOutlet UIScrollView *scrollPlace;
}
@property (nonatomic,retain) IBOutlet UIView     * titleview;
@property (nonatomic, retain)IBOutlet UITableView * table;
@property (nonatomic, retain) NSString * placeid;
@property (nonatomic, retain) NSString * PlaceTitle;
@property (nonatomic, retain) NSString * PlaceAdd;
@property (nonatomic, retain) NSString * PlaceCity;
@property (nonatomic,assign) BOOL bannerIsVisible;

- (void)downloadEvents;
- (IBAction) btn_checkIn:(id) sender;
- (IBAction) btn_checkOut:(id) sender;
- (void) doCheckIn;
- (void) doCheckOut;
- (void) gotoMatchesView;
- (void)doconfrimation;
-(void)releaseBannerView;
@end
