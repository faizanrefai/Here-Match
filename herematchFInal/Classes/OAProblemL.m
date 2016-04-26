//
//  OAProblemL.m
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 03/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import "OAProblemL.h"

const NSString *signature_method_rejected = @"signature_method_rejected";
const NSString *parameter_absent = @"parameter_absent";
const NSString *version_rejected = @"version_rejected";
const NSString *consumer_key_unknown = @"consumer_key_unknown";
const NSString *token_rejected = @"token_rejected";
const NSString *signature_invalid = @"signature_invalid";
const NSString *nonce_used = @"nonce_used";
const NSString *timestamp_refused = @"timestamp_refused";
const NSString *token_expired = @"token_expired";
const NSString *token_not_renewable = @"token_not_renewable";

@implementation OAProblemL

@synthesize problem;

- (id)initWithPointer:(const NSString *) aPointer
{
	[super init];
	problem = aPointer;
	return self;
}

- (id)initWithProblem:(const NSString *) aProblem
{
	NSUInteger idx = [[OAProblemL validProblems] indexOfObject:aProblem];
	if (idx == NSNotFound) {
		return nil;
	}
	
	return [self initWithPointer: [[OAProblemL validProblems] objectAtIndex:idx]];
}
	
- (id)initWithResponseBody:(const NSString *) response
{
	NSArray *fields = [response componentsSeparatedByString:@"&"];
	for (NSString *field in fields) {
		if ([field hasPrefix:@"oauth_problem="]) {
			NSString *value = [[field componentsSeparatedByString:@"="] objectAtIndex:1];
			return [self initWithProblem:value];
		}
	}
	
	return nil;
}

+ (OAProblemL *)problemWithResponseBody:(const NSString *) response
{
	return [[[OAProblemL alloc] initWithResponseBody:response] autorelease];
}

+ (const NSArray *)validProblems
{
	static NSArray *array;
	if (!array) {
		array = [[NSArray alloc] initWithObjects:signature_method_rejected,
										parameter_absent,
										version_rejected,
										consumer_key_unknown,
										token_rejected,
										signature_invalid,
										nonce_used,
										timestamp_refused,
										token_expired,
										token_not_renewable,
										nil];
	}
	
	return array;
}

- (BOOL)isEqualToProblem:(OAProblemL *) aProblem
{
	return [problem isEqualToString:(NSString *)aProblem->problem];
}

- (BOOL)isEqualToString:(const NSString *) aProblem
{
	return [problem isEqualToString:(NSString *)aProblem];
}

- (BOOL)isEqualTo:(id) aProblem
{
	if ([aProblem isKindOfClass:[NSString class]]) {
		return [self isEqualToString:aProblem];
	}
		
	if ([aProblem isKindOfClass:[OAProblemL class]]) {
		return [self isEqualToProblem:aProblem];
	}
	
	return NO;
}

- (int)code {
	return [[[self class] validProblems] indexOfObject:problem];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"OAuth Problem: %@", (NSString *)problem];
}

#pragma mark class_methods

+ (OAProblemL *)SignatureMethodRejected
{
	return [[[OAProblemL alloc] initWithPointer:signature_method_rejected] autorelease];
}

+ (OAProblemL *)ParameterAbsent
{
	return [[[OAProblemL alloc] initWithPointer:parameter_absent] autorelease];
}

+ (OAProblemL *)VersionRejected
{
	return [[[OAProblemL alloc] initWithPointer:version_rejected] autorelease];
}

+ (OAProblemL *)ConsumerKeyUnknown
{
	return [[[OAProblemL alloc] initWithPointer:consumer_key_unknown] autorelease];
}

+ (OAProblemL *)TokenRejected
{
	return [[[OAProblemL alloc] initWithPointer:token_rejected] autorelease];
}

+ (OAProblemL *)SignatureInvalid
{
	return [[[OAProblemL alloc] initWithPointer:signature_invalid] autorelease];
}

+ (OAProblemL *)NonceUsed
{
	return [[[OAProblemL alloc] initWithPointer:nonce_used] autorelease];
}

+ (OAProblemL *)TimestampRefused
{
	return [[[OAProblemL alloc] initWithPointer:timestamp_refused] autorelease];
}

+ (OAProblemL *)TokenExpired
{
	return [[[OAProblemL alloc] initWithPointer:token_expired] autorelease];
}

+ (OAProblemL *)TokenNotRenewable
{
	return [[[OAProblemL alloc] initWithPointer:token_not_renewable] autorelease];
}
					  
@end
