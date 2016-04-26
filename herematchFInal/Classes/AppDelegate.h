//
//  AppDelegate.h
//  HereMatch
//
//  Created by apple  on 9/2/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GdataParser.h"
#import "LoginViewController.h"
#import "ActivityAlertView-old.h"
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "AlertHandler.h"

@interface UINavigationBar(CustomImage)
    

@end

@interface AppDelegate : NSObject <CLLocationManagerDelegate,UIApplicationDelegate, UITabBarControllerDelegate> {
    //ActivityAlertView * activityAlert;
    BOOL ismail;
    
    int UserId;
    NSString  * industry;
    NSString  * groups;
    NSString  * interests;
    NSString  * school;
    NSString  * hometown_city;
    NSString  * hometown_state;

    
    
    //For Display Date in dd:MM:yyyy hh:mm a format
    NSString * AddEventStartDate;
    NSString * AddEventEndDate;
    
    //For send  Date in ws in  yyyy-mm-dd hh:mm a format    
    NSString * AddEventStartDateWsFormatted;
    NSString * AddEventEndDateWsFormatted;
    
    NSString * DeviceToken;
    
    CLLocationManager		*_locationManager;
    CLLocation				*location;
    int start;
    
    BOOL isFromAddplace;
    BOOL isFromAddEvent;
    
    NSMutableArray * arrMatchResons;
    BOOL checkTWLD;
    
  
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic) int UserId;
@property (nonatomic) BOOL ismail;
@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) NSString * groups;
@property (nonatomic, retain) NSString * interests;
@property (nonatomic, retain) NSString * school;
@property (nonatomic, retain) NSString * hometown_city;
@property (nonatomic, retain) NSString * hometown_state;




@property (nonatomic, retain) NSString * AddEventStartDate;
@property (nonatomic, retain) NSString * AddEventEndDate;

@property (nonatomic, retain) NSString * AddEventStartDateWsFormatted;
@property (nonatomic, retain) NSString * AddEventEndDateWsFormatted;

@property(nonatomic,retain)CLLocationManager    *locationManager;
@property(nonatomic,retain)CLLocation			*location;

@property(nonatomic,retain)NSString * DeviceToken;

@property (nonatomic) BOOL isFromAddplace;
@property (nonatomic) BOOL isFromAddEvent;
@property (nonatomic, retain) NSMutableArray * arrMatchResons;
@property(nonatomic,assign)BOOL checkTWLD;

-(void)GDATA; 

+(AppDelegate *)sharedInstance;
- (BOOL) validateEmail: (NSString *) Email;

- (BOOL) isconnectedToNetwork:(NSString*)str;
- (void)showLoadingView;
- (void)doshowLoadingView;

- (void)hideLoadingView;
- (void)dohideLoadingView;
//- (void) myExceptionHandler:(NSException *)exception;

@end
