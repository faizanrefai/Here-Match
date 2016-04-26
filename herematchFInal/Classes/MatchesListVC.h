//
//  MatchesListVC.h
//  HereMatch
//
//  Created by apple on 9/28/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h> 
#import "DCImageView.h"
#import "AppDelegate.h"
#import "iAd/ADBannerView.h"

@interface MatchesListVC : UIViewController <CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,ADBannerViewDelegate>{
	IBOutlet UITableView *myTable;
	NSMutableArray *matchesArray;
	NSMutableArray *allProfilesArray;
		
	CLLocationManager *_locationManager;
	NSTimer *timeR;
      BOOL isWSCalled;
   
    // i Ad 
    ADBannerView *adView;
    BOOL bannerIsVisible;
}
@property(nonatomic,retain)CLLocationManager    *locationManager;
@property(nonatomic,retain) IBOutlet UITableView *myTable;
@property (nonatomic,assign) BOOL bannerIsVisible;

- (void)downloadFriendsList;
- (void) btn_refresh_click;
- (void)downloadFriendsList;
- (void) reloadtable;
- (NSString *)removeNull:(NSString *)str;
-(void)releaseBannerView;
@end
