//
//  SettingsViewController.h
//  HereMatch
//
//  Created by apple123 on 10/8/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController <UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UIView *viewTermsUse;
	IBOutlet UIWebView *webViewTU;
    
    IBOutlet UINavigationBar * navigationbar;
    UIBarButtonItem * btncancel;
    
}
@property (nonatomic,retain) UIBarButtonItem * btncancel;
-(IBAction)clickCloseTermsUseView;
@end
