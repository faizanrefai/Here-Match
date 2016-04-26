//
//  SignUpViewController.h
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/d6/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"
#import "AppDelegate.h"

@interface SignUpViewController : UIViewController<UIWebViewDelegate,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UITextViewDelegate> {
    IBOutlet UITableView * tableview;
    
  
    
    UILabel *lblFirstName;
    UITextField *txtFirstName;
    
    UILabel *lblLastName;
    UITextField *txtLastName;
    
    UILabel *lblUsername;
    UITextField *txtUsername;
    
    UILabel *lblPassword;
    UITextField *txtPassword;
    
    UILabel *lblEmailAddress;
    UITextField *txtEmailAddress ;
    
    
    
    UILabel *lblConfirmPassword;
    UITextField *txtConfirmPassword;
    
    UITextView *txtAcceptTerms;
    BOOL isAcceptTerms;
    
    UITextView *txtSubscribeAnouncements;
    BOOL isSubscribeAnouncements;
    
    UITextView *txtSubscribeEvents;
    BOOL isSubscribeEvents;
    
    UIButton *btnAcceptTerms;
    UIButton *btnSubscribeAnouncements;
    UIButton *btnSubscribeEvents;
    IBOutlet UIView *viewTermsUse;
	IBOutlet UIWebView *webViewTU;
    
    IBOutlet UINavigationBar * navigationbar;
    //IBOutlet UIActivityIndicatorView *  activityindicator;
    
    UIBarButtonItem * btnClose;
}
@property(nonatomic, retain) IBOutlet UITableView * tableview;
@property(nonatomic, retain) UIButton * btnAcceptTerms;
@property(nonatomic, retain) UIButton * btnSubscribeAnouncements;
@property(nonatomic, retain) UIButton * btnSubscribeEvents;

@property (nonatomic, retain) UIWebView *webViewTU;

-(IBAction)btnSignup_Click;
- (void)doSignUp;
- (void) btnCheckBoxClick:(id)sender;
- (IBAction) cancelRegistration;

//- (void) scrollTableToTextField:(NSInteger)tag;
-(void)createTableCellControls;

-(UIButton *)createChkBoxButton;
-(UITextView *)createTextView:(int)width:(NSString *)str;
-(UITextField *)createTextField:(int)left:(int)width:(NSString *) placeholder;
-(UILabel *)createLabel:(int)width:(NSString *)str :(int)nooflines;

-(IBAction)clickTermsUse;
-(IBAction)clickPrivacyPlicy;
-(IBAction)clickCloseTermsUseView;
-(NSString*)generateString;
-(BOOL)check:(NSString *)password;
-(BOOL)checkLetter:(NSString *)password;
@end
