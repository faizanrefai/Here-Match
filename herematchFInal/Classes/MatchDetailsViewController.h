//
//  MatchDetailsViewController.h
//  HereMatch
//
//  Created by Gulshan Bhatia on 9/3/11.
//  Copyright 2011 ndkfn;l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
//#import <MessageUI/MFMailComposeViewController.h>
#import "iAd/ADBannerView.h"

@interface MatchDetailsViewController : UIViewController <MFMessageComposeViewControllerDelegate , MFMailComposeViewControllerDelegate , UINavigationControllerDelegate,ADBannerViewDelegate> 
{
	IBOutlet UIScrollView   *userDetailScrollView;
	MFMailComposeViewController *mailViewController;
	
    IBOutlet UIView * titleview;
    
	IBOutlet UITextView * txtBio;
    
    IBOutlet UITextView * txtmatchesreson;
	IBOutlet UITextView * txtInterests;
    IBOutlet UITextView * txtAssociations;
    
	IBOutlet UILabel *lblFirstName;
	IBOutlet UILabel *lblLastName;
    IBOutlet UILabel *lblHeadline;
	IBOutlet UILabel *lblCompany;
	IBOutlet UILabel *lblLocationCity;
    IBOutlet UILabel *lblLocationState;
	IBOutlet UILabel *lblIndustry;
	IBOutlet UILabel *lblIndustry1;
    IBOutlet UILabel *lblIndustry2;
	IBOutlet UILabel *lblIndustry3;
    IBOutlet UILabel *lblURL;
 	IBOutlet UILabel *lblEduSchool;
	IBOutlet UILabel *lblEduGraduationYear;
    IBOutlet UILabel *lblEduMajor;
	IBOutlet UILabel *lblHTCity;
	IBOutlet UILabel *lblHTState;
    
  	IBOutlet UITextView *txtdetails;
	
    IBOutlet UIImageView *imgPerson;
    
    
	
	IBOutlet UIButton *btnCall;
	IBOutlet UIButton *btnText;
	IBOutlet UIButton *btnEmail;
	
    IBOutlet UILabel *lblbio;
    IBOutlet UILabel *lblmatchreson;
    IBOutlet UIImageView *imgmatchreson;
    IBOutlet UIImageView *imgbio;
    
    
	NSInteger idUser;
	NSMutableDictionary *dictLoginUserdetail;
	NSString *strEmailID;
	NSString *strCallNo;
    
    //i ad
    ADBannerView *adView;
    BOOL bannerIsVisible;
    
}
@property (nonatomic,assign) NSInteger idUser;
@property (nonatomic,assign) BOOL bannerIsVisible;

//@property (nonatomic,retain) NSString *strCallNo;
-(void)doStartLoading;
-(void)viewLoginUserData;
-(IBAction)btnCall_Click:(id)sender;
-(IBAction)btnSms_Click:(id)sender;
-(IBAction)btnEmail_Click:(id)sender;
- (NSString *)removeNull:(NSString *)str;
-(void)releaseBannerView;
@end

