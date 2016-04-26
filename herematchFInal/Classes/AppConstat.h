//
//  AppConstat.h
//  FM Host
//
//  Created by Surya on 12/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



//#define kWebServiceUrl @"http://myabilita.com/ws_herematch/"
#define kWebServiceUrl @"http://herematch.com:3000/ws_herematch/"


#define kUserImageWSURl @"http://s3.amazonaws.com/tap-production/userphoto/thumbnail_large/"
#define kEventImageWSURl @"http://myabilita.com/ws_herematch/event_images/"
#define kLocationErrormsg @"Location Services must be turned on herematch to function correctly."

//#define kWebServiceUrl @"http://www.openxcellaus.info/herematch/"
// UIAlertView methods

//alert with only message
#define DisplayAlert(msg) { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; [alertView autorelease];}
//alert with message and title
#define DisplayAlertWithTitle(msg,title){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; [alertView autorelease];}
//alert with only localized message
#define DisplayLocalizedAlert(msg){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(msg,@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; [alertView autorelease];}
//alert with localized message and title
#define DisplayLocalizedAlertWithTitle(msg,title){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title,@"") message:NSLocalizedString(msg,@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; [alertView autorelease];}





