

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableViewCell (Extend)  
+ (NSString*)cellID;
+ (NSString*)nibName;
+ (id)loadCell;
+ (id)dequeOrCreateInTable:(UITableView*)tableView;

@end
