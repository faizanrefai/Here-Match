//
//  OAProblemL.h
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 03/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import <Foundation/Foundation.h>

enum {
	kOAProblemSignatureMethodRejected = 0,
	kOAProblemParameterAbsent,
	kOAProblemVersionRejected,
	kOAProblemConsumerKeyUnknown,
	kOAProblemTokenRejected,
	kOAProblemSignatureInvalid,
	kOAProblemNonceUsed,
	kOAProblemTimestampRefused,
	kOAProblemTokenExpired,
	kOAProblemTokenNotRenewable
};

@interface OAProblemL : NSObject {
	const NSString *problem;
}

@property (readonly) const NSString *problem;

- (id)initWithProblem:(const NSString *)aProblem;
- (id)initWithResponseBody:(const NSString *)response;

- (BOOL)isEqualToProblem:(OAProblemL *)aProblem;
- (BOOL)isEqualToString:(const NSString *)aProblem;
- (BOOL)isEqualTo:(id)aProblem;
- (int)code;

+ (OAProblemL *)problemWithResponseBody:(const NSString *)response;

+ (const NSArray *)validProblems;

+ (OAProblemL *)SignatureMethodRejected;
+ (OAProblemL *)ParameterAbsent;
+ (OAProblemL *)VersionRejected;
+ (OAProblemL *)ConsumerKeyUnknown;
+ (OAProblemL *)TokenRejected;
+ (OAProblemL *)SignatureInvalid;
+ (OAProblemL *)NonceUsed;
+ (OAProblemL *)TimestampRefused;
+ (OAProblemL *)TokenExpired;
+ (OAProblemL *)TokenNotRenewable;

@end
