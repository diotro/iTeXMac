//
//  iTM2Test0A
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
#import "iTM2StringKit.h"
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
	[self.class postNotificationWithStatus4iTM3:theStatus1];
	STAssertEqualObjects(theStatus1,[statusField stringValue],@"Notification posted 1",@"");
	[self.class postNotificationWithStatus4iTM3:theStatus2];
	STAssertEqualObjects(theStatus2,[statusField stringValue],@"Notification posted 2",@"");
	[self postNotificationWithStatus4iTM3:theStatus1];
	STAssertEqualObjects(theStatus1,[statusField stringValue],@"Notification posted 1",@"");
	[self postNotificationWithStatus4iTM3:theStatus2];
	STAssertEqualObjects(theStatus2,[statusField stringValue],@"Notification posted 2",@"");
	[self postNotificationWithStatus4iTM3:@""];
	[self.class postNotificationWithToolTip4iTM3:theStatus1];
	STAssertEqualObjects(theStatus1,[statusField stringValue],@"Notification posted 1",@"");
	[self.class postNotificationWithToolTip4iTM3:theStatus2];
	STAssertEqualObjects(theStatus2,[statusField stringValue],@"Notification posted 2",@"");
	[self postNotificationWithToolTip4iTM3:theStatus1];
	STAssertEqualObjects(theStatus1,[statusField stringValue],@"Notification posted 1",@"");
	[self postNotificationWithToolTip4iTM3:theStatus2];
	STAssertEqualObjects(theStatus2,[statusField stringValue],@"Notification posted 2",@"");
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithFloat:1],  iTM2StatusTimeOutKey,
						   nil]];
	[self postNotificationWithToolTip4iTM3:theStatus2];
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
	[[NSInvocation  getInvocation4iTM3:&I withTarget:myObject retainArguments:NO] action1Suffix:10];
	NSPointerArray * selectors = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	[I invokeWithSelectors4iTM3:selectors];
	STAssertEquals(myObject.tag,(NSUInteger)ZER0,@"iTM2InvocationKit test 1: ",nil);
	myObject.tag = ZER0;
	[selectors addPointer:@selector(action1Suffix:)];
	[I invokeWithSelectors4iTM3:selectors];
	STAssertEquals(myObject.tag,(NSUInteger)10,@"iTM2InvocationKit test 2: ",nil);
	myObject.tag = ZER0;
	[selectors addPointer:@selector(action2Suffix:)];
	[I invokeWithSelectors4iTM3:selectors];
	STAssertEquals(myObject.tag,(NSUInteger)30,@"iTM2InvocationKit test 3: ",nil);
}
- (void)testCase_iTM2Runtime_instances
{
	NSMutableSet * set1 = [NSMutableSet set];
	NSMutableSet * set2 = [NSMutableSet set];
	NSUInteger i;
	NSMethodSignature * MS = [MyParent instanceMethodSignatureForSelector:@selector(action1Suffix:)];
	NSPointerArray * ans = [iTM2Runtime instanceSelectorsOfClass:[MyParent class] withSuffix:@"Suffix:" signature:MS inherited:NO];
	for(i = ZER0;i<ans.count;++i) {
		[set1 addObject:NSStringFromSelector((SEL)[ans pointerAtIndex:i])];
	}
	NSPointerArray * selectors = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	[selectors addPointer:@selector(action1Suffix:)];
	[selectors addPointer:@selector(action2Suffix:)];
	for(i = ZER0;i<selectors.count;++i) {
		[set2 addObject:NSStringFromSelector((SEL)[selectors pointerAtIndex:i])];
	}
	STAssertEqualObjects(set1,set2,@"instance selectors",nil);
	[selectors setCount:ZER0];
	set1 = [NSMutableSet set];
	set2 = [NSMutableSet set];
	ans = [iTM2Runtime instanceSelectorsOfClass:[MySon class] withSuffix:@"Suffix:" signature:MS inherited:NO];
	[selectors addPointer:@selector(action3Suffix:)];
	[selectors addPointer:@selector(action4Suffix:)];
	STAssertEqualObjects(ans,selectors,@"instance selectors",nil);
	ans = [iTM2Runtime instanceSelectorsOfClass:[MySon class] withSuffix:@"Suffix:" signature:MS inherited:YES];
	for(i = ZER0;i<ans.count;++i) {
		[set1 addObject:NSStringFromSelector((SEL)[ans pointerAtIndex:i])];
	}
	[selectors addPointer:@selector(action1Suffix:)];
	[selectors addPointer:@selector(action2Suffix:)];
	for(i = ZER0;i<selectors.count;++i) {
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
	for(i = ZER0;i<ans.count;++i) {
		[set1 addObject:NSStringFromSelector((SEL)[ans pointerAtIndex:i])];
	}
	NSPointerArray * selectors = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	[selectors addPointer:@selector(action11Suffix:)];
	[selectors addPointer:@selector(action12Suffix:)];
	for(i = ZER0;i<selectors.count;++i) {
		[set2 addObject:NSStringFromSelector((SEL)[selectors pointerAtIndex:i])];
	}
	STAssertEqualObjects(set1,set2,@"instance selectors",nil);
	[selectors setCount:ZER0];
	set1 = [NSMutableSet set];
	set2 = [NSMutableSet set];
	ans = [iTM2Runtime classSelectorsOfClass:[MySon class] withSuffix:@"Suffix:" signature:MS inherited:NO];
	[selectors addPointer:@selector(action13Suffix:)];
	[selectors addPointer:@selector(action14Suffix:)];
	STAssertEqualObjects(ans,selectors,@"instance selectors",nil);
	ans = [iTM2Runtime classSelectorsOfClass:[MySon class] withSuffix:@"Suffix:" signature:MS inherited:YES];
	for(i = ZER0;i<ans.count;++i) {
		[set1 addObject:NSStringFromSelector((SEL)[ans pointerAtIndex:i])];
	}
	[selectors addPointer:@selector(action11Suffix:)];
	[selectors addPointer:@selector(action12Suffix:)];
	for(i = ZER0;i<selectors.count;++i) {
		[set2 addObject:NSStringFromSelector((SEL)[selectors pointerAtIndex:i])];
	}
	STAssertEqualObjects(set1,set2,@"instance selectors",nil);
}
- (void)testCase_iTM2Runtime_swizzle
{
	MyParent * myParent = [MyParent new];
	
	STAssertEqualObjects([myParent action1Suffix:ZER0],@"action1Suffix:=action1Suffix:",@"swizzling 1-a",nil);
	STAssertEqualObjects([myParent action2Suffix:ZER0],@"action2Suffix:=action2Suffix:",@"swizzling 1-b",nil);
	STAssertTrue([iTM2Runtime swizzleInstanceMethodSelector:@selector(action1Suffix:) replacement:@selector(action2Suffix:) forClass:[MyParent class] error:NULL],@"swizzling 1-c",nil);
	STAssertEqualObjects([myParent action1Suffix:ZER0],@"action2Suffix:=action1Suffix:",@"swizzling 1-d",nil);
	STAssertEqualObjects([myParent action2Suffix:ZER0],@"action1Suffix:=action2Suffix:",@"swizzling 1-e",nil);
	STAssertTrue([iTM2Runtime swizzleInstanceMethodSelector:@selector(action2Suffix:) replacement:@selector(action1Suffix:) forClass:[MyParent class] error:NULL],@"swizzling 1-c",nil);
	STAssertEqualObjects([myParent action1Suffix:ZER0],@"action1Suffix:=action1Suffix:",@"swizzling 1-a",nil);
	STAssertEqualObjects([myParent action2Suffix:ZER0],@"action2Suffix:=action2Suffix:",@"swizzling 1-b",nil);

	STAssertEqualObjects([MyParent action11Suffix:ZER0],@"action11Suffix:=action11Suffix:",@"swizzling 2-a",nil);
	STAssertEqualObjects([MyParent action12Suffix:ZER0],@"action12Suffix:=action12Suffix:",@"swizzling 2-b",nil);
	STAssertTrue([iTM2Runtime swizzleClassMethodSelector:@selector(action11Suffix:) replacement:@selector(action12Suffix:) forClass:[MyParent class] error:NULL],@"swizzling 2-c",nil);
	STAssertEqualObjects([MyParent action11Suffix:ZER0],@"action12Suffix:=action11Suffix:",@"swizzling 2-d",nil);
	STAssertEqualObjects([MyParent action12Suffix:ZER0],@"action11Suffix:=action12Suffix:",@"swizzling 2-e",nil);
	STAssertTrue([iTM2Runtime swizzleClassMethodSelector:@selector(action12Suffix:) replacement:@selector(action11Suffix:) forClass:[MyParent class] error:NULL],@"swizzling 2-c",nil);
	STAssertEqualObjects([MyParent action11Suffix:ZER0],@"action11Suffix:=action11Suffix:",@"swizzling 2-a",nil);
	STAssertEqualObjects([MyParent action12Suffix:ZER0],@"action12Suffix:=action12Suffix:",@"swizzling 2-b",nil);

	MySon * mySon = [MySon new];

	STAssertEqualObjects([mySon action1Suffix:ZER0],@"action1Suffix:=action1Suffix:",@"swizzling 3-a",nil);
	STAssertEqualObjects([mySon action3Suffix:ZER0],@"action3Suffix:=action3Suffix:",@"swizzling 3-b",nil);
	STAssertTrue([iTM2Runtime swizzleInstanceMethodSelector:@selector(action1Suffix:) replacement:@selector(action3Suffix:) forClass:[MySon class] error:NULL],@"swizzling 3-c",nil);
	STAssertEqualObjects([mySon action1Suffix:ZER0],@"action3Suffix:=action1Suffix:",@"swizzling 3-d",nil);
	STAssertEqualObjects([myParent action1Suffix:ZER0],@"action1Suffix:=action1Suffix:",@"swizzling 3-d'",nil);
	STAssertEqualObjects([mySon action3Suffix:ZER0],@"action1Suffix:=action3Suffix:",@"swizzling 3-e",nil);
	
	STAssertEqualObjects([MySon action11Suffix:ZER0],@"action11Suffix:=action11Suffix:",@"swizzling 4-a",nil);
	STAssertEqualObjects([MySon action13Suffix:ZER0],@"action13Suffix:=action13Suffix:",@"swizzling 4-b",nil);
	STAssertTrue([iTM2Runtime swizzleClassMethodSelector:@selector(action11Suffix:) replacement:@selector(action13Suffix:) forClass:[MySon class] error:NULL],@"swizzling 4-c",nil);
	STAssertEqualObjects([MySon action11Suffix:ZER0],@"action13Suffix:=action11Suffix:",@"swizzling 4-d",nil);
	STAssertEqualObjects([MyParent action11Suffix:ZER0],@"action11Suffix:=action11Suffix:",@"swizzling 4-d'",nil);
	STAssertEqualObjects([MySon action13Suffix:ZER0],@"action11Suffix:=action13Suffix:",@"swizzling 4-e",nil);
}
- (void) testCase_iTM2CommentedKeyValuePairs
{
	NSString * testString = @"First line\nSecond %  ! iTeXMac2 (  KEY ) :  VALUE1 line\nThird line%  ! iTeXMac2 (  KEY ) :  VaLuE-2\nAnd so on";
	NSLog(@"testString:%@",testString);
	NSError * error = nil;
	ICURegEx * RE = [[ICURegEx alloc] initWithSearchPattern:@"%\\s*?!\\s*?(?i-:itexmac2)\\s*?\\(\\s*?KEY\\s*?\\)\\s*?:\\s*?(\\S+)" options:ZER0 error:&error];
	[RE setInputString:testString range:iTM3MakeRange(ZER0,testString.length)];
	STAssertTrue([RE nextMatch],@"Missed match 1",nil);
	STAssertTrue([RE numberOfCaptureGroups]==1,@"Missed match 2",nil);
	NSString * S = [RE substringOfCaptureGroupAtIndex:1];
	NSLog(@"S:<%@>",S);
	STAssertEqualObjects(S,@"VALUE1",@"Missed match 3",nil);
	NSRange R = [RE rangeOfCaptureGroupAtIndex:ZER0];
	STAssertTrue([RE nextMatchAfterIndex:R.location+1],@"Missed match 11",nil);
	STAssertTrue([RE numberOfCaptureGroups]==1,@"Missed match 12",nil);
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
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:@"^#!\\S*/([^/\\s]+)" options:ZER0 error:&error] autorelease];
	[RE setInputString:testString range:iTM3MakeRange(ZER0,testString.length)];
	STAssertTrue([RE nextMatch],@"Missed match 1",nil);
	STAssertTrue([RE numberOfCaptureGroups] == 1,@"Missed match 2",nil);
	NSString * S = [RE substringOfCaptureGroupAtIndex:1];
	NSLog(@"S:<%@>",S);
	STAssertEqualObjects(S,@"lua",@"Missed match 3",nil);
	return;
}
- (void) testCase_URLsForSupportResource4iTM3_A;
{
    // create a bundle form scratch
    NSURL * U = [NSURL fileURLWithPath:NSTemporaryDirectory()];
    NSURL * URL_B = [U URLByAppendingPathComponent:@"BUNDLE.iTM2"];
    NSError * ROR = nil;
    [DFM removeItemAtURL:URL_B error:&ROR];
    STAssertFalse(([DFM fileExistsAtPath:URL_B.path]),@"MISSED",NULL);
    NSURL * URL_C = [URL_B URLByAppendingPathComponent:@"Contents"];
    NSURL * URL_R = [URL_C URLByAppendingPathComponent:@"Resources"];
    [DFM createDirectoryAtPath:URL_R.path withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:&ROR];
    BOOL yorn = NO;
    STAssertTrue(([DFM fileExistsAtPath:URL_B.path isDirectory:&yorn] && yorn),@"MISSED",NULL);
#   define NAME @"NAME"
#   define EXT  @"EXT"
    NSURL * URL_D = [URL_R URLByAppendingPathComponent:NAME@"."EXT];
    NSData * D = [@"ﬁºÌ∂ÂÂ" dataUsingEncoding:NSUTF8StringEncoding];
    ROR = nil;
    STAssertTrue(([D writeToURL:URL_D options:ZER0 error:&ROR]),@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
#   define SUBDIR @"COUCOU"
    NSURL * URL_S = [URL_R URLByAppendingPathComponent:SUBDIR];
    [DFM createDirectoryAtPath:URL_S.path withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:&ROR];
    NSURL * URL_SD = [URL_S URLByAppendingPathComponent:NAME@"."EXT];
    ROR = nil;
    STAssertTrue(([D writeToURL:URL_SD options:ZER0 error:&ROR]),@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertTrue(([DFM fileExistsAtPath:URL_SD.path]),@"MISSED",NULL);
    NSBundle * B = [NSBundle bundleWithURL:URL_B];
    NSURL * URL_x = [B URLForResource:NAME withExtension:EXT];
    NSURL * URL_y = [B URLForResource:NAME withExtension:EXT subdirectory:SUBDIR];
    if (!URL_x) {
        NSLog(@"FAILUREx");
    }
    if (!URL_y) {
        NSLog(@"FAILUREx");
    }
    STAssertNotNil([B URLForResource:NAME withExtension:EXT],@"MISSED",NULL);
    STAssertNotNil([B URLForResource:NAME withExtension:EXT subdirectory:SUBDIR],@"MISSED",NULL);
    STAssertTrue([[B URLsForResourcesWithExtension:EXT subdirectory:nil] count] == 1,@"MISSED",NULL);
    STAssertTrue([[B URLsForResourcesWithExtension:EXT subdirectory:SUBDIR] count] == 1,@"MISSED",NULL);
#   undef NAME
#   undef EXT
    return;
}
- (void) testCase_URLsForSupportResource4iTM3;
{
    //  Test an already exiting bundle
    NSURL * URL_B = [NSURL fileURLWithPath:@"/Users/itexmac2/Library/Application Support/Test Application/PlugIns.localized/bundle.extension"];
#   define NAME @"NAME"
#   define EXT  @"EXT"
#   define SUBDIR @"COUCOU"
    NSBundle * B = [NSBundle bundleWithURL:URL_B];
    NSURL * URL_x = [B URLForResource:NAME withExtension:EXT];
    NSURL * URL_y = [B URLForResource:NAME withExtension:EXT subdirectory:SUBDIR];
    if (!B) {
        NSLog(@"NO TEST for an already existing bundle");
    }
    if (B && !URL_x) {
        NSLog(@"FAILUREx");
    }
    if (B && !URL_y) {
        NSLog(@"FAILUREy");
    }
    // create a bundle form scratch
    NSBundle * MB = [NSBundle mainBundle];
    NSURL * U = [MB URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:YES];
    URL_B = [U URLByAppendingPathComponent:@"BUNDLE.iTM2"];
    NSError * ROR = nil;
    [DFM removeItemAtURL:URL_B error:&ROR];
    STAssertFalse(([DFM fileExistsAtPath:URL_B.path]),@"MISSED",NULL);
    NSURL * URL_C = [URL_B URLByAppendingPathComponent:@"Contents"];
    NSURL * URL_R = [URL_C URLByAppendingPathComponent:@"Resources"];
    [DFM createDirectoryAtPath:URL_R.path withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:&ROR];
    BOOL yorn = NO;
    STAssertTrue(([DFM fileExistsAtPath:URL_B.path isDirectory:&yorn] && yorn),@"MISSED",NULL);
    NSURL * URL_D = [URL_R URLByAppendingPathComponent:NAME@"."EXT];
    NSData * D = [@"ﬁºÌ∂ÂÂ" dataUsingEncoding:NSUTF8StringEncoding];
    ROR = nil;
    STAssertTrue(([D writeToURL:URL_D options:ZER0 error:&ROR]),@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertTrue(([DFM fileExistsAtPath:URL_D.path]),@"MISSED",NULL);
    NSURL * URL_S = [URL_R URLByAppendingPathComponent:SUBDIR];
    [DFM createDirectoryAtPath:URL_S.path withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:&ROR];
    NSURL * URL_SD = [URL_S URLByAppendingPathComponent:NAME@"."EXT];
    ROR = nil;
    STAssertTrue(([D writeToURL:URL_SD options:ZER0 error:&ROR]),@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertTrue(([DFM fileExistsAtPath:URL_SD.path]),@"MISSED",NULL);
    [SWS noteFileSystemChanged:URL_S.path];
    [SWS noteFileSystemChanged:URL_SD.path];
    B = [NSBundle bundleWithURL:URL_B];
    NSURL * url = [B.resourceURL URLByAppendingPathComponent:NAME@"."EXT];
    STAssertTrue((url.path.length && [DFM fileExistsAtPath:url.path]),@"MISSED",NULL);
    url = [B.resourceURL URLByAppendingPathComponent:SUBDIR@"/"NAME@"."EXT];
    STAssertTrue((url.path.length && [DFM fileExistsAtPath:url.path]),@"MISSED",NULL);
    URL_x = [B URLForResource:NAME withExtension:EXT];
    URL_y = [B URLForResource:NAME withExtension:EXT subdirectory:SUBDIR];
    if (!URL_x) {
        NSLog(@"FAILUREx");// please restart, there is an unsolved bug
    }
    if (!URL_y) {
        NSLog(@"FAILUREy");
    }
    STAssertNotNil([B URLForResource:NAME withExtension:EXT],@"MISSED",NULL);
    STAssertNotNil([B URLForResource:NAME withExtension:EXT subdirectory:SUBDIR],@"MISSED",NULL);
    STAssertTrue([[B URLsForResourcesWithExtension:EXT subdirectory:nil] count] == 1,@"MISSED",NULL);
    STAssertTrue([[B URLsForResourcesWithExtension:EXT subdirectory:SUBDIR] count] == 1,@"MISSED",NULL);
    NSArray * RA = [MB URLsForSupportResource4iTM3:NAME withExtension:EXT subdirectory:nil];
	STAssertTrue(RA.count == 1 && [RA.lastObject isEqualToFileURL4iTM3:URL_D],@"MISSED",nil);
    RA = [MB URLsForSupportResource4iTM3:NAME withExtension:EXT subdirectory:SUBDIR];
	STAssertTrue(RA.count == 1 && [RA.lastObject isEqualToFileURL4iTM3:URL_SD],@"MISSED",nil);
    [DFM removeItemAtURL:URL_B error:&ROR];
    STAssertFalse(([DFM fileExistsAtPath:URL_B.path]),@"MISSED",NULL);
#   undef SUBDIR
#   undef NAME
#   undef EXT
    return;
}
- (void) testCase_URL
{
    ICURegEx * RE = [ICURegEx regExWithSearchPattern:@"([a-z]*)(:)" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    
    RE = [ICURegEx regExForKey:@"URL scheme" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    RE = [ICURegEx regExForKey:@"URL network location" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    RE = [ICURegEx regExForKey:@"URL path" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    RE = [ICURegEx regExForKey:@"URL parameters" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    RE = [ICURegEx regExForKey:@"URL query" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    RE = [ICURegEx regExForKey:@"URL fragment" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;

    RE = [ICURegEx regExForKey:@"URL debug - 1" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    RE = [ICURegEx regExForKey:@"URL debug - 2" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    RE = [ICURegEx regExForKey:@"URL debug - 3" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    RE = [ICURegEx regExForKey:@"URL debug - 4" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    RE = [ICURegEx regExForKey:@"URL debug - 5" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    RE = [ICURegEx regExForKey:@"URL" error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    RE = [ICURegEx regExForKey:iTM2RegExpURLKey error:NULL];
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;

#   define GOOD [NSNumber numberWithBool:YES]
#   define BAD  [NSNumber numberWithBool:NO]

    NSArray * schemesRA = [NSArray arrayWithObjects:
        @"scheme", GOOD,
        @"sch#eme", BAD,
        @"sc.h+em-e", GOOD,
            nil];
    NSArray * locationsRA = [NSArray arrayWithObjects:
        @"", @"", BAD,
        @"//where", @"where", GOOD,
        @"//user:password@domain", @"user:password@domain", GOOD,
            nil];
    NSArray * pathsRA = [NSArray arrayWithObjects:
        //@"", BAD,
        @"/the", GOOD,
        @"/the/path", GOOD,
        @"/pa$-_+!*'(),:@&=th", GOOD,
        @"/the/pa$-_+!*'(),:@&=th", GOOD,
        @"/th%FFe/pa$-_+!*'(),:@&=th", GOOD,
        //@"/th%DGe/pa$-_+!*'(),:@&=th", BAD,
            nil];
    NSArray * pathTrailersRA = [NSArray arrayWithObjects:
        @"", @"", GOOD,
        @"", @"/", GOOD,
        @"", @"/.", GOOD,
        @"", @"/..", GOOD,
        @"/", @"/", GOOD,
        @"/", @"/.", GOOD,
        @"/", @"/..", GOOD,
        @"//", @"/", GOOD,
        @"//", @"/.", GOOD,
        @"//", @"/..", GOOD,
        @"/.a", @"", GOOD,
        @"/..a", @"", GOOD,
            nil];
    NSArray * parametersRA = [NSArray arrayWithObjects:
        @"", GOOD,
        @"params", GOOD,
        @"a-zA-Z0-9$-_+.!*''(),:@&=/;%Ffasd", GOOD,
        //@";a-zA-Z0-9\$\-_+\.!*''(),:@&=/;%Gdasd", BAD,
            nil];
    NSArray * queriesRA = [NSArray arrayWithObjects:
        @"", GOOD,
        @"query", GOOD,
        @";a-zA-Z0-9$-_+.!*''(),;:@&=/;%Ffasd", GOOD,
        //@";a-zA-Z0-9\$\-_+\.!*''(),;:@&=/;%Gdasd", BAD,
            nil];
    NSArray * fragmentsRA = [NSArray arrayWithObjects:
        @"", GOOD,
        @"#", GOOD,
        @"#fragment", GOOD,
        @"#a-zA-Z0-9$-_+#.!*''(),;:@&=/;%Ffasd", GOOD,
        //@";a-zA-Z0-9\$\-_+#\.!*''(),;:@&=/;%Gdasd", BAD,
            nil];
    #define DECLARE(WHAT)\
    NSEnumerator * WHAT##E = WHAT##RA.objectEnumerator;\
    NSString * WHAT##S = nil;\
    NSString * WHAT##X = nil;\
    NSNumber * WHAT##N = nil;
    DECLARE(schemes);
    while ((schemesS = schemesE.nextObject) && (schemesN = schemesE.nextObject)) {
        DECLARE(locations);
        while ((locationsS = locationsE.nextObject) && (locationsX = locationsE.nextObject) && (locationsN = locationsE.nextObject)) {
            DECLARE(paths);
            while ((pathsS = pathsE.nextObject) && (pathsN = pathsE.nextObject)) {
                DECLARE(pathTrailers);
                NSString * prePathTrailersS = nil;
                while ((prePathTrailersS = pathTrailersE.nextObject) && (pathTrailersS = pathTrailersE.nextObject) && (pathTrailersN = pathTrailersE.nextObject)) {
                    DECLARE(parameters);
                    while ((parametersS = parametersE.nextObject) && (parametersN = parametersE.nextObject)) {
                        DECLARE(queries);
                        while ((queriesS = queriesE.nextObject) && (queriesN = queriesE.nextObject)) {
                            DECLARE(fragments);
                            while ((fragmentsS = fragmentsE.nextObject) && (fragmentsN = fragmentsE.nextObject)) {
                                NSString * input = [NSString stringWithFormat:@"%@:%@%@%@%@%@%@%@",
                                    schemesS,locationsS,pathsS,prePathTrailersS,pathTrailersS,
                                        (parametersS.length?([parametersS hasPrefix:@";"]?parametersS:[@";" stringByAppendingString:parametersS]):parametersS),
                                        (queriesS.length?([queriesS hasPrefix:@"?"]?queriesS:[@"?" stringByAppendingString:queriesS]):queriesS),
                                        (fragmentsS.length?([fragmentsS hasPrefix:@"#"]?fragmentsS:[@"#" stringByAppendingString:fragmentsS]):fragmentsS),
                                            nil];
                                RE.inputString = input;
                                RE.nextMatch;
                                //RE.displayMatchResult;
                                #   define TEST(what,name)\
                                    STAssertTrue([what isEqual:[RE substringOfCaptureGroupWithName:name]] || (RE.displayMatchResult,NO),@"MISSED",NULL)
                                if (schemesN.boolValue) {
                                    TEST(schemesS,iTM2RegExpURLSchemeName);
                                    if (locationsN.boolValue) {
                                        TEST(locationsX,iTM2RegExpURLLocationName);
                                        if (pathsN.boolValue) {
                                            if (pathTrailersN.boolValue) {
                                                TEST(([NSString stringWithFormat:@"%@%@%@",pathsS,prePathTrailersS,pathTrailersS,nil]),iTM2RegExpURLPathName);
                                                TEST(pathTrailersS,iTM2RegExpURLPathTrailerName);
                                                if (parametersN.boolValue) {
                                                    TEST(([parametersS hasPrefix:@";"]?[parametersS substringFromIndex:1]:parametersS),iTM2RegExpURLParametersName);
                                                    if (queriesN.boolValue) {
                                                        TEST(([queriesS hasPrefix:@"?"]?[queriesS substringFromIndex:1]:queriesS),iTM2RegExpURLQueryName);
                                                        if (fragmentsN.boolValue) {
                                                            TEST(([fragmentsS hasPrefix:@"#"]?[fragmentsS substringFromIndex:1]:fragmentsS),iTM2RegExpURLFragmentName);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    #if 1
    RE = [ICURegEx regExForKey:iTM2RegExpURLKey error:NULL];
    [RE setInputString:@"scheme://location"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    //
    [RE setInputString:@"scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt"];
    STAssertTrue(RE.nextMatch,@"MISSED",NULL);
    RE.displayMatchResult;
    STAssertEqualObjects([RE substringOfCaptureGroupWithName:iTM2RegExpURLSchemeName], @"scheme",@"MISSED",NULL);
    STAssertEqualObjects([RE substringOfCaptureGroupWithName:iTM2RegExpURLLocationName], @"location@yoyodine.net",@"MISSED",NULL);
    STAssertEqualObjects([RE substringOfCaptureGroupWithName:iTM2RegExpURLPathName], @"/the/path/../.",@"MISSED",NULL);
    STAssertEqualObjects([RE substringOfCaptureGroupWithName:iTM2RegExpURLPathTrailerName], @"/.",@"MISSED",NULL);
    STAssertEqualObjects([RE substringOfCaptureGroupWithName:iTM2RegExpURLParametersName], @"pa;ram/et;ers",@"MISSED",NULL);
    STAssertEqualObjects([RE substringOfCaptureGroupWithName:iTM2RegExpURLQueryName], @"que;ry",@"MISSED",NULL);
    STAssertEqualObjects([RE substringOfCaptureGroupWithName:iTM2RegExpURLFragmentName], @"frag/me?nt",@"MISSED",NULL);
    #endif
    return;
}
- (void) testCase_URLXtdAttributes
{
    NSString * path = [[NSProcessInfo processInfo] globallyUniqueString];
    path = [NSTemporaryDirectory() stringByAppendingPathComponent:path];
    NSURL * URL = [NSURL fileURLWithPath:path];
    NSError * ROR = nil;
    NSArray * RA = [URL getXtdAttributeNames4iTM3WithOptions:ZER0 error:&ROR];
    STAssertNil(RA,@"MISSED",NULL);
    STAssertNotNil(ROR,@"MISSED",NULL);
    ROR = nil;
    STAssertTrue(([[NSFileManager defaultManager] createDirectoryAtPath:path.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:&ROR]),@"MISSED",NULL);
    NSString * aName = @"Attribute.name";
    NSData * aValue = [@"coucou" dataUsingEncoding:NSUTF8StringEncoding];
    STAssertFalse(([URL setXtdAttribute4iTM3:aValue forName:aName options:ZER0 error:&ROR]),@"MISSED",NULL);
    NSFileWrapper * FW = [[NSFileWrapper alloc] initRegularFileWithContents:aValue];
    STAssertTrue(([FW writeToURL:URL options:ZER0 originalContentsURL:nil error:&ROR]),@"MISSED",NULL);
    RA = [URL getXtdAttributeNames4iTM3WithOptions:ZER0 error:&ROR];
    STAssertNotNil(RA,@"MISSED",NULL);
    STAssertTrue((RA.count==ZER0),@"MISSED",NULL);
    STAssertNotNil(ROR,@"MISSED",NULL);
    ROR = nil;
    STAssertTrue(([URL setXtdAttribute4iTM3:aValue forName:aName options:ZER0 error:&ROR]),@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    RA = [URL getXtdAttributeNames4iTM3WithOptions:ZER0 error:&ROR];
    STAssertNotNil(RA,@"MISSED",NULL);
    STAssertTrue((RA.count==1),@"MISSED",NULL);
    STAssertEqualObjects(RA.lastObject,aName,@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertEqualObjects(aValue,([URL getXtdAttribute4iTM3ForName:aName options:ZER0 error:&ROR]),@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    aValue = [@"coucou rou coucou" dataUsingEncoding:NSUTF8StringEncoding];
    STAssertTrue(([URL setXtdAttribute4iTM3:aValue forName:aName options:ZER0 error:&ROR]),@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    RA = [URL getXtdAttributeNames4iTM3WithOptions:ZER0 error:&ROR];
    STAssertNotNil(RA,@"MISSED",NULL);
    STAssertTrue((RA.count==1),@"MISSED",NULL);
    STAssertEqualObjects(RA.lastObject,aName,@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertEqualObjects(aValue,([URL getXtdAttribute4iTM3ForName:aName options:ZER0 error:&ROR]),@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertFalse(([URL removeXtdAttribute4iTM3ForName:@"" options:ZER0 error:&ROR]),@"MISSED",NULL);
    STAssertNotNil(ROR,@"MISSED",NULL);
    ROR = nil;
    STAssertTrue(([URL removeXtdAttribute4iTM3ForName:aName options:ZER0 error:&ROR]),@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    RA = [URL getXtdAttributeNames4iTM3WithOptions:ZER0 error:&ROR];
    STAssertNotNil(RA,@"MISSED",NULL);
    STAssertTrue((RA.count==ZER0),@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    
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
