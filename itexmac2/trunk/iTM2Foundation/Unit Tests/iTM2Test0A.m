//
//  iTM2TestA
//  iTM2Foundation
//
//  Created by Jérôme Laurens on 16/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "iTeXMac2.h"
#import "iTM2BundleKit.h"
#import "iTM2DistributedObjectKit.h"
#import "iTM2FileManagerKit.h"
#import "iTM2Implementation.h"
#import "iTM2InstallationKit.h"
#import "iTM2Invocation.h"
#import "iTM2NotificationKit.h"
#import "iTM2ObjectServer.h"
#import "iTM2PathUtilities.h"
#import "iTM2Runtime.h"
#import "iTM2TreeKit.h"
#import "RegexKitLite.h"
#import "ICURegEx.h"
#import "iTM2Test0A.h"

@interface MyParent: NSObject
{
	NSUInteger _tag;
}
@property (assign) NSUInteger tag;
- (NSString *) action1Suffix:(NSUInteger)tag;
- (NSString *) action2Suffix:(NSUInteger)tag;
+ (NSString *) action11Suffix:(NSUInteger)tag;
+ (NSString *) action12Suffix:(NSUInteger)tag;
@end

@interface MySon:MyParent
- (NSString *) action3Suffix:(NSUInteger)tag;
- (NSString *) action4Suffix:(NSUInteger)tag;
+ (NSString *) action13Suffix:(NSUInteger)tag;
+ (NSString *) action14Suffix:(NSUInteger)tag;
@end

@implementation iTM2Test0A
- (void) setUp
{
    // Create data structures here.
}

- (void) tearDown
{
    // Release data structures here.
}
- (void) testCase_iTM2NotificationKit
{
	iTM2StatusField * statusField = [[iTM2StatusField alloc] initWithFrame:NSZeroRect];
	NSString * theStatus1 = @"Something absolutely random: 09697326487587423076230752430";
	NSString * theStatus2 = @"Something absolutely random: 82736450476472076429365002387";
	[[self class] iTM2_postNotificationWithStatus:theStatus1];
	STAssertEqualObjects(theStatus1,[statusField stringValue],@"Notification posted 1",@"");
	[[self class] iTM2_postNotificationWithStatus:theStatus2];
	STAssertEqualObjects(theStatus2,[statusField stringValue],@"Notification posted 2",@"");
	[self iTM2_postNotificationWithStatus:theStatus1];
	STAssertEqualObjects(theStatus1,[statusField stringValue],@"Notification posted 1",@"");
	[self iTM2_postNotificationWithStatus:theStatus2];
	STAssertEqualObjects(theStatus2,[statusField stringValue],@"Notification posted 2",@"");
	[self iTM2_postNotificationWithStatus:@""];
	[[self class] iTM2_postNotificationWithToolTip:theStatus1];
	STAssertEqualObjects(theStatus1,[statusField stringValue],@"Notification posted 1",@"");
	[[self class] iTM2_postNotificationWithToolTip:theStatus2];
	STAssertEqualObjects(theStatus2,[statusField stringValue],@"Notification posted 2",@"");
	[self iTM2_postNotificationWithToolTip:theStatus1];
	STAssertEqualObjects(theStatus1,[statusField stringValue],@"Notification posted 1",@"");
	[self iTM2_postNotificationWithToolTip:theStatus2];
	STAssertEqualObjects(theStatus2,[statusField stringValue],@"Notification posted 2",@"");
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithFloat:1],  iTM2StatusTimeOutKey,
						   nil]];
	[self iTM2_postNotificationWithToolTip:theStatus2];
	//STAssertEqualObjects(theStatus2,[statusField stringValue],@"Notification posted 4",@"");
	//NSRunLoop * CRL = [NSRunLoop currentRunLoop];
	//STAssertNotNil(CRL,@"No run loop");
	//[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
	//[CRL runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
	//STAssertEqualObjects(theStatus1,[statusField stringValue],@"Notification posted 3",@"");
    [statusField release];
	statusField = nil;
}
- (void)testCase_iTM2InvocationKit
{
	MyParent * myObject = [MyParent new];
	NSInvocation * I;
	[[NSInvocation  iTM2_getInvocation:&I withTarget:myObject retainArguments:NO] action1Suffix:10];
	NSPointerArray * selectors = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	[I iTM2_invokeWithSelectors:selectors];
	STAssertEquals(myObject.tag,(NSUInteger)0,@"iTM2InvocationKit test 1: ",nil);
	myObject.tag = 0;
	[selectors addPointer:@selector(action1Suffix:)];
	[I iTM2_invokeWithSelectors:selectors];
	STAssertEquals(myObject.tag,(NSUInteger)10,@"iTM2InvocationKit test 2: ",nil);
	myObject.tag = 0;
	[selectors addPointer:@selector(action2Suffix:)];
	[I iTM2_invokeWithSelectors:selectors];
	STAssertEquals(myObject.tag,(NSUInteger)30,@"iTM2InvocationKit test 3: ",nil);
}
- (void)testCase_iTM2Runtime_instances
{
	NSMutableSet * set1 = [NSMutableSet set];
	NSMutableSet * set2 = [NSMutableSet set];
	NSUInteger i;
	NSMethodSignature * MS = [MyParent instanceMethodSignatureForSelector:@selector(action1Suffix:)];
	NSPointerArray * ans = [iTM2Runtime instanceSelectorsOfClass:[MyParent class] withSuffix:@"Suffix:" signature:MS inherited:NO];
	for(i = 0;i<[ans count];++i) {
		[set1 addObject:NSStringFromSelector((SEL)[ans pointerAtIndex:i])];
	}
	NSPointerArray * selectors = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	[selectors addPointer:@selector(action1Suffix:)];
	[selectors addPointer:@selector(action2Suffix:)];
	for(i = 0;i<[selectors count];++i) {
		[set2 addObject:NSStringFromSelector((SEL)[selectors pointerAtIndex:i])];
	}
	STAssertEqualObjects(set1,set2,@"instance selectors",nil);
	[selectors setCount:0];
	set1 = [NSMutableSet set];
	set2 = [NSMutableSet set];
	ans = [iTM2Runtime instanceSelectorsOfClass:[MySon class] withSuffix:@"Suffix:" signature:MS inherited:NO];
	[selectors addPointer:@selector(action3Suffix:)];
	[selectors addPointer:@selector(action4Suffix:)];
	STAssertEqualObjects(ans,selectors,@"instance selectors",nil);
	ans = [iTM2Runtime instanceSelectorsOfClass:[MySon class] withSuffix:@"Suffix:" signature:MS inherited:YES];
	for(i = 0;i<[ans count];++i) {
		[set1 addObject:NSStringFromSelector((SEL)[ans pointerAtIndex:i])];
	}
	[selectors addPointer:@selector(action1Suffix:)];
	[selectors addPointer:@selector(action2Suffix:)];
	for(i = 0;i<[selectors count];++i) {
		[set2 addObject:NSStringFromSelector((SEL)[selectors pointerAtIndex:i])];
	}
	STAssertEqualObjects(set1,set2,@"instance selectors",nil);
}
- (void)testCase_iTM2Runtime_classes
{
	NSMutableSet * set1 = [NSMutableSet set];
	NSMutableSet * set2 = [NSMutableSet set];
	NSUInteger i;
	NSMethodSignature * MS = [MyParent methodSignatureForSelector:@selector(action1Suffix:)];
	NSPointerArray * ans = [iTM2Runtime classSelectorsOfClass:[MyParent class] withSuffix:@"Suffix:" signature:MS inherited:NO];
	for(i = 0;i<[ans count];++i) {
		[set1 addObject:NSStringFromSelector((SEL)[ans pointerAtIndex:i])];
	}
	NSPointerArray * selectors = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	[selectors addPointer:@selector(action11Suffix:)];
	[selectors addPointer:@selector(action12Suffix:)];
	for(i = 0;i<[selectors count];++i) {
		[set2 addObject:NSStringFromSelector((SEL)[selectors pointerAtIndex:i])];
	}
	STAssertEqualObjects(set1,set2,@"instance selectors",nil);
	[selectors setCount:0];
	set1 = [NSMutableSet set];
	set2 = [NSMutableSet set];
	ans = [iTM2Runtime classSelectorsOfClass:[MySon class] withSuffix:@"Suffix:" signature:MS inherited:NO];
	[selectors addPointer:@selector(action13Suffix:)];
	[selectors addPointer:@selector(action14Suffix:)];
	STAssertEqualObjects(ans,selectors,@"instance selectors",nil);
	ans = [iTM2Runtime classSelectorsOfClass:[MySon class] withSuffix:@"Suffix:" signature:MS inherited:YES];
	for(i = 0;i<[ans count];++i) {
		[set1 addObject:NSStringFromSelector((SEL)[ans pointerAtIndex:i])];
	}
	[selectors addPointer:@selector(action11Suffix:)];
	[selectors addPointer:@selector(action12Suffix:)];
	for(i = 0;i<[selectors count];++i) {
		[set2 addObject:NSStringFromSelector((SEL)[selectors pointerAtIndex:i])];
	}
	STAssertEqualObjects(set1,set2,@"instance selectors",nil);
}
- (void)testCase_iTM2Runtime_swizzle
{
	MyParent * myParent = [MyParent new];
	
	STAssertEqualObjects([myParent action1Suffix:0],@"action1Suffix:=action1Suffix:",@"swizzling 1-a",nil);
	STAssertEqualObjects([myParent action2Suffix:0],@"action2Suffix:=action2Suffix:",@"swizzling 1-b",nil);
	STAssertTrue([iTM2Runtime swizzleInstanceMethodSelector:@selector(action1Suffix:) replacement:@selector(action2Suffix:) forClass:[MyParent class] error:NULL],@"swizzling 1-c",nil);
	STAssertEqualObjects([myParent action1Suffix:0],@"action2Suffix:=action1Suffix:",@"swizzling 1-d",nil);
	STAssertEqualObjects([myParent action2Suffix:0],@"action1Suffix:=action2Suffix:",@"swizzling 1-e",nil);
	STAssertTrue([iTM2Runtime swizzleInstanceMethodSelector:@selector(action2Suffix:) replacement:@selector(action1Suffix:) forClass:[MyParent class] error:NULL],@"swizzling 1-c",nil);
	STAssertEqualObjects([myParent action1Suffix:0],@"action1Suffix:=action1Suffix:",@"swizzling 1-a",nil);
	STAssertEqualObjects([myParent action2Suffix:0],@"action2Suffix:=action2Suffix:",@"swizzling 1-b",nil);

	STAssertEqualObjects([MyParent action11Suffix:0],@"action11Suffix:=action11Suffix:",@"swizzling 2-a",nil);
	STAssertEqualObjects([MyParent action12Suffix:0],@"action12Suffix:=action12Suffix:",@"swizzling 2-b",nil);
	STAssertTrue([iTM2Runtime swizzleClassMethodSelector:@selector(action11Suffix:) replacement:@selector(action12Suffix:) forClass:[MyParent class] error:NULL],@"swizzling 2-c",nil);
	STAssertEqualObjects([MyParent action11Suffix:0],@"action12Suffix:=action11Suffix:",@"swizzling 2-d",nil);
	STAssertEqualObjects([MyParent action12Suffix:0],@"action11Suffix:=action12Suffix:",@"swizzling 2-e",nil);
	STAssertTrue([iTM2Runtime swizzleClassMethodSelector:@selector(action12Suffix:) replacement:@selector(action11Suffix:) forClass:[MyParent class] error:NULL],@"swizzling 2-c",nil);
	STAssertEqualObjects([MyParent action11Suffix:0],@"action11Suffix:=action11Suffix:",@"swizzling 2-a",nil);
	STAssertEqualObjects([MyParent action12Suffix:0],@"action12Suffix:=action12Suffix:",@"swizzling 2-b",nil);

	MySon * mySon = [MySon new];

	STAssertEqualObjects([mySon action1Suffix:0],@"action1Suffix:=action1Suffix:",@"swizzling 3-a",nil);
	STAssertEqualObjects([mySon action3Suffix:0],@"action3Suffix:=action3Suffix:",@"swizzling 3-b",nil);
	STAssertTrue([iTM2Runtime swizzleInstanceMethodSelector:@selector(action1Suffix:) replacement:@selector(action3Suffix:) forClass:[MySon class] error:NULL],@"swizzling 3-c",nil);
	STAssertEqualObjects([mySon action1Suffix:0],@"action3Suffix:=action1Suffix:",@"swizzling 3-d",nil);
	STAssertEqualObjects([myParent action1Suffix:0],@"action1Suffix:=action1Suffix:",@"swizzling 3-d'",nil);
	STAssertEqualObjects([mySon action3Suffix:0],@"action1Suffix:=action3Suffix:",@"swizzling 3-e",nil);
	
	STAssertEqualObjects([MySon action11Suffix:0],@"action11Suffix:=action11Suffix:",@"swizzling 4-a",nil);
	STAssertEqualObjects([MySon action13Suffix:0],@"action13Suffix:=action13Suffix:",@"swizzling 4-b",nil);
	STAssertTrue([iTM2Runtime swizzleClassMethodSelector:@selector(action11Suffix:) replacement:@selector(action13Suffix:) forClass:[MySon class] error:NULL],@"swizzling 4-c",nil);
	STAssertEqualObjects([MySon action11Suffix:0],@"action13Suffix:=action11Suffix:",@"swizzling 4-d",nil);
	STAssertEqualObjects([MyParent action11Suffix:0],@"action11Suffix:=action11Suffix:",@"swizzling 4-d'",nil);
	STAssertEqualObjects([MySon action13Suffix:0],@"action11Suffix:=action13Suffix:",@"swizzling 4-e",nil);
}
- (void) testCase_iTM2CommentedKeyValuePairs
{
	NSString * testString = @"First line\nSecond %  ! iTeXMac2 (  KEY ) :  VALUE1 line\nThird line%  ! iTeXMac2 (  KEY ) :  VaLuE-2\nAnd so on";
	NSLog(@"testString:%@",testString);
	NSError * error = nil;
	ICURegEx * RE = [[ICURegEx alloc] initWithSearchPattern:@"%\\s*?!\\s*?(?i-:itexmac2)\\s*?\\(\\s*?KEY\\s*?\\)\\s*?:\\s*?(\\S+)" options:0 error:&error];
	[RE setInputString:testString range:NSMakeRange(0,[testString length])];
	STAssertTrue([RE nextMatch],@"Missed match 1",nil);
	STAssertEquals([RE numberOfCaptureGroups],1,@"Missed match 2",nil);
	NSString * S = [RE substringOfCaptureGroupAtIndex:1];
	NSLog(@"S:<%@>",S);
	STAssertEqualObjects(S,@"VALUE1",@"Missed match 3",nil);
	NSRange R = [RE rangeOfCaptureGroupAtIndex:0];
	STAssertTrue([RE nextMatchAfterIndex:R.location+1],@"Missed match 11",nil);
	STAssertEquals([RE numberOfCaptureGroups],1,@"Missed match 12",nil);
	S = [RE substringOfCaptureGroupAtIndex:1];
	NSLog(@"S:<%@>",S);
	STAssertEqualObjects(S,@"VaLuE-2",@"Missed match 13",nil);
	[RE release];
	return;
}
- (void) testCase_ICURE_shell
{
	NSString * testString = @"#!/usr/bin/env/lua -h \nSecond line\nThird line\nAnd so on";
	NSLog(@"testString:%@",testString);
	NSError * error = nil;
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:@"^#!\\S*/([^/\\s]+)" options:0 error:&error] autorelease];
	[RE setInputString:testString range:NSMakeRange(0,[testString length])];
	STAssertTrue([RE nextMatch],@"Missed match 1",nil);
	STAssertEquals([RE numberOfCaptureGroups],1,@"Missed match 2",nil);
	NSString * S = [RE substringOfCaptureGroupAtIndex:1];
	NSLog(@"S:<%@>",S);
	STAssertEqualObjects(S,@"lua",@"Missed match 3",nil);
	return;
}
@end

@implementation MyParent
@synthesize tag=_tag;
- (NSString *) action1Suffix:(NSUInteger)tag;
{
	self.tag=self.tag+tag;
	return [NSString stringWithFormat:@"action1Suffix:=%@",NSStringFromSelector(_cmd)];
}
- (NSString *) action2Suffix:(NSUInteger)tag;
{
	self.tag=self.tag+2*tag;
	return [NSString stringWithFormat:@"action2Suffix:=%@",NSStringFromSelector(_cmd)];
}
+ (NSString *) action11Suffix:(NSUInteger)tag;
{
	return [NSString stringWithFormat:@"action11Suffix:=%@",NSStringFromSelector(_cmd)];
}
+ (NSString *) action12Suffix:(NSUInteger)tag;
{
	return [NSString stringWithFormat:@"action12Suffix:=%@",NSStringFromSelector(_cmd)];
}
@end

@implementation MySon
- (NSString *) action3Suffix:(NSUInteger)tag;
{
	self.tag=self.tag+3*tag;
	return [NSString stringWithFormat:@"action3Suffix:=%@",NSStringFromSelector(_cmd)];
}
- (NSString *) action4Suffix:(NSUInteger)tag;
{
	self.tag=self.tag+4*tag;
	return [NSString stringWithFormat:@"action4Suffix:=%@",NSStringFromSelector(_cmd)];
}
+ (NSString *) action13Suffix:(NSUInteger)tag;
{
	return [NSString stringWithFormat:@"action13Suffix:=%@",NSStringFromSelector(_cmd)];
}
+ (NSString *) action14Suffix:(NSUInteger)tag;
{
	return [NSString stringWithFormat:@"action14Suffix:=%@",NSStringFromSelector(_cmd)];
}
@end
