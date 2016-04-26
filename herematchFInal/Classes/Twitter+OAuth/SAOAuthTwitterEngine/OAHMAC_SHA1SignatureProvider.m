//
//  OAHMAC_SHA1SignatureProvider.m
//  HereMatch
//
//  Created by openxcell123 technolabs on 12/10/11.
//  Copyright (c) 2011 ndkfn;l. All rights reserved.
//

#import "OAHMAC_SHA1SignatureProvider.h"

#import <CommonCrypto/CommonHMAC.h>

#include "Base64Transcoder.h"
@implementation OAHMAC_SHA1SignatureProvider


- (NSString *)name
{
    return @"HMAC-SHA1";
}

- (NSString *)signClearText:(NSString *)text withSecret:(NSString *)secret
{
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    
    CCHmacContext hmacContext;
    CCHmacInit(&hmacContext, kCCHmacAlgSHA1, secretData.bytes, secretData.length);
    CCHmacUpdate(&hmacContext, clearTextData.bytes, clearTextData.length);
    CCHmacFinal(&hmacContext, digest);
    
    //Base64 Encoding
    
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(digest, CC_SHA1_DIGEST_LENGTH, base64Result, &theResultLength);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    
    return [base64EncodedResult autorelease];
}


@end
