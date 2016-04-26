//
//  AddEventViewController.h
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/6/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventDatePickerViewController.h"
#import "AppDelegate.h"
#import "AppConstat.h"
#import "AddPlaceViewController.h"
#import <MapKit/MapKit.h>
#import "iAd/ADBannerView.h"


@interface AddEventViewController : UIViewController<CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UITextFieldDelegate,ADBannerViewDelegate> {
    IBOutlet UITextField * txteventname;
    IBOutlet UITextField * txturl;
    IBOutlet UITextField * txtemail;
    IBOutlet UITextField * txtphone;
    IBOutlet UITextField * txtdescription;
    
    IBOutlet UILabel * lblplace;
    IBOutlet UILabel * lblcategory;
    IBOutlet UILabel * lblindustry;
    
    IBOutlet UILabel * lblStartDate;
    IBOutlet UILabel * lblEndDate;
    
    NSMutableArray * arr_category;
    NSMutableArray * arr_place;
    NSMutableArray * arr_industry;
    UIDatePicker * dtPicker;
    
    NSDate * startdate;
    NSDate * enddate;
    
    IBOutlet UIScrollView * scrollView;
    
    UIPickerView * PickerView;
    NSString * placeid;
    NSString * industryid;
    
    CLLocationManager		*_locationManager;
    
    
    IBOutlet UIButton * imgbutton;
	
	UIActionSheet *actionsheet;
    int flag;
    
    int checkedplace;
    int checkedcategory;
    int checkedindustry;
	
	int selectBtnTag;
    
    AddEventDatePickerViewController *  obj;
    
     BOOL isWSCalled;
     BOOL isFirstTime;
    UIAlertView *confrimationalert;
    BOOL checkFlag;
  
    
    // i Ad 
    ADBannerView *adView;
    BOOL bannerIsVisible;
    
}

@property(nonatomic,retain)CLLocationManager    *locationManager;
@property(nonatomic,retain)IBOutlet UILabel * lblStartDate;
@property(nonatomic,retain)IBOutlet UILabel * lblEndDate;
@property(nonatomic,retain)NSDate * startdate;
@property(nonatomic,retain)NSDate * enddate;
@property (nonatomic,assign) BOOL bannerIsVisible;

- (IBAction) btnStartEnd_Click:(id) sender;
- (IBAction) ShowPikerView:(id) sender;
- (IBAction) btnAddEvent_Click:(id) sender;
- (IBAction) btnimgbutton_Click:(id) sender;
- (IBAction) ShowDatePikerView:(id) sender;

- (void)downloadIndustriesAndPlaces;
//-(void)doSaveChaged;
- (void)doconfrimation;
-(void)callAgain;
-(void)releaseBannerView;

@end
