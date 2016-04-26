//
//  AddPlaceViewController.h
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/6/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import "iAd/ADBannerView.h"

@interface AddPlaceViewController : UIViewController <UIAlertViewDelegate,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UITextFieldDelegate,ADBannerViewDelegate> {
    IBOutlet UILabel     * lblcategory;
    IBOutlet UITextField * txtplacename;
    IBOutlet UITextField * txtPlaceAdd;
    IBOutlet UITextField * txtplaceCity;
    IBOutlet UITextField * txtplaceState;
    IBOutlet UITextField * txtplaceZip;
    IBOutlet UITextField * txtplacePhone;
    IBOutlet UITextField * txtplaceUrl;
    IBOutlet UIScrollView *scrollPlace;

    NSMutableArray * arr_category;
    UIPickerView * PickerView;
    
    CLLocationManager		*_locationManager;
    
    int checkedplace;
    UIAlertView *confrimationalert;
    BOOL check;
    
    // i Ad 
    ADBannerView *adView;
    BOOL bannerIsVisible;
    
}

@property(nonatomic,retain)CLLocationManager    *locationManager;
@property (nonatomic,assign) BOOL bannerIsVisible;

- (IBAction) ShowPikerView:(id) sender;
- (IBAction) btnAddPlace_Click:(id) sender;
- (void)doAddPlace;
- (void)doconfrimation;
- (void)downloadCategories;
-(void)releaseBannerView;

@end
