//
//  ProfileViewController.h
//  HereMatch
//
//  Created by apple  on 9/2/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppConstat.h"
#import "OAuthLoginView.h"
#import "oAuth2TestViewController.h"
//#import "SA_OAuthTwitterEngine.h"
//#import "SA_OAuthTwitterController.h"

#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "iAd/ADBannerView.h"


@interface ProfileViewController : UIViewController <UINavigationControllerDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,SA_OAuthTwitterControllerDelegate,ADBannerViewDelegate,callFacebookremove,callLinkdinremove,callHideTwitter> {
	IBOutlet UIScrollView   *profileScrollView;//
    
	IBOutlet UITextView     * txtBio;
	IBOutlet UITextView     * txtInterests;
	IBOutlet UITextView     * txtAssociations;
    
    IBOutlet UITextField    * txtLocationCity;
	IBOutlet UITextField    * txtLocationState;
    IBOutlet UITextField    * txtindustry;
    
	IBOutlet UITextField    * txtTitle;
    IBOutlet UITextField    * txtFirstName;
	IBOutlet UITextField    * txtLastName;
    
	IBOutlet UITextField    * txtEmail;
	IBOutlet UITextField    * txtHeadLine;
	IBOutlet UITextField    * txtPhoneNo1;
    IBOutlet UITextField    * txtPhoneNo2;
    IBOutlet UITextField    * txtPhoneNo3;
	IBOutlet UITextField    * txtURL;
	IBOutlet UITextField    * txtCompany;
	IBOutlet UITextField    * txtEduSchool;
	IBOutlet UITextField    * txtEduGraduationYear;
	IBOutlet UITextField    * txtEduMajor;
	IBOutlet UITextField    * txtHomeTownCity;
	IBOutlet UITextField    * txtHomeTownState;
	IBOutlet UITextField    * txtIndustryInterested1;
	IBOutlet UITextField    * txtIndustryInterested2;
	IBOutlet UITextField    * txtIndustryInterested3;
	
	IBOutlet UIButton       *btnIndustry;
	IBOutlet UIButton       *btnIndustryInterested1;
	IBOutlet UIButton       *btnIndustryInterested2;
	IBOutlet UIButton       *btnIndustryInterested3;
    
    IBOutlet UIButton       * profileimage;
    
    IBOutlet UIButton *btnLocation;
    IBOutlet UIButton *btnHomeTown;
    
    int phonecheck;
    
	BOOL phoneTagOrNot;
    
    //SA_OAuthTwitterEngine *_engine;
    
	CGFloat animatedDistance;
	NSMutableDictionary           *dictLoginUserdetail;
	
	UIPickerView * PickerView;
	NSMutableArray *arrIndustryCategoryList;
	NSString *txtIndustryTag;
	NSString *txtIndustry1Tag;
	NSString *txtIndustry2Tag;
	NSString *txtIndustry3Tag;
	
	UIActionSheet *actionsheet;
	
	NSMutableArray *arrYears;
	NSMutableArray *arrStates;
	NSInteger btnTag;
	NSInteger selectedStateLS;
	NSInteger selectedStateHS;
	NSInteger selectedYear;
	NSInteger selectedStateLSTmp;
	NSInteger selectedStateHSTmp;
	NSInteger selectedYearTmp;
	
	NSInteger imgGetTag;
	
	NSInteger selectedRowInd;
	NSInteger selectedRowInd1;
	NSInteger selectedRowInd2;
	NSInteger selectedRowInd3;
	NSInteger selectedRowIndTmp;
	
	UIButton *doneButton;
	NSInteger tagPhoto;
    
    SA_OAuthTwitterEngine *_engine;
    
    // i Ad 
    ADBannerView *adView;
    BOOL bannerIsVisible;
    
    IBOutlet UIButton *btnAddFacebook;
    IBOutlet UIButton *btnAddTwitter;
    IBOutlet UIButton *btnAddLinkdin;
    
    IBOutlet UIButton *btnDisconnectFB;
    IBOutlet UIButton *btnDisconnectTw;
    IBOutlet UIButton *btnDisconnectLd;
   
}
@property (nonatomic,retain) IBOutlet UIScrollView  *profileScrollView;
@property (nonatomic, retain) OAuthLoginView *oAuthLoginView;
@property (nonatomic, retain) oAuth2TestViewController *oAuth2FBLoginView;
@property (nonatomic,assign) BOOL bannerIsVisible;


- (void)doStartLoading;
-(void)viewLoginUserData;
-(IBAction)clickSaveChanges;
-(void)doSaveChaged;
-(IBAction)ShowPikerView:(id) sender;
-(IBAction)clickGetImageFromUIPicker;
-(void)btnLogout_Clicked;
-(IBAction)clickGetStates:(id)sender;
-(IBAction)clickGetYear:(id)sender;


-(IBAction)twitter_Click:(id)sender;
-(IBAction)FaceBook_Click:(id)sender;
-(IBAction)Linkdn_Click:(id)sender;

-(void)clearViewForReLoad;
- (void) resignkeyboard;
-(void)releaseBannerView;

-(IBAction)btnDisconnect_Facebook:(id)sender;
-(IBAction)btnDisconnect_twitter:(id)sender;
-(IBAction)btnDisconnect_Linkdin:(id)sender;

@end
