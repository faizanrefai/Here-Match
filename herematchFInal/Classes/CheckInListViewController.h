//
//  CheckInListViewController.h
//  HereMatch
//
//  Created by apple  on 9/2/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EventDetailsViewController.h"
#import "PlaceDetailsViewController.h"
#import "AddEventViewController.h"
#import "AddPlaceViewController.h"
#import "LoginViewController.h"
#import "MatchesListCell.h"
#import "UITableViewCell+NIB.h"
#import "iAd/ADBannerView.h"

@interface CheckInListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,ADBannerViewDelegate> {
     UITableView * tableview;
    NSMutableArray * arr_places;
    NSMutableArray * arr_events;
    LoginViewController *loginobj;
    CLLocationManager		*_locationManager;
    
    BOOL isWSCalled;
    
    //iAd
    
   ADBannerView *adView;
    BOOL bannerIsVisible;
    
}
@property (nonatomic, retain)UITableView * tableview;
@property(nonatomic,retain)CLLocationManager    *locationManager;
@property (nonatomic,assign) BOOL bannerIsVisible;
//@property(nonatomic,retain)CLLocation			*location;
- (void)downloadEventsAndPlaces;
- (void) btn_refresh_click;
- (void) reloadTableView;
-(void)hideView;
-(void)HideAlert;
@end
