//
//  OAHMAC_SHA1SignatureProvider.h
//  HereMatch
//
//  Created by openxcell123 technolabs on 12/10/11.
//  Copyright (c) 2011 ndkfn;l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAHMAC_SHA1SignatureProvider : NSObject


- (NSString *)signClearText:(NSString *)text withSecret:(NSString *)secret;
- (NSString *)name;
@end
