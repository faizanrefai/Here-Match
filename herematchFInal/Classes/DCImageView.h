//
//  DCImageView.h
//  asyTblDemo
//
//  Created by digicorp on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DCImageView : UIView {
	NSString *strURL;
	NSMutableDictionary *dRef;
	NSIndexPath *ip;
	UITableView *tableRef;	
	NSMutableData *myWebData;
	
	
}
@property(nonatomic,retain) NSMutableData *myWebData;
@property(nonatomic,retain) NSString *strURL;
@property(nonatomic,retain) NSMutableDictionary *dRef;
@property(nonatomic,retain) NSIndexPath *ip;
@property(nonatomic,assign) UITableView *tableRef;



+(void)loadURLImage:(NSString*)urlStringValue dictionaryRef:(NSMutableDictionary*)dRef indexPath:(NSIndexPath*)indexPath tableViewRef:(UITableView*)tableViewRef;

@end






