//
//  LoginViewController.h
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/6/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import "AppConstat.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface LoginViewController : UIViewController <CLLocationManagerDelegate,UITextFieldDelegate>{
    UITextField * txtemail;
    UITextField * txtpassword;
    CLLocationManager		*_locationManager;
}
@property (nonatomic, retain) IBOutlet UITextField * txtemail;
@property (nonatomic, retain) IBOutlet UITextField * txtpassword;
@property(nonatomic,retain)CLLocationManager    *locationManager;

- (IBAction) btnLogin_Click;
- (void)doLogin;
- (IBAction) btnSignup_Click;
- (void)UpdateUserLocation;
@end
