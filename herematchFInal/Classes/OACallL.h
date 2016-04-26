//
//  OACallL.h
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 04/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import <Foundation/Foundation.h>

@class OAProblemL;
@class OACallL;

@protocol OACallDelegate

- (void)call:(OACallL *)call failedWithError:(NSError *)error;
- (void)call:(OACallL *)call failedWithProblem:(OAProblemL *)problem;

@end

@class OAConsumeLr;
@class OATokenL;
@class OADataFetcherL;
@class OAMutableURLRequestL;
@class OAServiceTicketL;

@interface OACallL : NSObject {
	NSURL *url;
	NSString *method;
	NSArray *parameters;
	NSDictionary *files;
	NSObject <OACallDelegate> *delegate;
	SEL finishedSelector;
	OADataFetcherL *fetcher;
	OAMutableURLRequestL *request;
	OAServiceTicketL *ticket;
}

@property(readonly) NSURL *url;
@property(readonly) NSString *method;
@property(readonly) NSArray *parameters;
@property(readonly) NSDictionary *files;
@property(nonatomic, retain) OAServiceTicketL *ticket;

- (id)init;
- (id)initWithURL:(NSURL *)aURL;
- (id)initWithURL:(NSURL *)aURL method:(NSString *)aMethod;
- (id)initWithURL:(NSURL *)aURL parameters:(NSArray *)theParameters;
- (id)initWithURL:(NSURL *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters;
- (id)initWithURL:(NSURL *)aURL parameters:(NSArray *)theParameters files:(NSDictionary*)theFiles;

- (id)initWithURL:(NSURL *)aURL
		   method:(NSString *)aMethod
	   parameters:(NSArray *)theParameters
			files:(NSDictionary*)theFiles;

- (void)perform:(OAConsumerL *)consumer
		  token:(OATokenL *)token
		  realm:(NSString *)realm
	   delegate:(NSObject <OACallDelegate> *)aDelegate
	  didFinish:(SEL)finished;

@end
