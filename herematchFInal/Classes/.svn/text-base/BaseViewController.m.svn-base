    //
//  BaseViewController.m
//  GPSDatingConnection
//
//  Created by Ankita on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"


@implementation BaseViewController

@synthesize backBtn;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    //UIImage *img = [UIImage imageNamed:@"BG.png"];
	//[imgBackground setImage:img];
    
    //self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)setTitleForView:(NSString *)str{
    UILabel  *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 150, 30)];
    
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor blackColor]];
    lbl.shadowColor = [UIColor whiteColor];
	lbl.shadowOffset = CGSizeMake(0.0, 1.0);
    [lbl setTextAlignment:UITextAlignmentCenter];
    [lbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [lbl setText:str];
    
    self.navigationItem.titleView=lbl;
    
    [lbl release];
    
}

-(void)setCustomViewWithTitle:(NSString *)navTitle{
    [self setTitleForView:navTitle];
//    self.backBtn= [UIButton buttonWithType:UIButtonTypeCustom];
//    self.backBtn.frame =CGRectMake(0, 7, 49, 29);
//    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    
//    self.navigationItem.leftBarButtonItem = self.navigationController.navigationItem;
//    [self.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    
    //[self setLogoutButton];
}
-(void)setLogoutButton{
    UIBarButtonItem * btnlogout = [[UIBarButtonItem alloc] initWithTitle:@"LogOut" style:UIBarButtonItemStyleBordered target:self action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = btnlogout;
    [btnlogout release];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];   
}


-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)logout:(id)sender{
    
     [[AppDelegate sharedInstance].tabBarController.view removeFromSuperview];
}
- (void)dealloc {
    
    [backBtn release];
    //[imgBackground release];
    [super dealloc];
}


@end
