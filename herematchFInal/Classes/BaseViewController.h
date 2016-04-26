//
//  BaseViewController.h
//  GPSDatingConnection
//
//  Created by Ankita on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@interface BaseViewController : UIViewController {
    IBOutlet UIImageView	* imgBackground;
    UIButton *backBtn;
}
@property(nonatomic,retain)UIButton   *backBtn;

-(void)setTitleForView:(NSString *)str;
-(void)setCustomViewWithTitle:(NSString *)navTitle;
-(void)setLogoutButton;

@end
