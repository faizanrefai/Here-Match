//
//  OATokenManagerL.h
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 01/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import <Foundation/Foundation.h>

#import "OACallL.h"

@class OATokenManagerL;

@protocol OATokenManagerDelegate

- (BOOL)tokenManager:(OATokenManagerL *)manager failedCall:(OACallL *)call withError:(NSError *)error;
- (BOOL)tokenManager:(OATokenManagerL *)manager failedCall:(OACallL *)call withProblem:(OAProblemL *)problem;

@optional

- (BOOL)tokenManagerNeedsToken:(OATokenManagerL *)manager;

@end

@class OAConsumerL;
@class OATokenL;

@interface OATokenManagerL : NSObject<OACallDelegate> {
	OAConsumerL *consumer;
	OATokenL *acToken;
	OATokenL *reqToken;
	OATokenL *initialToken;
	NSString *authorizedTokenKey;
	NSString *oauthBase;
	NSString *realm;
	NSString *callback;
	NSObject <OATokenManagerDelegate> *delegate;
	NSMutableArray *calls;
	NSMutableArray *selectors;
	NSMutableDictionary *delegates;
	BOOL isDispatching;
}


- (id)init;

- (id)initWithConsumer:(OAConsumerL *)aConsumer token:(OATokenL *)aToken oauthBase:(const NSString *)base
				 realm:(const NSString *)aRealm callback:(const NSString *)aCallback
			  delegate:(NSObject <OATokenManagerDelegate> *)aDelegate;

- (void)authorizedToken:(const NSString *)key;

- (void)fetchData:(NSString *)aURL finished:(SEL)didFinish;

- (void)fetchData:(NSString *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters
		 finished:(SEL)didFinish;

- (void)fetchData:(NSString *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters
			files:(NSDictionary *)theFiles finished:(SEL)didFinish;

- (void)fetchData:(NSString *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters
			files:(NSDictionary *)theFiles finished:(SEL)didFinish delegate:(NSObject*)aDelegate;

- (void)call:(OACallL *)call failedWithError:(NSError *)error;
- (void)call:(OACallL *)call failedWithProblem:(OAProblemL *)problem;

@end
