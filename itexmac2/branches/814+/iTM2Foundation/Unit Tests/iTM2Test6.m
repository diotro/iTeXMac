//
//  iTM2Test4
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

#import "iTM2ButtonKit.h"
#import "iTM2CursorKit.h"
#import "iTM2EventKit.h"
#import "iTM2ImageKit.h"
#import "iTM2MenuKit.h"
#import "iTM2ResponderKit.h"
#import "iTM2ValidationKit.h"
#import "iTM2ViewKit.h"
#import "iTM2WindowKit.h"

#import "iTM2ContextKit.h"
#import "iTM2AutoKit.h"
#import "iTM2MacroKit.h"
#import "iTM2MacroKit_String.h"
#import "iTM2DocumentKit.h"
#import "iTM2InheritanceKit.h"
#import "iTM2ApplicationDelegate.h"

#import "iTM2ProjectDocumentKit.h"
#import "iTM2ProjectControllerKit.h"
#import "iTM2InfoWrapperKit.h"

#import "iTM2SystemSignalKit.h"
#import "iTM2Responders.h"
#import "iTM2SpellKit.h"
#import "iTM2ProjectSpellKit.h"
#import "iTM2TaskKit.h"
#import "iTM2StartupKit.h"

#import "iTM2TextStyleEditionKit.h"
#import "iTM2TextStorageKit.h"

#import "iTM2LiteScanner.h"
#import "iTM2StringControllerKit.h"
#import "iTM2StringControllerKitPrivate.h"
#import "iTM2TextDocumentKit.h"
#import "iTM2TextKit.h"

#import "iTM2Test6.h"

@implementation iTM2Test6
- (void) setUp
{
    // Create data structures here.
}

- (void) tearDown
{
    // Release data structures here.
}
- (void)testCase_StringEncoding;
{
    NSString * path = [[NSProcessInfo processInfo] globallyUniqueString];
    path = [NSTemporaryDirectory() stringByAppendingPathComponent:path];
    path = [path stringByAppendingPathComponent:@"test.txt"];
    NSURL * URL = [NSURL fileURLWithPath:path];
    NSError * ROR = nil;
    STAssertTrue(([[NSFileManager defaultManager] createDirectoryAtPath:path.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:&ROR]),@"MISSED",NULL);
    NSData * aValue = [@"énorméﬁê∂Òæ" dataUsingEncoding:NSUTF8StringEncoding];
    NSFileWrapper * FW = [[NSFileWrapper alloc] initRegularFileWithContents:aValue];
    STAssertTrue(([FW writeToURL:URL options:ZER0 originalContentsURL:nil error:&ROR]),@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    NSString * typeName = [SDC typeForContentsOfURL:URL error:&ROR];
    iTM2TextDocument * D = [[iTM2TextDocument alloc] initWithContentsOfURL:URL ofType:typeName error:&ROR];
    NSLog(@"D:%@",D.textStorage);
    return;
}

@end

