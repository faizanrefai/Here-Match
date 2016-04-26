
#include "UITableViewCell+NIB.h"


@implementation UITableViewCell (Extend)

+ (id)loadCell {
	NSArray* objects = [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self options:nil];
	
	for (id object in objects) {
		if ([object isKindOfClass:self]) {
			UITableViewCell *cell = object;
			[cell setValue:[self cellID] forKey:@"_reuseIdentifier"];	
			return cell;
			NSLog(@"hello...");
		}
	}	
	[NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one TableViewCell, and its class must be '%@'", [self nibName], [self class]];	
	return nil;
	NSLog(@"hi...");
}


+ (NSString*)cellID { return [self description]; }


+ (NSString*)nibName { return [self description]; }


+ (id)dequeOrCreateInTable:(UITableView*)tableView {
	   UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[self cellID]];
		return cell ? cell : [self loadCell];
	NSLog(@"hi...");
	//return [self loadCell];
}
@end
